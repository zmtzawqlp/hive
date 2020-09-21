library hive_object_internal;

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:hive/src/object/hive_list_impl.dart';

part 'hive_object_internal.dart';

class _HiveObjectConnection {
  BoxBase box;
  dynamic key;
}

/// Extend `HiveObject` to add useful methods to the objects you want to store
/// in Hive
abstract class HiveObject {
  /// Not part of public API
  final connection = _HiveObjectConnection();

  // HiveLists containing this object
  final _hiveLists = <HiveList, int>{};

  /// Get the box in which this object is stored. Returns `null` if object has
  /// not been added to a box yet.
  BoxBase get box => connection.box;

  /// Get the key associated with this object. Returns `null` if object has
  /// not been added to a box yet.
  dynamic get key => connection.key;

  void _requireInitialized() {
    if (box == null) {
      throw HiveError('This object is currently not in a box.');
    }
  }

  /// Persists this object.
  Future<void> save() {
    _requireInitialized();
    return box.put(key, this);
  }

  /// Deletes this object from the box it is stored in.
  Future<void> delete() {
    _requireInitialized();
    return box.delete(key);
  }

  /// Returns whether this object is currently stored in a box.
  ///
  /// For lazy boxes this only checks if the key exists in the box and NOT
  /// whether this instance is actually stored in the box.
  bool get isInBox {
    if (box != null) {
      if (box.lazy) {
        return box.containsKey(key);
      } else {
        return true;
      }
    }
    return false;
  }
}
