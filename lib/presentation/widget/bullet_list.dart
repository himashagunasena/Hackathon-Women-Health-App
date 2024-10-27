import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/appcolor.dart';

class BulletListScreen extends StatefulWidget {
  final List<BulletList>? list;
  final List<double>? height;

  const BulletListScreen({super.key, this.list, this.height});

  @override
  _BulletListScreenState createState() => _BulletListScreenState();
}

class _BulletListScreenState extends State<BulletListScreen> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.list?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        if (index >= (widget.list?.length ?? 0)) {
          return SizedBox.shrink();
        }




        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        color: AppColors.lightTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.list?[index].title ?? "",
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Container(
                    height:  widget.height?[index],
                    width: 1,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: widget.list?[index].body ?? const SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class BulletList {
  final String? title;
  final Widget? body;

  BulletList(this.title, this.body);
}
