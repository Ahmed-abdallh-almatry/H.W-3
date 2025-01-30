import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/data_uploader_controller.dart';

class DataUploader extends StatelessWidget {
  final DataUploaderController _controller = Get.put(DataUploaderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Uploader')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _controller.saveData('Sample Data');
          },
          child: Text('Save Data'),
        ),
      ),
    );
  }
}