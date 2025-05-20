import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget profileStatsWidget({required int followers, required int following, required int posts}) =>
    Card(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
      elevation: 3,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatColumn('Followers', followers),
            _buildStatColumn('Following', following),
            _buildStatColumn('Posts', posts),
          ],
        ),
      ),
    );

Widget _buildStatColumn(String label, int count) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('$count', style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
    ],
  );
}
