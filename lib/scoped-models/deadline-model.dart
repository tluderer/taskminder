import "dart:collection";
import 'package:scoped_model/scoped_model.dart';
import '../models/deadline.dart';
import '../database/local-db.dart';

mixin DeadlineModel on Model {
  List<Deadline> _deadlines = [];

  // SplayTreeMap to provide a sorted Map
  SplayTreeMap<String, List<Deadline>> _deadlinesByDeadline =
      SplayTreeMap.from({});
  bool _areDeadlinesLoading = false;
  int _deadlinesCount;

  List<Deadline> get deadlines {
    return _deadlines;
  }

  Map<String, List<Deadline>> get deadlinesByDeadline {
    return _deadlinesByDeadline;
  }

  bool get areDeadlinesLoading {
    return _areDeadlinesLoading;
  }

  int get deadlinesCount {
    return _deadlinesCount;
  }

  int get differentDeadlineCount {
    return _deadlinesByDeadline.length;
  }

  Deadline deadlineById(String id) {
    Deadline deadline = _deadlines.firstWhere((element) {
      return element.id == id;
    });
    return deadline;
  }

  getAllDeadlinesLocal({bool showIncompleted, bool showCompleted}) async {
    _areDeadlinesLoading = true;
    notifyListeners();
    _deadlines = [];
    List<Map<String, dynamic>> rawTasksData =
        await LocalDB.db.fetchAllDeadlines();
    rawTasksData.forEach((deadline) {
      if (showIncompleted == true && deadline['isCompleted'] == 0) {
        _deadlines.add(Deadline(
          id: deadline['id'],
          name: deadline["name"],
          description: deadline["description"],
          priority: deadline['priority'],
          deadline: deadline['deadline'],
          deadlineTime: deadline['deadlineTime'],
          timeInvestment: deadline['timeInvestment'],
          isCompleted: deadline['isCompleted'] == 1 ? true : false,
        ));
      }
      if (showCompleted == true && deadline['isCompleted'] == 1) {
        _deadlines.add(Deadline(
          id: deadline['id'],
          name: deadline["name"],
          description: deadline["description"],
          priority: deadline['priority'],
          deadline: deadline['deadline'],
          deadlineTime: deadline['deadlineTime'],
          timeInvestment: deadline['timeInvestment'],
          isCompleted: deadline['isCompleted'] == 1 ? true : false,
        ));
      }
    });
    if (_deadlines.length != 0) {
      _deadlines.sort((Deadline a, Deadline b) {
        return b.calculatedPriority - a.calculatedPriority;
      });
    }
    _deadlinesCount = _deadlines.length;
    _areDeadlinesLoading = false;
    notifyListeners();
  }

  getLocalDeadlinesByDeadline() async {
    _areDeadlinesLoading = true;
    notifyListeners();
    _deadlinesByDeadline = SplayTreeMap.from({});
    List<Map<String, dynamic>> rawTasksData =
        await LocalDB.db.fetchAllDeadlines();

    rawTasksData.forEach((rawTask) {
      if (rawTask['isCompleted'] == 0) {
        if (_deadlinesByDeadline[rawTask["deadline"]] == null) {
          _deadlinesByDeadline[rawTask["deadline"]] = [];
        }

        _deadlinesByDeadline[rawTask["deadline"]].add(Deadline(
          id: rawTask['id'],
          name: rawTask["name"],
          description: rawTask["description"],
          priority: rawTask['priority'],
          deadline: rawTask['deadline'],
          deadlineTime: rawTask['deadlineTime'],
          timeInvestment: rawTask['timeInvestment'],
          isCompleted: false,
        ));
      }
    });

    _areDeadlinesLoading = false;
    notifyListeners();
  }

  Future<Null> updateDeadline(String _deadlineId, Deadline newDeadline) async {
    _areDeadlinesLoading = true;
    notifyListeners();
    await LocalDB.db.updateDeadline(_deadlineId, newDeadline);
    _areDeadlinesLoading = false;

    notifyListeners();
  }

  Future<bool> insertDeadline(Deadline deadline) async {
    _areDeadlinesLoading = true;
    notifyListeners();
    await LocalDB.db.insertDeadline(deadline);
    _areDeadlinesLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> deadlineExists(String id) async {
    List<Map<String, dynamic>> queriedDeadline =
        await LocalDB.db.checkDeadlineId(id);
    notifyListeners();
    if (queriedDeadline.isNotEmpty) return true;
    return false;
  }

  Future<Null> deleteDeadlineLocal(String id) async {
    _areDeadlinesLoading = true;
    notifyListeners();
    await LocalDB.db.deleteDeadline(id);
    _deadlines.removeWhere((deadline) {
      return deadline.id == id;
    });
    _deadlinesCount = _deadlines.length;
    _areDeadlinesLoading = false;
    notifyListeners();
  }
}
