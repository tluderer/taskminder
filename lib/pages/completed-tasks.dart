import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../dictionary.dart';
import '../globalSettings.dart';
import '../scoped-models/mainmodel.dart';

import '../widgets/tasks-list.dart';

class CompletedTasksPage extends StatefulWidget {
  final MainModel model;

  CompletedTasksPage(
    this.model,
  );

  _CompletedTasksPageState createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  @override
  void initState() {
    widget.model.getAllTasksLocal(showCompleted: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text(Dictionary()
              .displayPhrase('completedTasks', Settings().language)),
        ),
        body: TasksList(
          model: widget.model,
          tasks: widget.model.tasks,
          showCompletedTasksMode: true,
        ),
      );
    });
  }
}
