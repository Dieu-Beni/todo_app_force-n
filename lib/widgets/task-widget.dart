import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final String title;
  final String date;


  const TaskWidget({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 363,
          height: 60,
          padding: const EdgeInsets.only(right: 2),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(color: Color(0xFFFF0000)),
                child: Stack(children: [

                  ]),
              ),
              SizedBox(
                width: 180,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    height: 0,
                  ),
                ),
              ),
              Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF676767),
                  fontSize: 16,
                  fontFamily: 'Josefin Slab',
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
