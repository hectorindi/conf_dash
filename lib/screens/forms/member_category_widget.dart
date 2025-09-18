import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/data/member_service.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/forms/components/add_member_category.dart';
import 'package:admin/screens/forms/components/show_member_category.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class MemberCategoryWidget extends StatefulWidget {
  @override
  _MemberCategoryWidgetState createState() => _MemberCategoryWidgetState();
}

class _MemberCategoryWidgetState extends State<MemberCategoryWidget> {
  bool _visible = false;

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: SingleChildScrollView(
        child: Card(
          color: bgColor,
          elevation: 5,
          margin: EdgeInsets.fromLTRB(32, 32, 64, 32),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Center(
                          child: Text("Member Category", style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: Colors.white)),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 1.5,
                              vertical:
                                  defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          onPressed: () {
                            _toggle();
                          },
                          icon: Icon(Icons.add),
                          label: Text(
                            "Add New",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Visibility(
                      visible: !_visible,
                      child: FutureBuilder(
                        future: memberService.value.getMemberCategoryFromDatabase(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            final List<Map<String, dynamic>> memberData = snapshot.data as List<Map<String, dynamic>>;
                            log("Member Data: $memberData");
                            return ShowMemberCategory(memberData: memberData);
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: _visible,
                      child: AddMemberCategory(),
                    ),
                    SizedBox(height: 24.0),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
