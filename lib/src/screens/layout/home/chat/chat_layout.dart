import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/src/components/consts/buttons.dart';
import 'package:zinsta/src/components/consts/row_title_icon_widget.dart';

// import '../../../components/chat_componants/active_users.dart';
// import '../../../components/chat_componants/chat_list_tile_widget.dart';

class ChatLayoutPage extends StatelessWidget {
  const ChatLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: HugeIcon(icon: HugeIcons.strokeRoundedChatting01),
        leadingWidth: 40,
        title: Text("Chats", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [AppButtons.searchButton(context)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitleIconWidget(
                      title: "Active Users",
                      icon: HugeIcons.strokeRoundedPresentationOnline,
                    ),
                    SizedBox(
                      height: 100,
                      // child: ListView.builder(
                      //   shrinkWrap: true,
                      //   addAutomaticKeepAlives: true,
                      //   scrollDirection: Axis.horizontal,
                      //   itemCount: 10,
                      //   itemBuilder: (context, index) => activeUserChatLayoutWidgets(),
                      // ),
                      child: Center(
                        child: Text(
                          "No users available yet.",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Theme.of(context).dividerColor, thickness: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitleIconWidget(
                      title: "Messages",
                      icon: HugeIcons.strokeRoundedBubbleChatOutcome,
                    ),
                    // ListView.separated(
                    //   shrinkWrap: true,
                    //   addAutomaticKeepAlives: true,
                    //   itemCount: 13,
                    //   scrollDirection: Axis.vertical,
                    //   physics: const BouncingScrollPhysics(),
                    //   itemBuilder:
                    //       (context, index) =>
                    //           chatListTileWidget(context, id: "1", profilePicture: "", name: ""),
                    //   separatorBuilder:
                    //       (context, index) =>
                    //           Divider(color: Theme.of(context).dividerColor, thickness: 15),
                    // ),
                    Center(
                      heightFactor: 2,
                      child: Text(
                        "You didn't send follow for anyone, send follow and start chat.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
