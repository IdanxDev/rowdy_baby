import 'package:dating/constant/color_constant.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/widgets/app_image_assets.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AppPhotoViewer extends StatefulWidget {
  final int selectedIndex;
  final List<String>? photoViewerImages;

  const AppPhotoViewer({
    Key? key,
    @required this.photoViewerImages,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  State<AppPhotoViewer> createState() => AppPhotoViewerState();
}

class AppPhotoViewerState extends State<AppPhotoViewer> {
  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: widget.photoViewerImages!.length,
              builder: (context, index) => PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.photoViewerImages![index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
              scrollPhysics: const PageScrollPhysics(),
              onPageChanged: (value) {
                logs('Current index --> $value');
              },
              pageController: pageController,
              backgroundDecoration: BoxDecoration(
                color: ColorConstant.transparent.withOpacity(0.9),
              ),
              loadingBuilder: (context, event) => const AppLoader(),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 80,
                color: Colors.transparent,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(
                  top: 30,
                  right: 30,
                ),
                child: const AppImageAsset(image: ImageConstant.closeSignIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
