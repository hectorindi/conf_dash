import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/utils/colorful_tag.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:flutter/material.dart';

class ShowMemberCategory extends StatefulWidget {
  const ShowMemberCategory({
    Key? key,
    required this.memberData,
  }) : super(key: key);

  final List<Map<String, dynamic>> memberData;

  @override
  State<ShowMemberCategory> createState() => _ShowMemberCategoryState();
}

class _ShowMemberCategoryState extends State<ShowMemberCategory> {
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
                  label: Text("Status"),
                ),
                DataColumn(
                  label: Text("Created Date"),
                ),
              ],
              rows: List.generate(
                widget.memberData.length,
                (index) => recentUserDataRow(widget.memberData[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(Map<String, dynamic> memeberCategory) {
  return DataRow(
    cells: [
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color:  Colors.red,
            border: Border.all(color:  Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(memeberCategory['category']!))),
      DataCell(Text(memeberCategory['createdAr']!.toString())),
      DataCell(Text(memeberCategory['status']!)),
    ],
  );
}
