import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/models/daily_info_model.dart';
import 'package:admin/data/registration_service.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/mini_information_widget.dart';
import 'package:admin/screens/dashboard/components/chat_widget.dart';
import 'package:flutter/material.dart';

class MiniInformation extends StatefulWidget {
  const MiniInformation({
    Key? key,
  }) : super(key: key);

  @override
  State<MiniInformation> createState() => _MiniInformationState();
}

class _MiniInformationState extends State<MiniInformation> {
  void _exportData() async {
    try {
      // Use the registration service to export data
      bool success = await RegistrationService.exportRegistrationData();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration data exported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export registration data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Map<String, dynamic> _getDatafromJSON(
      List<dynamic> row, String dbName, int i) {
    Map<String, dynamic> finaldata = <String, dynamic>{};

    if (dbName == 'registration-report') {
      finaldata = <String, dynamic>{
        'Member Category': row.length > 0 ? row[0]?.toString() ?? '' : '',
        'Delegate Category': row.length > 1 ? row[1]?.toString() ?? '' : '',
        'Membership No.': row.length > 2 ? row[2]?.toString() ?? '' : '',
        'Name': row.length > 3 ? row[3]?.toString() ?? '' : '',
        'Registration No.': row.length > 4 ? row[4]?.toString() ?? '' : '',
        'Gender': row.length > 5 ? row[5]?.toString() ?? '' : '',
        'Email': row.length > 6 ? row[6]?.toString() ?? '' : '',
        'Mobile': row.length > 7 ? row[7]?.toString() ?? '' : '',
        'Institute': row.length > 8 ? row[8]?.toString() ?? '' : '',
        'Address': row.length > 9 ? row[9]?.toString() ?? '' : '',
        'City': row.length > 10 ? row[10]?.toString() ?? '' : '',
        'State': row.length > 11 ? row[11]?.toString() ?? '' : '',
        'Country': row.length > 12 ? row[12]?.toString() ?? '' : '',
        'Pin Code': row.length > 13 ? row[13]?.toString() ?? '' : '',
        'Spouse Name': row.length > 14 ? row[14]?.toString() ?? '' : '',
        'Child 1': row.length > 15 ? row[15]?.toString() ?? '' : '',
        'Child 2': row.length > 16 ? row[16]?.toString() ?? '' : '',
        'Certificate': row.length > 17 ? row[17]?.toString() ?? '' : '',
        'Net Lab': row.length > 18 ? row[18]?.toString() ?? '' : '',
        'Delegate Fees': row.length > 19 ? row[19]?.toString() ?? '' : '',
        'Accompany Fees': row.length > 20 ? row[20]?.toString() ?? '' : '',
        'Net Lab Fees': row.length > 21 ? row[21]?.toString() ?? '' : '',
        'GST': row.length > 22 ? row[22]?.toString() ?? '' : '',
        'Transaction Fees': row.length > 23 ? row[23]?.toString() ?? '' : '',
        'Total Fees': row.length > 24 ? row[24]?.toString() ?? '' : '',
        'Transaction Id': row.length > 25 ? row[25]?.toString() ?? '' : '',
        'Payment Message': row.length > 26 ? row[26]?.toString() ?? '' : '',
        'Payment Status': row.length > 27 ? row[27]?.toString() ?? '' : '',
        'createdAt': DateTime.now().toIso8601String(),
        'importedAt': DateTime.now().toIso8601String(),
        'rowIndex': i,
      };
    } else if (dbName == 'faculty-report') {
      finaldata = <String, dynamic>{
        'Abstract ID': row.length > 0 ? row[0]?.toString() ?? '' : '',
        'Member Type': row.length > 1 ? row[1]?.toString() ?? '' : '',
        'Membership No': row.length > 2 ? row[2]?.toString() ?? '' : '',
        'Name': row.length > 3 ? row[3]?.toString() ?? '' : '',
        'Qualification': row.length > 4 ? row[4]?.toString() ?? '' : '',
        'Year of Passing': row.length > 5 ? row[5]?.toString() ?? '' : '',
        'Designation': row.length > 6 ? row[6]?.toString() ?? '' : '',
        'Institute': row.length > 7 ? row[7]?.toString() ?? '' : '',
        'Age': row.length > 8 ? row[8]?.toString() ?? '' : '',
        'Photograph': row.length > 9 ? row[9]?.toString() ?? '' : '',
        'Address': row.length > 10 ? row[10]?.toString() ?? '' : '',
        'City': row.length > 11 ? row[11]?.toString() ?? '' : '',
        'State': row.length > 12 ? row[12]?.toString() ?? '' : '',
        'Pincode': row.length > 13 ? row[13]?.toString() ?? '' : '',
        'Email': row.length > 14 ? row[14]?.toString() ?? '' : '',
        'Mobile': row.length > 15 ? row[15]?.toString() ?? '' : '',
        'Specialty Subject Category 1':
            row.length > 16 ? row[16]?.toString() ?? '' : '',
        'Specialty Sub Subject Category 1':
            row.length > 17 ? row[17]?.toString() ?? '' : '',
        'Topic 1': row.length > 18 ? row[18]?.toString() ?? '' : '',
        'Topic 2': row.length > 19 ? row[19]?.toString() ?? '' : '',
        'Specialty Subject Category 2':
            row.length > 20 ? row[20]?.toString() ?? '' : '',
        'Specialty Sub Subject Category 2':
            row.length > 21 ? row[21]?.toString() ?? '' : '',
        'Topic 3': row.length > 22 ? row[22]?.toString() ?? '' : '',
        'Topic 4': row.length > 23 ? row[23]?.toString() ?? '' : '',
        'Preferred Date (Subject to availability)':
            row.length > 24 ? row[24]?.toString() ?? '' : '',
        'Date': row.length > 25 ? row[25]?.toString() ?? '' : '',
        'createdAt': DateTime.now().toIso8601String(),
        'importedAt': DateTime.now().toIso8601String(),
        'rowIndex': i,
      };
    } else if (dbName == 'abstract-report') {
      finaldata = <String, dynamic>{
        'Abstract ID': row.length > 0 ? row[0]?.toString() ?? '' : '',
        'Member Type': row.length > 1 ? row[1]?.toString() ?? '' : '',
        'DOS MSNO': row.length > 2 ? row[2]?.toString() ?? '' : '',
        'Name': row.length > 3 ? row[3]?.toString() ?? '' : '',
        'Email': row.length > 4 ? row[4]?.toString() ?? '' : '',
        'Mobile': row.length > 5 ? row[5]?.toString() ?? '' : '',
        'Institute': row.length > 6 ? row[6]?.toString() ?? '' : '',
        'Registration No.': row.length > 7 ? row[7]?.toString() ?? '' : '',
        'Presentation Type': row.length > 8 ? row[8]?.toString() ?? '' : '',
        'Category': row.length > 9 ? row[9]?.toString() ?? '' : '',
        'Title of Abstract': row.length > 10 ? row[10]?.toString() ?? '' : '',
        'Title of Video': row.length > 11 ? row[11]?.toString() ?? '' : '',
        'Abstract Synopsis': row.length > 12 ? row[12]?.toString() ?? '' : '',
        'Co-Authors Member Type 1':
            row.length > 13 ? row[13]?.toString() ?? '' : '',
        'Co-Authors DOS MSNO 1':
            row.length > 14 ? row[14]?.toString() ?? '' : '',
        'Co-Authors Name 1': row.length > 15 ? row[15]?.toString() ?? '' : '',
        'Co-Authors Email 1': row.length > 16 ? row[16]?.toString() ?? '' : '',
        'Co-Authors Mobile 1': row.length > 17 ? row[17]?.toString() ?? '' : '',
        'Co-Authors Institution 1':
            row.length > 18 ? row[18]?.toString() ?? '' : '',
        'Co-Authors Member Type 2':
            row.length > 19 ? row[19]?.toString() ?? '' : '',
        'Co-Authors DOS MSNO 2':
            row.length > 20 ? row[20]?.toString() ?? '' : '',
        'Co-Authors Name 2': row.length > 21 ? row[21]?.toString() ?? '' : '',
        'Co-Authors Email 2': row.length > 22 ? row[22]?.toString() ?? '' : '',
        'Co-Authors Mobile 2': row.length > 23 ? row[23]?.toString() ?? '' : '',
        'Co-Authors Institution 2':
            row.length > 24 ? row[24]?.toString() ?? '' : '',
        'Co-Authors Member Type 3':
            row.length > 25 ? row[25]?.toString() ?? '' : '',
        'Co-Authors DOS MSNO 3':
            row.length > 26 ? row[26]?.toString() ?? '' : '',
        'Co-Authors Name 3': row.length > 27 ? row[27]?.toString() ?? '' : '',
        'Co-Authors Email 3': row.length > 28 ? row[28]?.toString() ?? '' : '',
        'Co-Authors Mobile 3': row.length > 29 ? row[29]?.toString() ?? '' : '',
        'Co-Authors Institution 3':
            row.length > 30 ? row[30]?.toString() ?? '' : '',
        'Co-Authors Member Type 4':
            row.length > 31 ? row[31]?.toString() ?? '' : '',
        'Co-Authors DOS MSNO 4':
            row.length > 32 ? row[32]?.toString() ?? '' : '',
        'Co-Authors Name 4': row.length > 33 ? row[33]?.toString() ?? '' : '',
        'Co-Authors Email 4': row.length > 34 ? row[34]?.toString() ?? '' : '',
        'Co-Authors Mobile 4': row.length > 35 ? row[35]?.toString() ?? '' : '',
        'Co-Authors Institution 4':
            row.length > 36 ? row[36]?.toString() ?? '' : '',
        'Date': row.length > 37 ? row[37]?.toString() ?? '' : '',
        'createdAt': DateTime.now().toIso8601String(),
        'importedAt': DateTime.now().toIso8601String(),
        'rowIndex': i,
      };
    }

    return finaldata;
  }

  void _showResultDialog(int successCount, int failCount, List<String> errors) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Import Results"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("✅ Successfully imported: $successCount records"),
              if (failCount > 0) ...[
                SizedBox(height: 10),
                Text("❌ Failed to import: $failCount records"),
                if (errors.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Text("Errors:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    height: 100,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: errors
                            .map((error) =>
                                Text(error, style: TextStyle(fontSize: 12)))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding /
                          (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: _exportData,
                  icon: Icon(Icons.add),
                  label: Text(
                    "Export Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.isMobile(context) ? 10 : 16,
                    ),
                  ),
                ),
                SizedBox(width: defaultPadding),
                ChatWidget(),
              ],
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: InformationCard(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.2 : 1,
          ),
          tablet: InformationCard(),
          desktop: InformationCard(
            childAspectRatio: _size.width < 1400 ? 1.2 : 1.4,
          ),
        ),
      ],
    );
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard({
    Key? key,
    this.crossAxisCount = 5,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dailyDatas.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          MiniInformationWidget(dailyData: dailyDatas[index]),
    );
  }
}
