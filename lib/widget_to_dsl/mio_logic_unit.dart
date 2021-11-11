///
/// Created by zgm on 2021/11/8
/// Describe:
///
class MioLogicUnit {
  static final MioLogicUnit _fairASTLogicUnit = MioLogicUnit._internal();

  factory MioLogicUnit() {
    return _fairASTLogicUnit;
  }

  MioLogicUnit._internal();

  // 保存所有的变量
  Map variables = {};

  // 保存所有的方法
  Map functions = {};

  void addVariable(String name) {
    variables.putIfAbsent(name, () => name);
  }

  void addFunction(String name) {
    functions.putIfAbsent(name, () => name);
  }
}
