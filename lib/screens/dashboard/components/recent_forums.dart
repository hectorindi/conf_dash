import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/utils/colorful_tag.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:flutter/material.dart';

class RecentDiscussions extends StatelessWidget {
  const RecentDiscussions({Key? key}) : super(key: key);

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
            "Recent Open Positions",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: defaultPadding),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(
                    label: Text(
                      "Name",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Position",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  if (!isMobile)
                    DataColumn(
                      label: Text(
                        "Email",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
                rows: List.generate(
                  recentUsers.length,
                  (index) => recentUserDataRow(recentUsers[index], isMobile),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(RecentUser userInfo, bool isMobile) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: getRoleColor(userInfo.role),
              child: Text(
                userInfo.role![0], // First letter of role
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                userInfo.role!,
                style: TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getRoleColor(userInfo.role).withOpacity(.2),
            border: Border.all(color: getRoleColor(userInfo.role)),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            userInfo.date!, // Using date as position title
            style: TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      if (!isMobile)
        DataCell(
          Text(
            userInfo.posts!, // Using posts as email
            style: TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ],
  );
}
