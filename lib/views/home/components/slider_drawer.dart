import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive_tdo/extensions/space_exs.dart';
import 'package:flutter_hive_tdo/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  /// Icons
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                "https://avatars.githubusercontent.com/u/91388754?v=4"),
          ),
          8.h,
          Text("Yerlanov Artur", style: textTheme.displayMedium),
          Text("Flutter Dev", style: textTheme.displaySmall),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
                itemCount: icons.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      debugPrint('${texts[index]} Item Tapped!');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      child: ListTile(
                        leading: Icon(
                          icons[index],
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          texts[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
