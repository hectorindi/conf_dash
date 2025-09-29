import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/data/database_services.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/forms/components/add_member_category.dart';
import 'package:admin/screens/forms/components/add_member_registration.dart';
import 'package:admin/screens/forms/components/show_member_registration.dart';
import 'package:flutter/material.dart';
//import 'dart:developer';

class EventRegistrationWidget extends StatefulWidget {

  const EventRegistrationWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _EventRegistrationWidgetState createState() => _EventRegistrationWidgetState();
}

class _EventRegistrationWidgetState extends State<EventRegistrationWidget> {
  bool _visible = false;

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(
            isMobile ? 16 : (isTablet ? 24 : 32),
            isMobile ? 16 : (isTablet ? 24 : 32),
            isMobile ? 16 : (isTablet ? 32 : 64),
            isMobile ? 16 : (isTablet ? 24 : 32),
          ),
          child: Card(
            color: bgColor,
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(
                isMobile ? 16.0 : (isTablet ? 24.0 : 32.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section - Responsive Layout
                  if (isMobile)
                    _buildMobileHeader(context)
                  else
                    _buildDesktopHeader(context),
                  
                  SizedBox(height: isMobile ? 16 : 24),
                  
                  // Content Section
                  Visibility(
                    visible: !_visible,
                    child: FutureBuilder(
                      future: memberService.value.getRegisteredMemebersFromDatabase(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting || 
                            snapshot.data == null) {
                          return Container(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          final List<Map<String, dynamic>> memberData = 
                              snapshot.data as List<Map<String, dynamic>>;
                          return ShowMemberRegistration(memberData: memberData);
                        }
                      },
                    ),
                  ),
                  
                  Visibility(
                    visible: _visible,
                    child: FutureBuilder(
                      future: memberService.value.getRegisterationDataFromDatabase(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting || 
                            snapshot.data == null) {
                          return Container(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          final List<Map<String, dynamic>> registrationData = 
                              snapshot.data as List<Map<String, dynamic>>;
                          return AddMemberRegistration(registrationData: registrationData);
                        }
                      },
                    ),
                  ),
                  
                  SizedBox(height: isMobile ? 16 : 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              _toggle();
            },
            icon: Icon(Icons.add, size: 20),
            label: Text(
              _visible ? "Back to List" : "Add New Category",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical: defaultPadding / (Responsive.isTablet(context) ? 1.5 : 1),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            _toggle();
          },
          icon: Icon(Icons.add),
          label: Text(
            _visible ? "Back to List" : "Add New",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}