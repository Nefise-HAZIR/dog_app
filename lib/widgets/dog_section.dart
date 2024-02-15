import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DogSection extends StatelessWidget {
  const DogSection({
    super.key,
    required this.images,
    required this.index,
    required this.bred,
  });

  final List? images;
  final int index;
  final String bred;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 0),
          width: 160.w,
          height: 160.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              images?[index],
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[800]?.withOpacity(0.7),
              borderRadius: BorderRadius.circular(5)
            ),
            padding:const EdgeInsets.all(5),
            child: Text(bred,style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),),
          ),
        )
      ],
    );
  }
}