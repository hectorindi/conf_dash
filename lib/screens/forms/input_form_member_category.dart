import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/forms/components/show_member_category.dart';
import 'package:admin/screens/forms/input_form.dart';
import 'package:flutter/material.dart';

class FormMemberCategory extends StatefulWidget {
  @override
  _FormMemberCategoryState createState() => _FormMemberCategoryState();
}

class _FormMemberCategoryState extends State<FormMemberCategory> {
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
                    Center(
                      child: Text("Member Category", style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white)),
                    ),
                    SizedBox(height: 24),
                    ShowMemberCategory(memberData: [{}]),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
