import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(
                          text: ' '+widget.snap['text'],
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 4.0),
                  child: Text(DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate()
                  ),
                    style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 12.0
                  ),
                  ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.favorite, size: 16,),
          ),
        ],
      ),
    );
  }
}
