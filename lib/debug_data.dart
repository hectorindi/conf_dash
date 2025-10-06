import 'package:flutter/material.dart';
import 'package:admin/data/registration_service.dart';
import 'package:admin/models/recent_user_model.dart';

class DebugDataScreen extends StatefulWidget {
  @override
  _DebugDataScreenState createState() => _DebugDataScreenState();
}

class _DebugDataScreenState extends State<DebugDataScreen> {
  List<RecentUser> _users = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });
      
      List<RecentUser> users = await RegistrationService.getRegistrationData();
      
      setState(() {
        _users = users;
        _isLoading = false;
      });
      
      print('Loaded ${users.length} users in debug screen');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Data Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_error'),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _users.isEmpty
                  ? Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        RecentUser user = _users[index];
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                (user.name?.isNotEmpty == true) 
                                    ? user.name![0].toUpperCase() 
                                    : 'U',
                              ),
                            ),
                            title: Text(user.name ?? 'No Name'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${user.email ?? 'No Email'}'),
                                Text('Role: ${user.role ?? 'No Role'}'),
                                Text('Date: ${user.date ?? 'No Date'}'),
                                Text('Status: ${user.posts ?? 'No Status'}'),
                                Text('Reg No: ${user.registrationNo ?? 'No Reg No'}'),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
    );
  }
}