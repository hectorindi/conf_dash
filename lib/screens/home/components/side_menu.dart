import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/screens/forms/event_registration_widget.dart';
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
                Text("Confrence Dashboard")
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
                    }
                  ]
                }
              ],
              isSidebar: true
            ),
            DrawerListTile(
              title: "Members",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return EventRegistrationWidget(title: "Event Registration");
                  },
                fullscreenDialog: true));
              },
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
