//import 'dart:developer';

import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/utils/colorful_tag.dart';
import 'package:admin/core/widgets/input_widget.dart';
import 'package:admin/data/database_services.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:admin/core/utils/Utils.dart';

class AddMemberRegistration extends StatefulWidget {
  const AddMemberRegistration({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMemberRegistration> createState() => _AddMemberRegistrationState();
}

class _AddMemberRegistrationState extends State<AddMemberRegistration> {
  String? _selectedItem = 'active'; // Variable to hold the selected item
  TextEditingController categoryController = TextEditingController();
  bool _isEnabled = true;

  void submitData() {
    //log("Adding Member Category: ${categoryController.text} with status: $_selectedItem by user: ${categoryController.text}");
    memberService.value.addMemberCategoryToDatabase(
      categoryController.text,
      _selectedItem!,
    );
    setState(() {
      _isEnabled = false;
    });
    showNewDialog(context, Colors.green, "Member Category Added Successfully");
    Future.delayed( Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 0.0,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputWidget(
              keyboardType: TextInputType.emailAddress,
              kController: categoryController,
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              onChanged: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
              topLabel: "Category",
              hintText: "Enter Name",
            ),
            SizedBox(height: 16.0),
            Text(          
              "Status",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 16),
            ),
            DropdownButton(
            value: _selectedItem, // Set the currently selected item
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: 'active',
                  child: Text('Active'),
                ),
                DropdownMenuItem<String>(
                  value: 'inactive',
                  child: Text('Inactive'),
                ),
            ],
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                _selectedItem = value; // Update the selected item
              });
            }),
            SizedBox(height: 24.0),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: _isEnabled ? submitData : null,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
      )
    );
  }
}

DataRow recentUserDataRow(RecentUser userInfo) {
  return DataRow(
    cells: [
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: getRoleColor(userInfo.role).withOpacity(.2),
            border: Border.all(color: getRoleColor(userInfo.role)),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(userInfo.role!))),
      DataCell(Text(userInfo.date!)),
      DataCell(Text(userInfo.posts!)),
    ],
  );
}
