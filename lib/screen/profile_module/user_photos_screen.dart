// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserPhotoScreen extends StatefulWidget {
  const UserPhotoScreen({Key? key}) : super(key: key);

  @override
  State<UserPhotoScreen> createState() => UserPhotoScreenState();
}

class UserPhotoScreenState extends State<UserPhotoScreen> {
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, AppProvider appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: AppText(
                text: 'Add your photos',
                fontColor: ColorConstant.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 2.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              children: List.generate(
                6,
                (index) => Stack(
                  children: [
                    GestureDetector(
                      onTap: () => selectImages(appProvider),
                      child: Container(
                        height: 150,
                        width: 120,
                        margin: const EdgeInsets.only(right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: appProvider.userPhotos[index].isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(34),
                                child: AppImageAsset(
                                  image: ImageConstant.plusSignIcon,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(appProvider.userPhotos[index]),
                                  fit: BoxFit.fill,
                                  // height: ,
                                ),
                              ),
                      ),
                    ),
                    if (appProvider.userPhotos[index].isNotEmpty)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            appProvider.userPhotos.removeAt(index);
                            appProvider.userPhotos.insert(index, '');
                            appProvider.notifyListeners();
                          },
                          child: const AppImageAsset(
                            image: ImageConstant.closeSignIcon,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectImages(AppProvider appProvider) async {
    List<XFile>? galleryImage =
        await imagePicker.pickMultiImage(imageQuality: 100);
    if (galleryImage != null && galleryImage.isNotEmpty) {
      for (int i = 0; i < galleryImage.length; i++) {
        appProvider.userPhotos.insert(i, galleryImage[i].path);
      }
      logs('User image from Gallery --> $appProvider.userPhotos');
      appProvider.notifyListeners();
    }
  }
}
