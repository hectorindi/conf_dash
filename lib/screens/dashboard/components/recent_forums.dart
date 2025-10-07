import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:admin/data/registration_service.dart';
import 'package:flutter/material.dart';

class RecentDiscussions extends StatefulWidget {
  const RecentDiscussions({Key? key}) : super(key: key);

  @override
  State<RecentDiscussions> createState() => _RecentDiscussionsState();
}

class _RecentDiscussionsState extends State<RecentDiscussions> {
  List<RecentUser> _recentUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentUsers();
  }

  Future<void> _loadRecentUsers() async {
    try {
      final users = await RegistrationService.getRegistrationData();
      setState(() {
        _recentUsers = users.take(10).toList(); // Show only 10 for Recent Open Positions
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading recent users: $e');
    }
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Registrations",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  "${_recentUsers.length} Positions",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 10,
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
                : _recentUsers.isEmpty
                    ? Center(
                        child: Text(
                          "No recent positions available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        child: DataTable(
                          horizontalMargin: 0,
                          columnSpacing: defaultPadding,
                          columns: [
                            DataColumn(
                              label: Text(
                                "Role",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Status",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            if (!isMobile)
                              DataColumn(
                                label: Text(
                                  "Date",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                          ],
                          rows: List.generate(
                            _recentUsers.length,
                            (index) => recentUserDataRow(_recentUsers[index], isMobile),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(RecentUser user, bool isMobile) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          constraints: BoxConstraints(maxWidth: isMobile ? 80 : 150),
          child: Text(
            user.role ?? user.name ?? "General Position",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: isMobile ? 11 : 12),
          ),
        ),
      ),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(user.name ?? "").withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getStatusColor(user.name ?? "").withOpacity(0.3),
            ),
          ),
          child: Text(
            _getStatusText(user.name ?? ""),
            style: TextStyle(
              color: _getStatusColor(user.name ?? ""),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      if (!isMobile)
        DataCell(
          Text(
            user.registrationNo != null && user.registrationNo!.isNotEmpty
                ? user.registrationNo!.length > 8 
                    ? user.registrationNo!.substring(0, 8)
                    : user.registrationNo!
                : "Recent",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
    ],
  );
}

Color _getStatusColor(String name) {
  // Simple hash-based color assignment
  final hash = name.hashCode.abs() % 3;
  switch (hash) {
    case 0:
      return Colors.green;
    case 1:
      return Colors.orange;
    default:
      return Colors.blue;
  }
}

String _getStatusText(String name) {
  // Simple hash-based status assignment
  final hash = name.hashCode.abs() % 3;
  switch (hash) {
    case 0:
      return "Active";
    case 1:
      return "Pending";
    default:
      return "Open";
  }
}
