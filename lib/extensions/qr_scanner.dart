import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:google_ml_kit/google_ml_kit.dart' as ml_kit;

class QrCodeScanner extends StatefulWidget {
  QrCodeScanner({
    required this.setResult,
    super.key,
  });

  final Function setResult;

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final mobile_scanner.MobileScannerController controller = mobile_scanner.MobileScannerController();
  bool isFlashOn = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> scanFromGallery() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      final File image = File(imageFile.path);
      final inputImage = ml_kit.InputImage.fromFile(image);
      final barcodeScanner = ml_kit.GoogleMlKit.vision.barcodeScanner();

      final List<ml_kit.Barcode> barcodes = await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        final qrContent = barcodes.first.rawValue; // Access rawValue here
        widget.setResult(qrContent);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No QR code found in the image")),
        );
      }

      await barcodeScanner.close(); // Close the scanner when done
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: isFlashOn ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
                controller.toggleTorch();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: scanFromGallery,
          ),
        ],
      ),
      body: mobile_scanner.MobileScanner(
        fit: BoxFit.contain,
        controller: controller,
        onDetect: (mobile_scanner.BarcodeCapture capture) async {
          final List<mobile_scanner.Barcode> barcodes = capture.barcodes;
          final barcode = barcodes.first;

          if (barcode.rawValue != null) {
            widget.setResult(barcode.rawValue);

            await controller
                .stop()
                .then((value) => controller.dispose())
                .then((value) => Navigator.of(context).pop());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
