import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/components/consts/app_color.dart';
import 'package:zinsta/components/consts/cerificate_icon.dart';
import 'package:zinsta/components/consts/user_avatar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: HugeIcon(icon: HugeIcons.strokeRoundedNotification01),
        leadingWidth: 40,
        title: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [Text("(4)", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 15)],
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Stack(
                  alignment: Alignment.topRight,
                  clipBehavior: Clip.none,
                  children: [
                    // CircleAvatar(
                    //   radius: 20,
                    //   backgroundImage: NetworkImage(
                    //     'https://static.dw.com/image/44777236_1004.webp',
                    //   ),
                    // ),
                    // Positioned(top: -3, right: -3, child: buildCerificateWidget(size: 15)),
                    buildUserCertifiedAvatarWidget(
                      profilePicture: "https://static.dw.com/image/44777236_1004.webp",
                    ),
                    Positioned(
                      top: 29,
                      left: 31,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: CupertinoColors.destructiveRed,
                        foregroundColor: CupertinoColors.white,
                        child: HugeIcon(icon: HugeIcons.strokeRoundedFavouriteCircle, size: 16),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  "Massoud Ozil liked your post.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  height: 50,
                  width: 50,
                  color: AppBasicsColors.primaryBlue,
                  child: Image.network(
                    'https://thumb.canalplus.pro/http/unsafe/373x495/filters:quality(80)/canalplus-cdn.canal-plus.io/p1/brand/22781612/canal-ouah_50034/DETAIL34/Arafat_Jaquette_Fiche_Programme_MEA_1242x1656-0',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Divider(color: Theme.of(context).dividerColor, height: 10),
            Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                // leading: Stack(
                //   alignment: Alignment.topRight,
                //   clipBehavior: Clip.none,
                //   children: [
                //     CircleAvatar(
                //       radius: 20,
                //       backgroundImage: NetworkImage(
                //         'https://media.elbalad.news/2025/2/large/6541623514781202502240315391539.jpg',
                //       ),
                //     ),
                //     Positioned(top: -3, right: -3, child: buildCerificateWidget(size: 15)),
                //     Positioned(
                //       top: 26,
                //       left: 28,
                //       child: CircleAvatar(
                //         radius: 8,
                //         backgroundColor: AppBasicsColors.primaryColor,
                //         foregroundColor: CupertinoColors.white,
                //         child: HugeIcon(icon: HugeIcons.strokeRoundedShare05, size: 12),
                //       ),
                //     ),
                //   ],
                // ),
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    buildUserCertifiedAvatarWidget(
                      profilePicture:
                          "https://media.elbalad.news/2025/2/large/6541623514781202502240315391539.jpg",
                    ),
                    Positioned(
                      top: 29,
                      left: 31,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: AppBasicsColors.primaryBlue,
                        foregroundColor: CupertinoColors.white,
                        child: HugeIcon(icon: HugeIcons.strokeRoundedShare05, size: 12),
                      ),
                    ),
                  ],
                ),

                title: Text(
                  "عيسى الوزان  re-share your post.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  height: 50,
                  width: 50,
                  color: AppBasicsColors.primaryBlue,
                  child: Image.network(
                    'https://thumb.canalplus.pro/http/unsafe/373x495/filters:quality(80)/canalplus-cdn.canal-plus.io/p1/brand/22781612/canal-ouah_50034/DETAIL34/Arafat_Jaquette_Fiche_Programme_MEA_1242x1656-0',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Divider(color: Theme.of(context).dividerColor, height: 10),
            Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                // leading: CircleAvatar(
                //   radius: 20,
                //   backgroundColor: AppBasicsColors.primaryColor,
                //   foregroundColor: CupertinoColors.white,
                //   child: HugeIcon(icon: HugeIcons.strokeRoundedUserAdd01, size: 20),
                // ),
                // leading: Stack(
                //   alignment: Alignment.topRight,
                //   clipBehavior: Clip.none,
                //   children: [
                //     CircleAvatar(
                //       radius: 20,
                //       backgroundImage: NetworkImage(
                //         'https://upload.wikimedia.org/wikipedia/commons/1/18/Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg',
                //       ),
                //     ),
                //     Positioned(top: -3, right: -3, child: buildCerificateWidget(size: 15)),
                //     Positioned(
                //       top: 26,
                //       left: 28,
                //       child: CircleAvatar(
                //         radius: 8,
                //         backgroundColor: AppBasicsColors.primaryColor,
                //         foregroundColor: CupertinoColors.white,
                //         child: HugeIcon(icon: HugeIcons.strokeRoundedUserAdd01, size: 12),
                //       ),
                //     ),
                //   ],
                // ),
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    buildUserCertifiedAvatarWidget(
                      profilePicture:
                          "https://upload.wikimedia.org/wikipedia/commons/1/18/Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg",
                    ),
                    Positioned(
                      top: 29,
                      left: 31,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: AppBasicsColors.primaryBlue,
                        foregroundColor: CupertinoColors.white,
                        child: HugeIcon(icon: HugeIcons.strokeRoundedUserAdd01, size: 12),
                      ),
                    ),
                  ],
                ),

                title: Text(
                  "Mark Zuck send a follow for you.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CupertinoColors.destructiveRed,
                  ),
                ),
              ),
            ),
            Divider(color: Theme.of(context).dividerColor, height: 10),
            Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                // leading: Stack(
                //   alignment: Alignment.topRight,
                //   clipBehavior: Clip.none,
                //   children: [
                //     CircleAvatar(
                //       radius: 20,
                //       backgroundImage: NetworkImage(
                //         'https://upload.wikimedia.org/wikipedia/commons/8/83/TrumpPortrait.jpg',
                //       ),
                //     ),
                //     Positioned(top: -3, right: -3, child: buildCerificateWidget(size: 15)),
                //     Positioned(
                //       top: 26,
                //       left: 28,
                //       child: CircleAvatar(
                //         radius: 8,
                //         backgroundColor: AppBasicsColors.primaryBlue,
                //         foregroundColor: CupertinoColors.white,
                //         child: HugeIcon(icon: HugeIcons.strokeRoundedCommentAdd01, size: 12),
                //       ),
                //     ),
                //   ],
                // ),
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    buildUserCertifiedAvatarWidget(

                      profilePicture:
                          "https://upload.wikimedia.org/wikipedia/commons/8/83/TrumpPortrait.jpg",
                    ),
                    Positioned(
                      top: 29,
                      left: 31,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: AppBasicsColors.primaryBlue,
                        foregroundColor: CupertinoColors.white,
                        child: HugeIcon(icon: HugeIcons.strokeRoundedCommentAdd01, size: 12),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  "Donalt Tramp comment on your post: الله يرحم روحك يا أبو عمار",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  height: 50,
                  width: 50,
                  color: AppBasicsColors.primaryBlue,
                  child: Image.network(
                    'https://thumb.canalplus.pro/http/unsafe/373x495/filters:quality(80)/canalplus-cdn.canal-plus.io/p1/brand/22781612/canal-ouah_50034/DETAIL34/Arafat_Jaquette_Fiche_Programme_MEA_1242x1656-0',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
