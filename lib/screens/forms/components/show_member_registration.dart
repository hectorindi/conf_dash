import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/utils/colorful_tag.dart';
import 'package:admin/models/member_registration_model.dart';
import 'package:admin/data/member_registration_service.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

class ShowMemberRegistration extends StatefulWidget {
  const ShowMemberRegistration({
    Key? key,

  }) : super(key: key);

  @override
  State<ShowMemberRegistration> createState() => _ShowMemberRegistrationState();
}

class _ShowMemberRegistrationState extends State<ShowMemberRegistration> {
  List<MemberRegistration> _memberRegistrations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemberRegistrations();
  }

  Future<void> _loadMemberRegistrations() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      _memberRegistrations = await MemberRegistrationService.getMemberRegistrationData();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading member registrations: $e');
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
                "Member Registrations",
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
                  "${_memberRegistrations.length} Members",
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
                : _memberRegistrations.isEmpty
                    ? Center(
                        child: Text(
                          "No member registrations available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: DataTable(
                                
                                horizontalMargin: 8,
                                columnSpacing: isMobile ? 4 : 12,
                                headingRowHeight: 45,
                                dataRowMinHeight: 50,
                                dataRowMaxHeight: 60,
                                showCheckboxColumn: false,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              columns: [
                                DataColumn(
                                  label: Text(
                                    "Name",
                                    style: TextStyle(
                                      fontSize: isMobile ? 10 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Category",
                                    style: TextStyle(
                                      fontSize: isMobile ? 10 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                if (!isMobile) ...[
                                  DataColumn(
                                    label: Text(
                                      "E-mail",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Phone",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "City",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Reg. ID",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                                DataColumn(
                                  label: Text(
                                    "Status",
                                    style: TextStyle(
                                      fontSize: isMobile ? 10 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Action",
                                    style: TextStyle(
                                      fontSize: isMobile ? 10 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                _memberRegistrations.length,
                                (index) => _buildDataRow(
                                    _memberRegistrations[index],
                                    context,
                                    isMobile),
                              ),
                            ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(MemberRegistration memberInfo, BuildContext context, bool isMobile) {
    return DataRow(cells: [
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextAvatar(
              size: isMobile ? 24 : 28,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 10,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Rectangle,
              text: memberInfo.name == null ? memberInfo.name : 'User',
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                ((memberInfo.name == null) ? memberInfo.name : memberInfo.name) ?? 'Unknown User',
                style: TextStyle(fontSize: isMobile ? 10 : 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(maxWidth: isMobile ? 80 : 100),
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: getRoleColor(memberInfo.memberCategory ?? 'General').withOpacity(.2),
            border: Border.all(color: getRoleColor(memberInfo.memberCategory ?? 'General')),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            (memberInfo.memberCategory?.isNotEmpty == true) ? memberInfo.memberCategory! : 'General',
            style: TextStyle(fontSize: 9),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
      if (!isMobile) ...[
        DataCell(
          Container(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text(
              (memberInfo.email?.isNotEmpty == true) ? memberInfo.email! : 'No email',
              style: TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Text(
            (memberInfo.phone?.isNotEmpty == true) ? memberInfo.phone! : 'N/A',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
        DataCell(
          Text(
            (memberInfo.city?.isNotEmpty == true) ? memberInfo.city! : 'N/A',
            style: TextStyle(fontSize: 10),
          ),
        ),
        DataCell(
          Text(
            (memberInfo.registrationId?.isNotEmpty == true) ? memberInfo.registrationId! : 'N/A',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
      ],
      DataCell(
        Container(
          constraints: BoxConstraints(maxWidth: isMobile ? 70 : 80),
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _getStatusColor(memberInfo.paymentStatus ?? 'Pending').withOpacity(.2),
            border: Border.all(color: _getStatusColor(memberInfo.paymentStatus ?? 'Pending')),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            (memberInfo.paymentStatus?.isNotEmpty == true) ? memberInfo.paymentStatus! : 'Pending',
            style: TextStyle(
              fontSize: 9,
              color: _getStatusColor(memberInfo.paymentStatus ?? 'Pending'),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View',
                style: TextStyle(color: greenColor, fontSize: isMobile ? 9 : 10),
              ),
              onPressed: () {},
            ),
            if (!isMobile) ...[
              SizedBox(width: 2),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.redAccent, fontSize: 10),
                ),
                onPressed: () => {} //_showDeleteDialog(context, memberInfo),
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
