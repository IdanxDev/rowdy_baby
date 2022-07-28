// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:dating/widgets/app_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

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
            buildImageView(appProvider),
          ],
        );
      },
    );
  }

  Column buildImageView(AppProvider appProvider) {
    return Column(
      children: [
        ReorderableGridView.count(
          shrinkWrap: true,
          childAspectRatio: 2 / 2.5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final element = appProvider.userPhotos.removeAt(oldIndex);
              appProvider.userPhotos.insert(newIndex, element);
            });
          },
          crossAxisCount: 3,
          children: List.generate(
            6,
            (index) => Stack(
              key: ValueKey(index.toString()),
              children: [
                GestureDetector(
                  onTap: () => selectImages(appProvider, index),
                  child: Container(
                    height: 150,
                    width: 150,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: appProvider.userPhotos[index].isNotEmpty
                            ? ColorConstant.orange
                            : ColorConstant.transparent,
                        width: 2,
                      ),
                      color: const Color(0xFFFFF3E6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: appProvider.userPhotos[index].isEmpty
                        ? const AppImageAsset(
                            image: ImageConstant.plusSignIcon,
                            height: 20,
                            fit: BoxFit.cover,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                appProvider.userPhotos[index].contains('http')
                                    ? AppImageAsset(
                                        image: appProvider.userPhotos[index],
                                        isWebImage: true,
                                        webHeight: 150,
                                        webWidth: 150,
                                        webFit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(appProvider.userPhotos[index]),
                                        fit: BoxFit.fill,
                                        height: 150,
                                        width: 150,
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
        const SizedBox(height: 70),
        const Center(
          child: AppText(
            text: 'Your first photo is your profile photo.\nDrag to change',
            fontSize: 18,
            maxLines: 3,
            height: 2,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> selectImages(AppProvider appProvider, int index) async {
    List<XFile>? galleryImage = await imagePicker.pickMultiImage(imageQuality: 100);
    if (galleryImage != null && galleryImage.isNotEmpty) {
      for (int i = 0; i < galleryImage.length; i++) {
        appProvider.userPhotos.insert(i, galleryImage[i].path);
      }
      uploadPhotos(appProvider);
      logs('User image from Gallery --> ${appProvider.userPhotos}');
      appProvider.notifyListeners();
    }
  }

  Future<void> uploadPhotos(AppProvider appProvider) async {
    appProvider.addRemoveLoader(true);
    for (int i = 0; i < appProvider.userPhotos.length; i++) {
      if (appProvider.userPhotos[i].isNotEmpty) {
        Reference reference = FirebaseStorage.instance.ref(
            '${appProvider.userModel.userId}/${DateTime.now().toIso8601String()}');
        try {
          UploadTask uploadTask = reference.putFile(
            File(appProvider.userPhotos[i]),
            SettableMetadata(contentType: 'image/${appProvider.userPhotos[i].split('.').last}'),
          );
          uploadTask.snapshotEvents.listen((event) {
            logs('uploadTask --> ${event.state.name}');
            double value = (event.bytesTransferred / event.totalBytes);
            logs('value --> $value');
          });
          uploadTask.whenComplete(() async {
            // appProvider.userPhotos[i] = '';
            String imageUrl = await reference.getDownloadURL();
            appProvider.userPhotos[i] = '';
            appProvider.userPhotos.insert(i, imageUrl);
            logs('Photos Provider --> ${appProvider.userPhotos}');
            appProvider.addRemoveLoader(false);
            appProvider.userModel.photos = appProvider.userPhotos;
            logs('Photos in Provider --> ${appProvider.userModel.photos}');
          });
        } on FirebaseException catch (e) {
          logs('${e.code} : ${e.message} due to ${e.stackTrace}');
        }
      }
    }

  }
}
