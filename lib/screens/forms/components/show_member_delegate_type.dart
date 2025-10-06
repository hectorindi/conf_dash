import 'package:admin/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class ShowMemberDelegateType extends StatefulWidget {
  const ShowMemberDelegateType({
    Key? key,
    required this.memberData,
  }) : super(key: key);

  final List<Map<String, dynamic>> memberData;

  @override
  State<ShowMemberDelegateType> createState() => _ShowMemberDelegateTypeState();
}

class _ShowMemberDelegateTypeState extends State<ShowMemberDelegateType> {
  // Map to store selected values for each row
  Map<int, String> selectedValues = {};

  @override
  void initState() {
    super.initState();
    if (widget.memberData.isNotEmpty &&
        widget.memberData[0]["memberCategory"] != null) {
      // Initialize default values
      for (var i = 0; i < widget.memberData.length; i++) {
        selectedValues[i] =
            widget.memberData[i]["memberCategory"]?[0]['category'];
      }
    }
  }

  void updateSelectedValue(int index, String value) {
    setState(() {
      selectedValues[index] = value;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.memberData.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Text(
                  "No data available",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(
                    label: Text("Category"),
                  ),
                  DataColumn(
                    label: Text("Created Date"),
                  ),
                  DataColumn(
                    label: Text("Memeber Category"),
                  ),
                ],
                rows: List.generate(
                  widget.memberData.length,
                  (index) => recentUserDataRow(
                      widget.memberData[index],
                      selectedValues[index] ?? 'N/A', // Add null safety here
                      (value) => updateSelectedValue(index, value!),
                      index),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(Map<String, dynamic> memberCategory,
    String selectedValue, Function(String?) onChanged, int index) {
  // Add null checks for memberCategory data
  final items = (memberCategory["memberCategory"] as List?)
          ?.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category['category'],
          child: Text(category['category'] ?? 'N/A'),
        );
      })?.toList() ??
      [];

  return DataRow(
    cells: [
      DataCell(Text(memberCategory['delegate_type'] ?? 'N/A')),
      DataCell(Text(memberCategory['createdAt']?.toString() ?? 'N/A')),
      DataCell(
        items.isEmpty
            ? Text('No categories available')
            : DropdownButton<String>(
                value: selectedValue,
                items: items,
                onChanged: onChanged,
              ),
      ),
    ],
  );
}
