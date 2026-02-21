// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:camera/camerascreen.dart';
//
// // Assume you have an XFile from CameraController
// Future<String> saveImageToPath(XFile file) async {
//   // Get app documents directory
//   final Directory appDir = await getApplicationDocumentsDirectory();
//
//   // Create a new file path with timestamp
//   final String filePath =
//       '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//
//   // Copy the captured file to new path
//   final savedFile = await File(file.path).copy(filePath);
//
//   // Return saved file path
//   return savedFile.path;
// }
