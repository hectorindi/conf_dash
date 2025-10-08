import 'package:admin/core/constants/color_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalRegistrationInfoModel {
  IconData? icon;
  String? title;
  String? totalStorage;
  int? volumeData;
  int? percentage;
  Color? color;
  List<Color>? colors;
  List<FlSpot>? spots;

  TotalRegistrationInfoModel({
    this.icon,
    this.title,
    this.totalStorage,
    this.volumeData,
    this.percentage,
    this.color,
    this.colors,
    this.spots,
  });

  TotalRegistrationInfoModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    volumeData = json['volumeData'];
    icon = json['icon'];
    totalStorage = json['totalStorage'];
    color = json['color'];
    percentage = json['percentage'];
    colors = json['colors'];
    spots = json['spots'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['volumeData'] = this.volumeData;
    data['icon'] = this.icon;
    data['totalStorage'] = this.totalStorage;
    data['color'] = this.color;
    data['percentage'] = this.percentage;
    data['colors'] = this.colors;
    data['spots'] = this.spots;
    return data;
  }
}

class DailyInfoService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static List<TotalRegistrationInfoModel>? _cachedData;
  static DateTime? _lastFetchTime;
  static const Duration cacheValidDuration = Duration(minutes: 5);
  
  static Future<List<TotalRegistrationInfoModel>> getDailyData() async {
    // Return cached data if available and still valid
    if (_cachedData != null && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < cacheValidDuration) {
      print('Returning cached daily data');
      return _cachedData!;
    }
    
    try {
      // Fetch data from all three collections with timeout
      final List<Future<QuerySnapshot>> futures = [
        _firestore.collection('registration-report').get().timeout(Duration(seconds: 10)),
        _firestore.collection('abstract-report').get().timeout(Duration(seconds: 10)),
        _firestore.collection('faculty-report').get().timeout(Duration(seconds: 10)),
      ];
      
      final results = await Future.wait(futures, eagerError: false);
      
      // Handle results safely
      int registrationCount = 0;
      int abstractCount = 0;
      int facultyCount = 0;
      
      try {
        registrationCount = results[0].docs.length;
      } catch (e) {
        print('Error fetching registration data: $e');
      }
      
      try {
        abstractCount = results[1].docs.length;
      } catch (e) {
        print('Error fetching abstract data: $e');
      }
      
      try {
        facultyCount = results[2].docs.length;
      } catch (e) {
        print('Error fetching faculty data: $e');
      }
      
      print('Data counts - Registration: $registrationCount, Abstracts: $abstractCount, Faculty: $facultyCount');
      
      // Calculate growth percentages (dummy calculation for now)
      final registrationGrowth = _calculateGrowthPercentage(registrationCount);
      final abstractGrowth = _calculateGrowthPercentage(abstractCount);
      final facultyGrowth = _calculateGrowthPercentage(facultyCount);
      
      final data = [
        TotalRegistrationInfoModel(
          title: "Total Registration",
          volumeData: registrationCount,
          icon: FlutterIcons.user_alt_faw5s,
          totalStorage: "+ ${registrationGrowth}%",
          color: primaryColor,
          percentage: 35,
          colors: [
            Color(0xff23b6e6),
            Color(0xff02d39a),
          ],
          spots: _generateSpots(registrationCount),
        ),
        TotalRegistrationInfoModel(
          title: "Total Abstracts",
          volumeData: abstractCount,
          icon: FlutterIcons.message1_ant,
          totalStorage: "+ ${abstractGrowth}%",
          color: Color(0xFFFFA113),
          percentage: 35,
          colors: [Color(0xfff12711), Color(0xfff5af19)],
          spots: _generateSpots(abstractCount),
        ),
        TotalRegistrationInfoModel(
          title: "Total Faculty",
          volumeData: facultyCount,
          icon: FlutterIcons.comment_alt_faw5s,
          totalStorage: "+ ${facultyGrowth}%",
          color: Color(0xFFA4CDFF),
          percentage: 10,
          colors: [Color(0xff2980B9), Color(0xff6DD5FA)],
          spots: _generateSpots(facultyCount),
        ),
      ];
      
      // Cache the data
      _cachedData = data;
      _lastFetchTime = DateTime.now();
      
      return data;
    } catch (e) {
      print('Error fetching daily data: $e');
      // Return cached data if available, otherwise fallback data
      return _cachedData ?? _getFallbackData();
    }
  }
  
  // Method to clear cache and force refresh
  static void clearCache() {
    _cachedData = null;
    _lastFetchTime = null;
  }
  
  static int _calculateGrowthPercentage(int currentCount) {
    // Simple growth calculation - you can enhance this based on historical data
    if (currentCount > 100) return 20;
    if (currentCount > 50) return 15;
    if (currentCount > 20) return 8;
    return 5;
  }
  
  static List<FlSpot> _generateSpots(int dataCount) {
    // Generate dynamic spots based on actual data count
    final baseValue = (dataCount / 100).clamp(1.0, 5.0);
    return [
      FlSpot(1, baseValue * 0.8),
      FlSpot(2, baseValue * 0.6),
      FlSpot(3, baseValue * 1.2),
      FlSpot(4, baseValue * 0.9),
      FlSpot(5, baseValue * 0.7),
      FlSpot(6, baseValue * 1.4),
      FlSpot(7, baseValue * 1.1),
      FlSpot(8, baseValue * 1.0),
    ];
  }
  
  static List<TotalRegistrationInfoModel> _getFallbackData() {
    return [
      TotalRegistrationInfoModel(
        title: "Total Registration",
        volumeData: 0,
        icon: FlutterIcons.user_alt_faw5s,
        totalStorage: "+ 0%",
        color: primaryColor,
        percentage: 35,
        colors: [Color(0xff23b6e6), Color(0xff02d39a)],
        spots: [FlSpot(1, 1), FlSpot(2, 1), FlSpot(3, 1), FlSpot(4, 1), FlSpot(5, 1), FlSpot(6, 1), FlSpot(7, 1), FlSpot(8, 1)],
      ),
      TotalRegistrationInfoModel(
        title: "Total Abstracts",
        volumeData: 0,
        icon: FlutterIcons.message1_ant,
        totalStorage: "+ 0%",
        color: Color(0xFFFFA113),
        percentage: 35,
        colors: [Color(0xfff12711), Color(0xfff5af19)],
        spots: [FlSpot(1, 1), FlSpot(2, 1), FlSpot(3, 1), FlSpot(4, 1), FlSpot(5, 1), FlSpot(6, 1), FlSpot(7, 1), FlSpot(8, 1)],
      ),
      TotalRegistrationInfoModel(
        title: "Total Faculty",
        volumeData: 0,
        icon: FlutterIcons.comment_alt_faw5s,
        totalStorage: "+ 0%",
        color: Color(0xFFA4CDFF),
        percentage: 10,
        colors: [Color(0xff2980B9), Color(0xff6DD5FA)],
        spots: [FlSpot(1, 1), FlSpot(2, 1), FlSpot(3, 1), FlSpot(4, 1), FlSpot(5, 1), FlSpot(6, 1), FlSpot(7, 1), FlSpot(8, 1)],
      ),
    ];
  }
}

// Keep the old static data as fallback, but now use dynamic data by default
Future<List<TotalRegistrationInfoModel>> getDailyDatas() async {
  return await DailyInfoService.getDailyData();
}

List<TotalRegistrationInfoModel> dailyDatas = [];

// For backward compatibility, provide a function to get static data
List<TotalRegistrationInfoModel> getStaticDailyDatas() {
  return dailyData.map((item) => TotalRegistrationInfoModel.fromJson(item)).toList();
}

//List<FlSpot> spots = yValues.asMap().entries.map((e) {
//  return FlSpot(e.key.toDouble(), e.value);
//}).toList();

var dailyData = [
  {
    "title": "Total Registration",
    "volumeData": 1328,
    "icon": FlutterIcons.user_alt_faw5s,
    "totalStorage": "+ %20",
    "color": primaryColor,
    "percentage": 35,
    "colors": [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ],
    "spots": [
      FlSpot(
        1,
        2,
      ),
      FlSpot(
        2,
        1.0,
      ),
      FlSpot(
        3,
        1.8,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        2.2,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  },
  {
    "title": "Total Abstracts",
    "volumeData": 1328,
    "icon": FlutterIcons.message1_ant,
    "totalStorage": "+ %5",
    "color": Color(0xFFFFA113),
    "percentage": 35,
    "colors": [Color(0xfff12711), Color(0xfff5af19)],
    "spots": [
      FlSpot(
        1,
        1.3,
      ),
      FlSpot(
        2,
        1.0,
      ),
      FlSpot(
        3,
        4,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        3,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  },
  {
    "title": "Total Faculty",
    "volumeData": 1328,
    "icon": FlutterIcons.comment_alt_faw5s,
    "totalStorage": "+ %8",
    "color": Color(0xFFA4CDFF),
    "percentage": 10,
    "colors": [Color(0xff2980B9), Color(0xff6DD5FA)],
    "spots": [
      FlSpot(
        1,
        1.3,
      ),
      FlSpot(
        2,
        5,
      ),
      FlSpot(
        3,
        1.8,
      ),
      FlSpot(
        4,
        6,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        2.2,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1,
      )
    ]
  }
];
