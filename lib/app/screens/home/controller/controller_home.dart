import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/app/data/model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  onReady() {
    super.onReady();
    title.text = "";
    desc.text = "";
    tempData.bindStream(readData());
  }

  final doc = FirebaseFirestore.instance.collection('data');
  final storage = FirebaseStorage.instance;
  final listKey = GlobalKey<AnimatedListState>();
  File? file;
  var filePath = ''.obs;
  String imageUrl = '';
  String tempImage = "assets/index.jpg";
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  RxList<Model> tempData = RxList([]);

  Future<TaskSnapshot?> uploadFile({File? file, String? fileName}) async {
    try {
      final task = await storage.ref(fileName).putFile(file!);
      return task;
      // String s = await ff.ref.getDownloadURL();
      // log('link: $s');
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return null;
  }

  Future<void> addData({required bool addData, int? index}) async {
    final _doc = doc.doc();
    if (addData) {
      Model modelData = Model(
        id: _doc.id,
        title: title.text,
        desc: desc.text,
        image: imageUrl.isEmpty ? tempImage : imageUrl,
        date: DateTime.now(),
      );
      _doc.set(modelData.toJson());
    } else {
      doc.doc(tempData[index!].id).update({
        'title': title.text,
        'desc': desc.text,
        'image': imageUrl.isEmpty ? tempData[index].image : imageUrl,
        'date': DateTime.now(),
      });
    }
    imageUrl = '';
    Get.back();
  }

  Stream<List<Model>> readData() => doc
      .orderBy("date", descending: true)
      .snapshots()
      .map((event) => event.docs.map((e) => Model.fromJson(e.data())).toList());

  void callBottom({required String text, int? index}) {
    text.contains("Edit Item")
        ? title.text = tempData[index!].title
        : title.clear();
    text.contains("Edit Item")
        ? desc.text = tempData[index!].desc
        : desc.clear();

    Get.bottomSheet(
      Padding(
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
                  filePath(path);
                  file = File(path!);
                  // file?.value = f;
                  final task = await uploadFile(
                      file: file, fileName: result.files.single.name);

                  if (task == null) {
                    Get.showSnackbar(const GetSnackBar(
                      title: 'Error',
                      message: 'Something went wrong!',
                    ));
                    return;
                  }
                  imageUrl = await task.ref.getDownloadURL();
                  log(imageUrl);
                  Get.snackbar('Image Selected!', 'Filename: $fileName');
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
                    text.contains("Edit Item")
                        ? CachedNetworkImage(
                            imageUrl: tempData[index!].image,
                            progressIndicatorBuilder:
                                (context, str, download) => Center(
                              child: CircularProgressIndicator(
                                value: download.progress,
                              ),
                            ),
                            height: 100,
                          )
                        : filePath.isEmpty
                            ? Image.asset(
                                tempImage,
                                fit: BoxFit.cover,
                                height: 100,
                              )
                            : Obx(
                                () => Image.file(
                                  File(filePath.value),
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
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
              controller: title,
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
              controller: desc,
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
              onPressed: () => addData(
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
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  @override
  void onClose() {
    title.dispose();
    desc.dispose();
    super.onClose();
  }

  Future<void> delete(
      {required DismissDirection direction, required int index}) async {
    final _deleteDoc = doc.doc(tempData[index].id);

    _deleteDoc.delete();
  }
}
