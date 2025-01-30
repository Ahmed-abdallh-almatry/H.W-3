import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data_uploader.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(DataUploader());
          },
          child: Text('Go to Data Uploader'),
        ),
      ),
    );
  }
}