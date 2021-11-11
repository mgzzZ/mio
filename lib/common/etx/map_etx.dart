///
/// Created by zgm on 2021/9/22
/// Describe:
///

extension MapExt on Map {
  bool safeContains(Object key) {
    if (this.containsKey(key) && this[key] != null) {
      return true;
    }
    return false;
  }
}
