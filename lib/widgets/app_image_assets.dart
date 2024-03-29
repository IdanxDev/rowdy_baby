import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/constant/image_constant.dart';
import 'package:dating/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImageAsset extends StatelessWidget {
  final String? image;
  final bool isWebImage;
  final double? height;
  final double? webHeight;
  final double? width;
  final double? webWidth;
  final Color? color;
  final BoxFit? fit;
  final BoxFit? webFit;

  const AppImageAsset({
    Key? key,
    @required this.image,
    this.webFit,
    this.fit,
    this.height,
    this.webHeight,
    this.width,
    this.webWidth,
    this.color,
    this.isWebImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isWebImage
        ? CachedNetworkImage(
            imageUrl: image!,
            height: webHeight,
            width: webWidth,
            fit: webFit ?? BoxFit.cover,
            placeholder: (context, url) => const AppLoader(),
            errorWidget: (context, url, error) => const AppImageAsset(
              image: ImageConstant.userAvatar,
              fit: BoxFit.contain,
            ),
          )
        : image!.split('.').last != 'svg'
            ? Image.asset(
                image!,
                fit: fit,
                height: height,
                width: width,
                color: color,
              )
            : SvgPicture.asset(
                image!,
                height: height,
                width: width,
                color: color,
              );
  }
}
