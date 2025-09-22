import 'package:admin/screens/forms/member_category_widget.dart';
import 'package:admin/screens/forms/member_delegate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'dart:developer';


class CustomExpansionTileList extends StatefulWidget {

  const CustomExpansionTileList({Key? key, required this.elementList});
  
  final List<dynamic> elementList; 
  
  @override
  State<StatefulWidget> createState() => _DrawerState();
}

class _DrawerState extends State<CustomExpansionTileList> {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  int _selectedPageIndex = 0;
  PageController _pageController = PageController();
  
  List<Widget> _getChildren(final List<dynamic> elementList) {
    List<Widget> children = [];
    elementList.toList().asMap().forEach((index, element) {
      int selected = 0;
      final subMenuChildren = <Widget>[];
      try {
        for (var i = 0; i < element['children'].length; i++) {
          subMenuChildren.add(new ListTile(
            leading: Visibility(
              child: Icon(
                Icons.account_box_rounded,
                size: 15,
              ),
              visible: false,
            ),
            onTap: () => {
              setState(() {
                //log("The item clicked is " + element['children'][i]['state']);

                //from the json we got which contains the menu and submenu we will need the "state"
                // json item to get the unique identifier so we know what to open

                switch (element['children'][i]['state']) {
                  case '/member_category':
                    //setting current index and opening a new screen using page controller with animations
                    _selectedPageIndex = 1;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_pageController.hasClients) {
                        _pageController.animateToPage(1, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
                      }
                    });
                    //c.title.value = "Fund Type";
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new MemberCategoryWidget();
                    },
                    fullscreenDialog: true));
                    break;
                  case '/delegate_category':
                    _selectedPageIndex = 2;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_pageController.hasClients) {
                        _pageController.animateToPage(1, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
                      }
                    });
                    //c.title.value = "Fund Type";
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new MemberDelegateWidget();
                    },
                    fullscreenDialog: true));
                    break;
                }
              })
            },
            title: Text(
              element['children'][i]['title'],
              style: TextStyle(color: Colors.white54),
            ),
          ));
        }
        children.add(
          new ExpansionTile(
            key: Key(index.toString()),
            initiallyExpanded: index == selected,
            leading: SvgPicture.asset(
              element['icon'],
              color: Colors.white54,
              height: 16,
            ),
            title: Text(
              element['title'],
              style: TextStyle(color: Colors.white54),
            ),
            children: subMenuChildren,
            onExpansionChanged: ((newState) {
              if (newState) {
                Duration(seconds: 20000);
                selected = index;
                //log(' selected ' + index.toString());
              } else {
                selected = -1;
                //log(' selected ' + selected.toString());
              }
            }),
          ),
        );
      } catch (err) {
        //log('Caught error: $err');
      }
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: _getChildren(widget.elementList),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}