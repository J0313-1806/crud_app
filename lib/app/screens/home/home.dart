import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_app/app/screens/auth/controller/controller_auth.dart';
import 'package:crud_app/app/screens/home/controller/controller_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
        init: HomeController(),
        builder: (homeController) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.deepPurple.shade50,
                title: const Text(
                  "ITEMS",
                  style: TextStyle(color: Colors.black87),
                ),
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                actions: [
                  IconButton(
                    onPressed: _authController.signOut,
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              body: homeController.tempData.isEmpty
                  ? const Center(
                      child: Text("No Data"),
                    )
                  : ListView.builder(
                      // key: homeController.listKey,
                      itemCount: homeController.tempData.length,
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            padding: const EdgeInsets.all(10),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                14,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) => homeController.delete(
                              direction: direction, index: index),
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(1.5, 1.5),
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 0.5,
                                  blurRadius: 2,
                                  offset: Offset(-1.5, -1.5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    child: homeController
                                            .tempData[index].image.isNotEmpty
                                        ? CachedNetworkImage(
                                            height: 100,
                                            // width: 90,
                                            imageUrl: homeController
                                                .tempData[index].image,
                                            progressIndicatorBuilder:
                                                (context, str, download) =>
                                                    Center(
                                              child: CircularProgressIndicator(
                                                value: download.progress,
                                              ),
                                            ),
                                          )
                                        : Image.asset(
                                            "assets/not.png",
                                            fit: BoxFit.cover,
                                            height: 100,
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      homeController.tempData[index].title,
                                    ),
                                    subtitle: Text(
                                      homeController.tempData[index].desc,
                                    ),
                                    trailing: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade50,
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        color: Colors.deepPurple,
                                        onPressed: () =>
                                            homeController.callBottom(
                                                text: "Edit Item",
                                                index: index),
                                        icon: const Icon(Icons.edit_outlined),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => homeController.callBottom(
                  text: "Add Item",
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                backgroundColor: Colors.pink.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        });
  }
}
