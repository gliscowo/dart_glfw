import 'dart:ffi';

import 'glfw_functions.dart';

GLFW? _instance;

/// Load the GLFW functions from the binary located at [binaryPath]
GLFW loadGLFW(String libraryPath) {
  if (_instance != null) return _instance!;

  DynamicLibrary glfwLibrary;
  try {
    glfwLibrary = DynamicLibrary.open(libraryPath);
  } catch (e) {
    throw GLFWInitError("Failed to load GLFW binary", e);
  }

  Pointer<T> lookupSymbol<T extends NativeType>(String symbol) {
    if (glfwLibrary.providesSymbol(symbol)) {
      return glfwLibrary.lookup(symbol);
    } else {
      return nullptr;
    }
  }

  return _instance = GLFW(lookupSymbol);
}

class GLFWInitError extends Error {
  final String message;
  final Object? cause;

  GLFWInitError(this.message, [this.cause]);

  @override
  String toString() => cause != null ? "$message\nCaused by: $cause" : message;
}
