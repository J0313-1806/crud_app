import 'dart:io';
import 'dart:developer';
import 'package:crud_app/app/screens/home/controller/controller_home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditBottomSheet extends StatelessWidget {
  const EditBottomSheet({Key? key, required this.text, required this.index})
      : super(key: key);

  final String text;
  final int index;
  // static final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(builder: (homeController) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,

          // crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.all(10),
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                final result = await FilePicker.platform
                    .pickFiles(type: FileType.image, allowCompression: true);
                if (result != null) {
                  final path = result.files.single.path;
                  final fileName = result.files.single.name;
                  homeController.filePath(path);
                  homeController.file = File(path!);
                  // file?.value = f;
                  // result.files.isNotEmpty
                  //     ? Fluttertoast.showToast(msg: 'Image selected!')
                  //     : Fluttertoast.showToast(msg: 'Image cannot be selected');
                  final task = await homeController.uploadFile(
                      file: homeController.file,
                      fileName: result.files.single.name);

                  if (task == null) {
                    Get.showSnackbar(const GetSnackBar(
                      title: 'Error',
                      message: 'Something went wrong!',
                      duration: Duration(seconds: 1),
                    ));
                    return;
                  }
                  Get.snackbar(
                    'Image Uploading!',
                    'Filename: $fileName',
                    showProgressIndicator:
                        task.bytesTransferred == task.totalBytes ? true : false,
                    progressIndicatorValueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    backgroundColor: Colors.white,
                  );
                  homeController.imageUrl = await task.ref.getDownloadURL();
                  log(homeController.imageUrl);
                } else {
                  return;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 120,
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text.contains("Edit Item") && homeController.file == null
                        ? CachedNetworkImage(
                            imageUrl: homeController.tempData[index].image,
                            progressIndicatorBuilder:
                                (context, str, download) => Center(
                              child: CircularProgressIndicator(
                                value: download.progress,
                              ),
                            ),
                            height: 100,
                          )
                        : homeController.file == null
                            ? Image.asset(
                                homeController.tempImage,
                                fit: BoxFit.cover,
                                height: 100,
                              )
                            : Image.file(
                                File(homeController.filePath.value),
                                fit: BoxFit.cover,
                                height: 100,
                              ),
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Pick",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: homeController.title,
              decoration: const InputDecoration(
                labelText: "Title",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black54,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black54,
                  ),
                ),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length != 10) {
                    return "Incorrect Number";
                  } else {
                    return "";
                  }
                } else {
                  return "Field cannot be Empty!";
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: homeController.desc,
              decoration: const InputDecoration(
                labelText: "Description",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black54,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black54,
                  ),
                ),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length != 10) {
                    return "Incorrect Number";
                  } else {
                    return "";
                  }
                } else {
                  return "Field cannot be Empty!";
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => homeController.addData(
                addData: text.contains("Edit Item") ? false : true,
                index: text.contains("Edit Item") ? index : null,
              ),
              child: const Text("Save"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fixedSize: Size.fromWidth(Get.width / 3),
              ),
            ),
          ],
        ),
      );
    });
  }
}