import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/screens/home/components/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: defaultPadding * 3,
                ),
                Image.asset(
                  "assets/logo/logo_icon.png",
                  scale: 5,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text("Smart HR - Application")
              ],
            )),
            CustomExpansionTileList(
              elementList: [
                {
                  "title": "Master Setup",
                  "icon": "assets/icons/menu_dashboard.svg",
                  "state": "/dashboard",
                  "children": [
                    {
                      "title": "Member Category",
                      "icon": "assets/icons/menu_dashboard.svg",
                      "state": "/member_category"
                    },
                    {
                      "title": "Delegate Category",
                      "icon": "assets/icons/menu_dashboard.svg",
                      "state": "/delegate_category"
                    },
                    {
                      "title": "Abstract Category",
                      "icon": "assets/icons/menu_dashboard.svg",
                      "state": "/abstract_category"
                    },
                    {
                      "title": "Abstract Type",
                      "icon": "assets/icons/menu_dashboard.svg",
                      "state": "/abstract_type"
                    },
                    {
                      "title": "Session Halls",
                      "icon": "assets/icons/menu_dashboard.svg",
                      "state": "/session_halls"
                    },
                    {
                      "title": "Session date",
                      "icon": "assets/icons/menu_dashboard.svg",
                      "state": "/session_date"
                    },
                    {
                      "title": "Session Time",
                      "icon": "assets/icons/menu_dashboard.svg",
                      "state": "/session_time"
                    },
                    {
                      "title": "Session Role",
                      "icon": "assets/icons/menu_dashboard.svg",
                      "state": "/session_role"
                    }
                  ]
                }
              ],
            ),
            DrawerListTile(
              title: "Posts",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Pages",
              svgSrc: "assets/icons/menu_task.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Categories",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Appearance",
              svgSrc: "assets/icons/menu_store.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Users",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Tools",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
