import 'dart:ffi';

import 'package:dart_glfw/dart_glfw.dart';
import 'package:ffi/ffi.dart';

void main() {
  glfwInit();

  glfwWindowHint(glfwContextVersionMajor, 4);
  glfwWindowHint(glfwContextVersionMinor, 5);
  glfwWindowHint(glfwOpenglProfile, glfwOpenglCoreProfile);

  final window = glfwCreateWindow(250, 250, 'test window'.toNativeUtf8().cast(), nullptr, nullptr);
  assert(window.address != 0);

  glfwRequestWindowAttention(window);

  while (glfwWindowShouldClose(window) != glfwTrue) {
    glfwPollEvents();
    glfwSwapBuffers(window);
  }

  glfwDestroyWindow(window);
  glfwTerminate();
}
