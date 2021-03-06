import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/helpers/date-time-helper.dart';
import '../models/block.dart';
import '../database/local-db.dart';

mixin BlockModel on Model {
  List<Block> _blocks = [];

  bool _areBlocksLoading = false;
  int _blocksCount;

  List<Block> get blocks {
    return _blocks;
  }

  bool get areBlocksLoading {
    return _areBlocksLoading;
  }

  int get blocksCount {
    return _blocksCount;
  }

  Block blockById(String id) {
    Block block = _blocks.firstWhere((element) {
      return element.id == id;
    });
    return block;
  }

  Future<Null> updateBlock(String _blockDate, Block newBlock) async {
    _areBlocksLoading = true;
    notifyListeners();
    await LocalDB.db.updateBlock(_blockDate, newBlock);
    _areBlocksLoading = false;
    notifyListeners();
  }

  getAllBlocksLocal() async {
    _areBlocksLoading = true;
    notifyListeners();
    _blocks = [];
    List<Map<String, dynamic>> rawBlocksData =
        await LocalDB.db.fetchAllBlocks();
    rawBlocksData.forEach((block) {
      _blocks.add(Block(
        id: block['id'],
        name: block["name"],
        deadline: block['deadline'],
      ));
    });
    _blocks.sort((blockOne, blockTwo) {
      DateTime dateOne = DateTime.parse(blockOne.deadline);
      DateTime dateTwo = DateTime.parse(blockTwo.deadline);
      return dateOne.compareTo(dateTwo);
    });
    _blocksCount = _blocks.length;
    _areBlocksLoading = false;
    notifyListeners();
  }

  Future<bool> insertBlock(Block block) async {
    _areBlocksLoading = true;
    notifyListeners();
    await LocalDB.db.insertBlock(block);
    _areBlocksLoading = false;
    notifyListeners();
    return true;
  }

  Future<String> getBlockIDByDate(DateTime date) async {
    DateTimeHelper dthelper = DateTimeHelper();
    String queriedDate = dthelper.dateToDatabaseString(date);
    List<Map<String, dynamic>> block =
        await LocalDB.db.fetchBlockByDate(queriedDate);
    return block[0]['id'];
  }

  Future<bool> deleteBlockLocal(String id) {
    return LocalDB.db.deleteBlock(id).then((a) {
      _blocks.removeWhere((block) {
        return block.id == id;
      });

      _blocksCount = _blocks.length;
      notifyListeners();
      return true;
    });
  }
}
