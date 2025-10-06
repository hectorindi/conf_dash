import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/utils/colorful_tag.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:admin/data/registration_service.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

class RecentUsers extends StatefulWidget {
  const RecentUsers({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentUsers> createState() => _RecentUsersState();
}

class _RecentUsersState extends State<RecentUsers> {
  List<RecentUser> _registrationUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRegistrationData();
  }

  Future<void> _loadRegistrationData() async {
    try {
      final users = await RegistrationService.getRegistrationData();
      setState(() {
        _registrationUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading registration data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final bool isMobile = _size.width < 600;
    final bool isTablet = _size.width < 1100;

    return Container(
      height: isMobile
          ? 450
          : isTablet
              ? 500
              : 550, // Responsive height
      width: double.infinity, // Take full width
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Registrations",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  "${_registrationUsers.length} Records",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : _registrationUsers.isEmpty
                    ? Center(
                        child: Text(
                          "No registration data available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              horizontalMargin: 16,
                              columnSpacing: isMobile ? 8 : 20,
                              headingRowHeight: 50,
                              dataRowMinHeight: 55,
                              dataRowMaxHeight: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              columns: [
                                DataColumn(
                                  label: Container(
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                        fontSize: isMobile ? 11 : 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Container(
                                    child: Text(
                                      "Role",
                                      style: TextStyle(
                                        fontSize: isMobile ? 11 : 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isMobile) ...[
                                  DataColumn(
                                    label: Container(
                                      child: Text(
                                        "E-mail",
                                        style: TextStyle(
                                          fontSize: isMobile ? 11 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Container(
                                      child: Text(
                                        "Reg. No.",
                                        style: TextStyle(
                                          fontSize: isMobile ? 11 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Container(
                                      child: Text(
                                        "Date",
                                        style: TextStyle(
                                          fontSize: isMobile ? 11 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Container(
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                          fontSize: isMobile ? 11 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                DataColumn(
                                  label: Container(
                                    child: Text(
                                      "Action",
                                      style: TextStyle(
                                        fontSize: isMobile ? 11 : 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                _registrationUsers.length,
                                (index) => recentUserDataRow(
                                    _registrationUsers[index],
                                    context,
                                    isMobile),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  DataRow recentUserDataRow(
      RecentUser userInfo, BuildContext context, bool isMobile) {
    return DataRow(cells: [
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
              text: userInfo.name ?? 'N/A',
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                userInfo.name ?? 'N/A',
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
          constraints: BoxConstraints(maxWidth: 120),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getRoleColor(userInfo.role).withOpacity(.2),
            border: Border.all(color: getRoleColor(userInfo.role)),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            userInfo.role ?? 'N/A',
            style: TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
      if (!isMobile) ...[
        DataCell(
          Container(
            constraints: BoxConstraints(maxWidth: 150),
            child: Text(
              userInfo.email ?? 'N/A',
              style: TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Text(
            userInfo.registrationNo ?? 'N/A',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        DataCell(
          Text(
            userInfo.date ?? 'N/A',
            style: TextStyle(fontSize: 11),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(userInfo.posts).withOpacity(.2),
              border: Border.all(color: _getStatusColor(userInfo.posts)),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              userInfo.posts ?? 'N/A',
              style: TextStyle(
                fontSize: 10,
                color: _getStatusColor(userInfo.posts),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: Text(
                'View',
                style: TextStyle(color: greenColor, fontSize: 11),
              ),
              onPressed: () {},
            ),
            if (!isMobile) ...[
              SizedBox(width: 6),
              TextButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.redAccent, fontSize: 11),
                  ),
                  onPressed: () => {} //_showDeleteDialog(context, userInfo),
                  ),
            ],
          ],
        ),
      ),
    ]);
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'offline':
        return Colors.orange;
      case 'pending':
        return Colors.yellow[700]!;
      default:
        return Colors.grey;
    }
  }
}
