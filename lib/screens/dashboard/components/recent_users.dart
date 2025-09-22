import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/utils/colorful_tag.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

class RecentUsers extends StatelessWidget {
  const RecentUsers({
    Key? key,
  }) : super(key: key);

@override
Widget build(BuildContext context) {
  final Size _size = MediaQuery.of(context).size;
  final bool isMobile = _size.width < 600;

  return Container(
    height: 400,
    padding: EdgeInsets.all(defaultPadding),
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Candidates",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: defaultPadding),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(
                    label: Text("Name",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  DataColumn(
                    label: Text("Position",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  if (!isMobile) ...[
                    DataColumn(
                      label: Text("E-mail",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text("Date",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text("Status",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  DataColumn(
                    label: Text("Action",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                rows: List.generate(
                  recentUsers.length,
                  (index) => recentUserDataRow(recentUsers[index], context, isMobile),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

DataRow recentUserDataRow(RecentUser userInfo, BuildContext context, bool isMobile) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextAvatar(
              size: 30,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 12,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Rectangle,
              text: userInfo.name!,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                userInfo.name!,
                style: TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(maxWidth: 100),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getRoleColor(userInfo.role).withOpacity(.2),
            border: Border.all(color: getRoleColor(userInfo.role)),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            userInfo.role!,
            style: TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      if (!isMobile) ...[
        DataCell(
          Text(
            userInfo.email!,
            style: TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            userInfo.date!,
            style: TextStyle(fontSize: 11),
          ),
        ),
        DataCell(
          Text(
            userInfo.posts!,
            style: TextStyle(fontSize: 11),
          ),
        ),
      ],
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: Text('View', 
                style: TextStyle(color: greenColor, fontSize: 11),
              ),
              onPressed: () {},
            ),
            if (!isMobile) ...[
              SizedBox(width: 6),
              TextButton(
                child: Text("Delete", 
                  style: TextStyle(color: Colors.redAccent, fontSize: 11),
                ),
                onPressed: () => {}//_showDeleteDialog(context, userInfo),
              ),
            ],
          ],
        ),
      ),
    ]);
  }
}