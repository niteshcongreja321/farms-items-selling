import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/views/live-chat/chat.dart';

class MessageWidget extends StatelessWidget {
  final Chat chat;
  const MessageWidget({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('MMM-dd, hh:mm').format(chat.timestamp!.toDate());
    return Slidable(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: chat.isSelf ? Themes.brownLight2 : Themes.green,
              borderRadius: BorderRadius.circular(8)),
          child: Text(chat.message!),
        ),
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/icon-clock.svg'),
              Text(time,
                  style: TextStyle(color: Themes.textColor, fontSize: 14))
            ],
          )
        ]);
  }
}
