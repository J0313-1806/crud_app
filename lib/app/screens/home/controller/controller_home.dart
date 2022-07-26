import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/app/data/model.dart';
import 'package:crud_app/app/screens/home/widgets/bottom_sheet.dart';

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
  final homeKey = GlobalKey<FormState>();
  File? file;
  File? newFile;
  var filePath = ''.obs;
  String imageUrl = '';
  String tempImage = "assets/index.jpg";
  RxBool imageUploading = RxBool(false);
  TextEditingController title = TextEditingController();
  RxString createdAt = RxString('');
  TextEditingController desc = TextEditingController();
  RxList<Model> tempData = RxList([]);

  Future<TaskSnapshot?> uploadFile({File? file, String? fileName}) async {
    try {
      imageUploading(true);
      final task = await storage.ref(fileName).putFile(file!);
      // bytesTransfer(task.bytesTransferred);

      return task;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    } finally {
      imageUploading(false);
    }
    return null;
  }

  Future<void> addData({required bool addData, int? index}) async {
    final _doc = doc.doc();
    if (homeKey.currentState!.validate()) {
      if (addData) {
        Model modelData = Model(
          id: _doc.id,
          title: title.text,
          desc: desc.text,
          image: imageUrl.isEmpty ? '' : imageUrl,
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
      Get.back();
    } else {
      Get.snackbar('Fields Empty', 'Please fill title and description');
    }
    imageUrl = '';
    filePath.value = '';
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
    text.contains("Edit Item")
        ? createdAt.value = tempData[index!].date.toString().substring(0, 10)
        : createdAt('');
    text.contains("Edit Item") ? filePath.value = '' : filePath;

    Get.bottomSheet(
      GetBuilder<HomeController>(builder: (homeController) {
        return EditBottomSheet(
          text: text,
          createdAt: createdAt.string,
          index: index,
          homeController: homeController,
        );
      }),
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
