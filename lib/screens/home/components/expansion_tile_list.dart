import 'package:admin/responsive.dart';
import 'package:admin/screens/forms/member_category_widget.dart';
import 'package:admin/screens/forms/member_delegate_widget.dart';
import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomExpansionTileList extends StatefulWidget {
  const CustomExpansionTileList({Key? key, required this.elementList});
  
  final List<dynamic> elementList; 
  
  @override
  State<StatefulWidget> createState() => _DrawerState();
}

class _DrawerState extends State<CustomExpansionTileList> {
  int _selectedPageIndex = 0;
  PageController _pageController = PageController();
  
  List<Widget> _getChildren(final List<dynamic> elementList) {
    List<Widget> children = [];
    elementList.toList().asMap().forEach((index, element) {
      int selected = 0;
      final subMenuChildren = <Widget>[];
      try {
        for (var i = 0; i < element['children'].length; i++) {
          subMenuChildren.add(
            // Ultra-compact ListTile
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    switch (element['children'][i]['state']) {
                      case '/member_category':
                        _selectedPageIndex = 1;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_pageController.hasClients) {
                            _pageController.animateToPage(1, 
                              duration: Duration(milliseconds: 1), 
                              curve: Curves.easeInOut);
                          }
                        });
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return MemberCategoryWidget();
                          },
                          fullscreenDialog: true));
                        break;
                      case '/delegate_category':
                        _selectedPageIndex = 2;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_pageController.hasClients) {
                            _pageController.animateToPage(1, 
                              duration: Duration(milliseconds: 1), 
                              curve: Curves.easeInOut);
                          }
                        });
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return MemberDelegateWidget();
                          },
                          fullscreenDialog: true));
                        break;
                      case '/Logout':
                        _selectedPageIndex = 2;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_pageController.hasClients) {
                            _pageController.animateToPage(1, 
                              duration: Duration(milliseconds: 1), 
                              curve: Curves.easeInOut);
                          }
                        });
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return Login(title: "Welcome to the Admin & Dashboard Panel");
                          },
                          fullscreenDialog: true));
                        break;
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: Responsive.isMobile(context) ? 40.0 : 50.0, // Indent for hierarchy
                    right: 16.0,
                    top: 6.0,    // Minimal vertical padding
                    bottom: 6.0,
                  ),
                  child: Text(
                    element['children'][i]['title'],
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: Responsive.isMobile(context) ? 13.0 : 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          );
        }
        
        children.add(
          // Minimal ExpansionTile with no extra containers or margins
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              expansionTileTheme: ExpansionTileThemeData(
                tilePadding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 12.0 : 16.0,
                  vertical: 0.0, // No vertical padding
                ),
                childrenPadding: EdgeInsets.zero, // No padding around children
                collapsedBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
            ),
            child: ExpansionTile(
              key: Key(index.toString()),
              initiallyExpanded: false,
              maintainState: false,
              leading: SvgPicture.asset(
                element['icon'],
                color: Colors.white54,
                height: Responsive.isMobile(context) ? 16 : 18,
                width: Responsive.isMobile(context) ? 16 : 18,
              ),
              title: Text(
                element['title'],
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: Responsive.isMobile(context) ? 14.0 : 16.0,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white54,
                size: Responsive.isMobile(context) ? 18 : 20,
              ),
              children: subMenuChildren,
              onExpansionChanged: ((newState) {
                if (newState) {
                  selected = index;
                } else {
                  selected = -1;
                }
              }),
            ),
          ),
        );
      } catch (err) {
        debugPrint('Caught error: $err');
      }
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getChildren(widget.elementList),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}