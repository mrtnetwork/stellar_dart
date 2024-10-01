import 'package:stellar_dart/src/constants/constant.dart';
import 'package:stellar_dart/src/exception/exception.dart';

class StellarValidator {
  static String validateAssetCode(String code, {int? length}) {
    if (!StellarConst.assetCodeRegEx.hasMatch(code)) {
      throw DartStellarPlugingException("Incorrect asset code.",
          details: {"code": code});
    }
    length ??= StellarConst.assetMaximumCodeLength;
    if (code.length > length) {
      throw DartStellarPlugingException("Invalid  assets code length.",
          details: {"maximum": length, "length": code.length, "code": code});
    }
    return code;
  }
}

extension ListValidator<T> on List<T> {
  List<T> max(int length, {required String? name}) {
    if (this.length > length) {
      throw DartStellarPlugingException(
          "Incorrect ${name == null ? '' : '$name '}array length.",
          details: {"maximum": length, "length": this.length});
    }
    return this;
  }

  List<T> min(int length, {required String? name}) {
    if (this.length < length) {
      throw DartStellarPlugingException(
          "Incorrect ${name == null ? '' : '$name '}array length.",
          details: {"minimum": length, "length": this.length});
    }
    return this;
  }

  List<T> exc(int length, {required String? name}) {
    if (this.length != length) {
      throw DartStellarPlugingException(
          "Incorrect ${name == null ? '' : '$name '}array length.",
          details: {"excepted": length, "length": this.length});
    }
    return this;
  }
}

extension StringValidator on String {
  String max(int length, {String? name}) {
    if (this.length > length) {
      throw DartStellarPlugingException(
          "Incorrect ${name == null ? '' : '$name '}array length.",
          details: {"maximum": length, "length": this.length});
    }
    return this;
  }

  String min(int length, {String? name}) {
    if (this.length < length) {
      throw DartStellarPlugingException(
          "Incorrect ${name == null ? '' : '$name '}array length.",
          details: {"minimum": length, "length": this.length});
    }
    return this;
  }

  String exc(int length, {String? name}) {
    if (this.length != length) {
      throw DartStellarPlugingException(
          "Incorrect ${name == null ? '' : '$name '}array length.",
          details: {"excepted": length, "length": this.length});
    }
    return this;
  }
}

extension QuickMap on Map<String, dynamic> {
  static const Map<String, dynamic> _map = {};
  static const List _list = [];
  T as<T>(String key) {
    final value = this[key];
    if (value == null) {
      if (null is T) {
        return null as T;
      }
      throw DartStellarPlugingException("Key not found.",
          details: {"key": key, "data": this});
    }
    try {
      return value as T;
    } on TypeError {
      throw DartStellarPlugingException("Incorrect value.", details: {
        "key": key,
        "excepted": "$T",
        "value": value.runtimeType,
        "data": this
      });
    }
  }

  E asMap<E>(String key) {
    if (_map is! E) {
      throw const DartStellarPlugingException(
          "Invalid map casting. only use `asMap` method for casting Map<String,dynamic>.");
    }
    final Map? value = as(key);
    if (value == null) {
      if (null is E) {
        return null as E;
      }
      throw DartStellarPlugingException("Key not found.",
          details: {"key": key, "data": this});
    }
    try {
      return value.cast<String, dynamic>() as E;
    } on TypeError {
      throw DartStellarPlugingException("Incorrect value.", details: {
        "key": key,
        "excepted": "$E",
        "value": value.runtimeType,
        "data": this
      });
    }
  }

  E asBytes<E>(String key) {
    if (<int>[] is! E) {
      throw const DartStellarPlugingException(
          "Invalid bytes casting. only use `valueAsList` method for bytes.");
    }
    final List? value = as(key);
    if (value == null) {
      if (null is E) {
        return null as E;
      }
      throw DartStellarPlugingException("Key not found.",
          details: {"key": key, "data": this});
    }
    try {
      return value.cast<int>() as E;
    } on TypeError {
      throw DartStellarPlugingException("Incorrect value.", details: {
        "key": key,
        "excepted": "$E",
        "value": value.runtimeType,
        "data": this
      });
    }
  }

  List<Map<String, dynamic>>? asListOfMap(String key,
      {bool throwOnNull = true}) {
    final List? value = as(key);
    if (value == null) {
      if (!throwOnNull) {
        return null;
      }
      throw DartStellarPlugingException("Key not found.",
          details: {"key": key, "data": this});
    }
    try {
      return value.map((e) => (e as Map).cast<String, dynamic>()).toList();
    } catch (e, s) {
      throw DartStellarPlugingException("Incorrect value.", details: {
        "key": key,
        "value": value.runtimeType,
        "data": this,
        "error": e.toString(),
        "stack": s.toString()
      });
    }
  }

  E _valueAsList<T, E>(String key) {
    if (_list is! E) {
      throw const DartStellarPlugingException(
          "Invalid list casting. only use `valueAsList` method for list casting.");
    }
    final List? value = as(key);
    if (value == null) {
      if (null is E) {
        return null as E;
      }
      throw DartStellarPlugingException("Key not found.",
          details: {"key": key, "data": this});
    }
    try {
      if (_map is T) {
        return value.map((e) => (e as Map).cast<String, dynamic>()).toList()
            as E;
      }
      return value.cast<T>() as E;
    } on TypeError {
      throw DartStellarPlugingException("Incorrect value.", details: {
        "key": key,
        "excepted": "$T",
        "value": value.runtimeType,
        "data": this
      });
    }
  }

  E? mybeAs<E, T>({
    required String key,
    required E Function(T) onValue,
  }) {
    if (this[key] != null) {
      if (_map is T) {
        return onValue(asMap(key));
      }

      if (_list is T) {
        return onValue(_valueAsList(key));
      }
      return onValue(as(key));
    }
    return null;
  }
}
