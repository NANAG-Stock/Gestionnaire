import 'package:flutter/material.dart';

class Block extends StatefulWidget {
  final String title;
  final String content;
  final Color color;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final Function()? callBack;
  final bool isBtn;

  const Block(
      {Key? key,
      required this.title,
      required this.color,
      this.callBack,
      this.isBtn = false,
      required this.content,
      required this.titleStyle,
      required this.contentStyle})
      : super(key: key);

  @override
  State<Block> createState() => _BlockState();
}

class _BlockState extends State<Block> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                  color: widget.color.withOpacity(0.5),
                  offset: const Offset(-1, -1),
                  blurRadius: 1,
                  spreadRadius: 1)
            ]),
        child: Center(
            child: !widget.isBtn
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: widget.titleStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.content,
                        style: widget.contentStyle,
                      )
                    ],
                  )
                : GestureDetector(
                    onTap: widget.callBack,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: widget.titleStyle,
                        ),
                        Text(
                          widget.content,
                          style: widget.contentStyle,
                        )
                      ],
                    ),
                  )),
      ),
    );
  }
}
