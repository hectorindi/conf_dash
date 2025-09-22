import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/utils/colorful_tag.dart';
import 'package:admin/models/recent_user_model.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          // Mobile Layout
          if (Responsive.isMobile(context))
            ...widget.memberData.map((data) => _buildMobileCard(data)).toList()
          
          // Desktop/Tablet Layout
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 200,
                ),
                child: DataTable(
                  horizontalMargin: 0,
                  columnSpacing: defaultPadding,
                  columns: [
                    DataColumn(label: Text("Category")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Created Date")),
                  ],
                  rows: widget.memberData
                      .map((data) => _buildDataRow(data))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileCard(Map<String, dynamic> memberCategory) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  "Category:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    memberCategory['category'] ?? 'N/A',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Status
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  "Status:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (memberCategory['status'] ?? 'N/A').toLowerCase() == 'active' 
                        ? Colors.green 
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    (memberCategory['status'] ?? 'N/A').toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Created Date
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  "Created:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _formatTimestamp(memberCategory['createdAt']),
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 12,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> memberCategory) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              memberCategory['category'] ?? 'N/A',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(Text(memberCategory['status'] ?? 'N/A')),
        DataCell(
          Container(
            width: 150,
            child: Text(
              _formatTimestamp(memberCategory['createdAt']),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    
    try {
      DateTime? dateTime;
      
      // If it's already a DateTime
      if (timestamp is DateTime) {
        dateTime = timestamp;
      }
      // If it's a Timestamp object (Firestore)
      else if (timestamp.toString().contains('Timestamp')) {
        // Extract seconds from the string format
        String timestampStr = timestamp.toString();
        RegExp regExp = RegExp(r'seconds=(\d+)');
        Match? match = regExp.firstMatch(timestampStr);
        
        if (match != null) {
          int seconds = int.parse(match.group(1)!);
          dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        }
      }
      // If it's a string, try to parse it
      else if (timestamp is String) {
        dateTime = DateTime.tryParse(timestamp);
      }
      // If it's an integer (milliseconds or seconds)
      else if (timestamp is int) {
        dateTime = timestamp > 1000000000000 
            ? DateTime.fromMillisecondsSinceEpoch(timestamp)
            : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }
      
      if (dateTime != null) {
        // Format as "Sep 19, 2025 14:30"
        return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
      }
      
      return timestamp.toString();
    } catch (e) {
      return 'Invalid Date';
    }
  }
}