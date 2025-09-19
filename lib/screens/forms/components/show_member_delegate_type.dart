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

  String _selectedItem = ""; 

  Function _menuItemFunc = (value){
    setState((value){
      _selectedItem = value;
    })
  };

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
                  label: Text("Created Date"),
                ),
                DataColumn(
                  label: Text("Memeber Category"),
                ),
                DataColumn(
                  label: Text("Status"),
                ),
              ],
              rows: List.generate(
                widget!.memberData!.length,
                (index) => recentUserDataRow(widget!.memberData![index], _menuItemFunc),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(Map<String, dynamic> memeberCategory, Function(String?)? state) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color:  Colors.red,
            border: Border.all(color:  Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: 
            Text(memeberCategory['delegate_type']!))),
      DataCell(
        Text(memeberCategory['createdAt']!.toString())),
      DataCell(
        DropdownButton(
              // Set the currently selected item
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              value: memeberCategory["memberCategory"][0]['category'],
              child: 
                  Text(memeberCategory["memberCategory"][0]['category']),
            ),
            DropdownMenuItem<String>(
              value: memeberCategory["memberCategory"][1]['category'],
              child: 
                  Text(memeberCategory["memberCategory"][1]['category']),
            ),
          ],
          onChanged: state,
        ),
      ),
      DataCell(Text(memeberCategory['status']!)),
    ],
  );
}
