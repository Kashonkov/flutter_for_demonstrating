import 'dart:collection';

import 'package:get_it/get_it.dart';

T getIt<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) => GetIt.instance.get(instanceName: instanceName, param1: param1, param2: param2);

abstract class BaseDIModule{
  void updateInjections(GetIt instance);
}

abstract class AsyncDIModule{
  Future updateInjections(GetIt instance);
}

extension GetItExtension on GetIt{
  static Queue cleanQueue = Queue<Future<void> Function()>();
  static bool _isCleanerLaunched = false;

  void installModule(BaseDIModule module){
    module.updateInjections(this);
  }

  Future<dynamic> installModuleAsync(AsyncDIModule module) {
    return module.updateInjections(this);
  }

  /// Очитска di модуля
  /// Если добавится очистка прежде чем закончится предыдущая, она дождется предыдущего метода и затем выполнится
  void popScopeTillSmart(String scopeName) {
    cleanQueue.add(() => _popExistingScopeTill(scopeName));
    if (!_isCleanerLaunched) {
      _runClean();
    }
  }

  Future<void> _popExistingScopeTill(String scopeName) async {
    if (hasScope(scopeName)) {
      await popScopesTill(scopeName);
    }
  }

  Future<void> _runClean() async {
    _isCleanerLaunched = true;
    final cleanScope = cleanQueue.removeFirst();
    await cleanScope();
    if (cleanQueue.isNotEmpty) {
      _runClean();
    } else {
      _isCleanerLaunched = false;
    }
  }
}