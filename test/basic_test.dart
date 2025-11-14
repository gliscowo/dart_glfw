import 'dart:ffi';

import 'package:dart_glfw/dart_glfw.dart';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';

void main() {
  test('glfw init and terminate', () {
    final initResult = glfwInit();
    expect(initResult, glfwTrue);

    glfwTerminate();
  });

  test('glfw version info', () {
    using((arena) {
      final major = arena<Int>();
      final minor = arena<Int>();
      final rev = arena<Int>();

      glfwGetVersion(major, minor, rev);
      expect(major.value, 3);
      expect(minor.value, 4);
      expect(rev.value, 0);
    });
  });
}
