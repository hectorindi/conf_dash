//import 'dart:developer';

import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/utils/colorful_tag.dart';
import 'package:admin/core/widgets/input_widget.dart';
import 'package:admin/data/database_services.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:admin/core/utils/Utils.dart';

class AddMemberDelegateType extends StatefulWidget {
  const AddMemberDelegateType({
    Key? key,
    required this.memberData,
  }) : super(key: key);

  final List<Map<String, dynamic>> memberData;

  @override
  State<AddMemberDelegateType> createState() => _AddMemberDelegateTypeState();
}

class _AddMemberDelegateTypeState extends State<AddMemberDelegateType> {
  String? _selectedItem = 'active'; // Variable to hold the selected item
  TextEditingController delegateTypeController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  bool _isEnabled = true;

  String? selectedMemberCategory;
  Map<String, dynamic>? selectedMemberCategoryMap;

  @override
  void initState() {
    super.initState();
    // Set initial value from the first category if available
    if (widget.memberData[0]["error"] == null && widget.memberData.isNotEmpty && widget.memberData[0]["memberCategory"].isNotEmpty) {
      selectedMemberCategory = widget.memberData[0]["memberCategory"][0]["category"];
    }
  }

  Map<String, dynamic> getmemeberID() {
    List<Map<String, dynamic>> memData = widget.memberData[0]["memberCategory"];
    Map<String, dynamic> result = {};
    
    for (var value in memData) {
      if (value['category'] == selectedMemberCategory) {
        return value; // Return the matching category map
      }
    }
    return {}; // Return empty map if no match found
  }

  void submitData() {
    //log("Adding DelegateType type : ${delegateTypeController.text} with status: $_selectedItem");
    Map<String, dynamic> memberData = getmemeberID();
    double rate = double.parse(rateController.text);
    
    // Extract the uid string from the map
    String uid = memberData['uid']?.toString() ?? '';
    
    memberService.value.addDelegateTypeToDatabase(
      delegateTypeController.text,
      _selectedItem!,
      rate,
      uid  // Pass the uid as String
    );
    
    setState(() {
      _isEnabled = false;
    });
    
    showNewDialog(context, Colors.green, "Member delegate type Added Successfully");
    Future.delayed(Duration(seconds: 1), () {
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
              kController: delegateTypeController,
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              onChanged: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },

              topLabel: "Delegate Type",

              hintText: "Delegate Type",
              // prefixIcon: FlutterIcons.chevron_left_fea,
            ),
            SizedBox(height: 16.0),
            InputWidget(
              keyboardType: TextInputType.number,
              kController: rateController,
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              onChanged: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },

              topLabel: "Rate",

              hintText: "Rate",
              // prefixIcon: FlutterIcons.chevron_left_fea,
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
            DropdownButton<String>(
              value: selectedMemberCategory,
              hint: Text("Select Member Category"),
              items: widget.memberData[0]["memberCategory"].map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category['category'],
                  child: Text(category['category']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMemberCategory = newValue;
                });
              },
            ),
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

DataRow recentUserDataRow(
  Map<String, dynamic> memberCategory, 
  String selectedValue,
  Function(String?) onChanged,
  int index
) {
  return DataRow(
    cells: [
      DataCell(Text(memberCategory['delegate_type'] ?? 'N/A')), // Category column
      DataCell(Text(memberCategory['createdAt']?.toString() ?? 'N/A')), // Created Date column
      DataCell( // Member Category column with dropdown
        DropdownButton<String>(
          value: selectedValue,
          items: memberCategory["memberCategory"].map<DropdownMenuItem<String>>((category) {
            return DropdownMenuItem<String>(
              value: category['category'],
              child: Text(category['category']),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}
