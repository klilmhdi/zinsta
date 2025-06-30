import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/src/components/chat_componants/active_users.dart';

import '../../../../components/chat_componants/message_item.dart';

class ChatMessagePage extends StatefulWidget {
  final String? id;

  const ChatMessagePage({super.key, required this.id});

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  var messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        leading: BackButton(),
        title: Row(
          spacing: 8,
          children: [
            userAvatarIconsWidget(radius: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name FirstLast", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                RichText(
                  text: TextSpan(
                    text: "@",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: CupertinoColors.systemGrey.highContrastColor,
                    ),
                    children: [
                      TextSpan(
                        text: "username",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: CupertinoColors.systemGrey.highContrastColor,
                          decoration: TextDecoration.underline,
                          decorationColor: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          HugeIcon(icon: HugeIcons.strokeRoundedVideo01, size: 22),
          SizedBox(width: 12),
          HugeIcon(icon: HugeIcons.strokeRoundedCallOutgoing01, size: 22),
          SizedBox(width: 15),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 241, 241, 241)),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 140),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    // final message = state.message[index];
                    return MessageItemWidget(
                      message: "Hello",
                      // time: DateFormat('hh:mm a').format(message.messageTime),
                      time: DateTime.now(),
                      isMe: false,
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 241, 241),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) {},
                            controller: messageController,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Type here...',
                              hintStyle: TextStyle(
                                fontSize: 17,
                                color: Colors.black..withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(color: Colors.black.withValues(alpha: 0.2)),
                        const SizedBox(width: 17),
                        Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedHappy,
                              size: 25,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 17),
                            Icon(
                              HugeIcons.strokeRoundedCamera01,
                              size: 25,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
