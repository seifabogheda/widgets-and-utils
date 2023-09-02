

// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class CustomCacheImage extends StatefulWidget {
  String url;
  BoxFit fit;
  double? height,width;
  BorderRadius? borderRadius;
  ColorFilter? colorFilter;
  Alignment? alignment;
  Widget? child;
  BoxShape? boxShape;
  bool? haveRadius;
   CustomCacheImage({Key? key,    required this.url,
    this.fit=BoxFit.fill,
    this.width,
    this.height,
    this.borderRadius,
    this.colorFilter,
    this.alignment,
    this.child,
    this.boxShape,
    this.haveRadius=true}) : super(key: key);

  @override
  State<CustomCacheImage> createState() => _CustomCacheImageState();
}

class _CustomCacheImageState extends State<CustomCacheImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.url,
      width: widget.width,
      height: widget.height,
      imageBuilder: (context, imageProvider) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: imageProvider,
                fit: widget.fit,
                colorFilter: widget.colorFilter
            ),
            borderRadius: widget.haveRadius! ? widget.borderRadius??BorderRadius.circular(0):null,
            shape: widget.boxShape??BoxShape.rectangle
        ),
        alignment: widget.alignment??Alignment.center,
        child: widget.child,
      ),
      placeholder: (context, url) => Container(
        width: widget.width,height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: widget.haveRadius! ? widget.borderRadius??BorderRadius.circular(0):null,
          shape: widget.boxShape??BoxShape.rectangle,
        ),
        child: const CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Container(
        width: widget.width,height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: widget.haveRadius! ? widget.borderRadius??BorderRadius.circular(0):null,
            shape: widget.boxShape??BoxShape.rectangle,
            image:  const DecorationImage(
              image: AssetImage("assets/images/placeholder.png",),
              fit: BoxFit.contain,
            )
        ),
      ),
    );
  }
}
