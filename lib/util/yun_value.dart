//
// Created by yun on 2020-02-18.
//

class YunValue {
  // region string

  static bool hasContent(String str, {bool enableEmpty = false}) {
    if (str == null) {
      return false;
    }

    if (enableEmpty) {
      return true;
    }

    return str.length > 0;
  }

  static bool isNullOrEmpty(String str) {
    return isNull(str, enableEmpty: true);
  }

  static bool isNull(String str, {bool enableEmpty = true}) {
    if (enableEmpty) {
      return str == null || str.length == 0;
    }

    return str == null;
  }

  static bool isSame(String a, String b, {bool enableNullOrEmpty = true}) {
    if (isNull(a, enableEmpty: enableNullOrEmpty)) {
      if (isNull(b, enableEmpty: enableNullOrEmpty)) {
        return true;
      }

      return false;
    } else {
      if (isNull(b, enableEmpty: enableNullOrEmpty)) {
        return false;
      }

      return a == b;
    }
  }

  // endregion

  // region int

  static bool isSameInt(int a, int b) {
    if (a == null) {
      if (b == null) {
        return true;
      }

      return false;
    } else {
      if (b == null) {
        return false;
      }

      return a == b;
    }
  }

// endregion

}
