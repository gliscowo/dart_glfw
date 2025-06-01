import 'dart:ffi';

import 'glfw_functions.dart';

GLFW? _instance;

/// Load the GLFW functions from the binary located at [binaryPath]
GLFW loadGLFWFromPath(String libraryPath) {
  if (_instance != null) return _instance!;

  DynamicLibrary glfwLibrary;
  try {
    glfwLibrary = DynamicLibrary.open(libraryPath);
  } catch (e) {
    throw GLFWInitError("Failed to load GLFW binary", e);
  }

  return loadGLFW(glfwLibrary);
}

/// Load the GLFW functions from [library]
GLFW loadGLFW(DynamicLibrary library) {
  if (_instance != null) return _instance!;

  Pointer<T> lookupSymbol<T extends NativeType>(String symbol) {
    if (library.providesSymbol(symbol)) {
      return library.lookup(symbol);
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
