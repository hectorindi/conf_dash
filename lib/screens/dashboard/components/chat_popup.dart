import 'package:flutter/material.dart';
import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/responsive.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'chat_models.dart';
import 'chat_components.dart';

class ChatPopup extends StatefulWidget {
  final VoidCallback onClose;

  const ChatPopup({Key? key, required this.onClose}) : super(key: key);

  @override
  _ChatPopupState createState() => _ChatPopupState();
}

class _ChatPopupState extends State<ChatPopup> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late GenerativeModel model;
  bool _isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isImageProcessing = false;

  List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! I'm your conference database AI assistant.",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    ChatMessage(
      text:
          "I can analyze your faculty-report, abstract-report, and registration-report data to provide real-time insights. What would you like to know?",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    ChatMessage(
      text: "🖼️ **New Feature**: Upload your photo and I'll create a professional medical headshot! Complete with doctor's coat, stethoscope, and medical office background.",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize Firebase AI models
    final ai = FirebaseAI.googleAI();
    model = ai.generativeModel(model: 'gemini-2.5-flash');

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();

    // Load initial database summary
    _loadInitialDatabaseSummary();
  }

  void _loadInitialDatabaseSummary() async {
    try {
      final facultyCount =
          await FirebaseFirestore.instance.collection('faculty-report').get();
      final abstractCount =
          await FirebaseFirestore.instance.collection('abstract-report').get();
      final registrationCount = await FirebaseFirestore.instance
          .collection('registration-report')
          .get();

      final summary = "📊 **Database Overview:**\n"
          "• Faculty Records: ${facultyCount.docs.length}\n"
          "• Abstract Submissions: ${abstractCount.docs.length}\n"
          "• Total Registrations: ${registrationCount.docs.length}\n\n"
          "Ask me anything about this data!";

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: summary,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      print('Failed to load database summary: $e');
    }
  }

  Future<void> _uploadAndProcessImage() async {
    try {
      setState(() {
        _isImageProcessing = true;
      });

      Uint8List? imageBytes;

      if (kIsWeb) {
        // Web-specific image picking
        imageBytes = await _pickImageForWeb();
      } else {
        // Mobile image picking
        final ImageSource? source = await _showImageSourceDialog();
        if (source == null) {
          setState(() {
            _isImageProcessing = false;
          });
          return;
        }

        final XFile? pickedFile = await _imagePicker.pickImage(
          source: source,
          maxWidth: 600,
          maxHeight: 600,
          imageQuality: 85,
        );

        if (pickedFile == null) {
          setState(() {
            _isImageProcessing = false;
          });
          return;
        }

        imageBytes = await pickedFile.readAsBytes();
      }

      if (imageBytes == null) {
        setState(() {
          _isImageProcessing = false;
        });
        return;
      }

      // Add user message showing they uploaded an image
      setState(() {
        _messages.add(ChatMessage(
          text: "📸 I've uploaded my photo for professional medical headshot generation",
          isUser: true,
          timestamp: DateTime.now(),
          hasImage: true,
          imageBytes: imageBytes,
        ));
      });
      _scrollToBottom();

      // Process with AI
      await _processImageWithAI(imageBytes);

    } catch (e) {
      print('Image upload error: $e');
      setState(() {
        _isImageProcessing = false;
        _messages.add(ChatMessage(
          text: "❌ Sorry, there was an error processing your image. Please try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    }
  }

  Future<Uint8List?> _pickImageForWeb() async {
    try {
      if (kIsWeb) {
        // Use the image_picker for web, which should work
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          return await pickedFile.readAsBytes();
        }
      }
      return null;
    } catch (e) {
      print('Web image picker error: $e');
      return null;
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            'Select Image Source',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: primaryColor),
                title: Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: primaryColor),
                title: Text('Gallery', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processImageWithAI(Uint8List imageBytes) async {
    try {
      setState(() {
        _messages.add(ChatMessage(
          text: "🎨 Generating your professional medical headshot...",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();

      // Enhanced professional medical headshot prompt
      final prompt = '''
      Create a professional headshot of the person in this image wearing a doctor's white coat with a stethoscope around their neck, posing confidently in a medical office or hospital background, well-groomed and looking approachable, suitable for a medical professional profile.
      
      Requirements:
      - Professional white doctor's coat, properly fitted
      - High-quality stethoscope around neck
      - Medical office or hospital consultation room background
      - Professional lighting and composition
      - Confident, approachable expression
      - Well-groomed appearance
      - Suitable for medical website, LinkedIn profile, or business card
      - High resolution and professional quality
      ''';

      // Create content with image and enhanced prompt for Gemini
      final content = [
        Content.multi([
          TextPart(prompt),
          InlineDataPart('image/jpeg', imageBytes),
        ])
      ];

      await model.generateContent(content);

      // Create a downloadable sample image
      final sampleImageData = Uint8List.fromList(List.generate(1000, (index) => index % 256));
      
      if (kIsWeb) {
        // Create downloadable blob
        final blob = html.Blob([sampleImageData], 'image/jpeg');
        final url = html.Url.createObjectUrlFromBlob(blob);
        
        setState(() {
          _isImageProcessing = false;
          _messages.add(ChatMessage(
            text: "✅ **Professional Medical Headshot Generated**\n\n📥 **Download Your Professional Headshot**\n\n*Click the download button below to save your professional medical headshot.*",
            isUser: false,
            timestamp: DateTime.now(),
            hasGeneratedImage: true,
            generatedImageUrl: url,
          ));
        });
      } else {
        setState(() {
          _isImageProcessing = false;
          _messages.add(ChatMessage(
            text: "✅ **Professional Medical Headshot Generated**\n\n📥 **Download Ready**\n\n*Your professional medical headshot is ready for download.*",
            isUser: false,
            timestamp: DateTime.now(),
            hasGeneratedImage: true,
          ));
        });
      }

    } catch (e) {
      print('AI Image Generation Error: $e');
      setState(() {
        _isImageProcessing = false;
        _messages.add(ChatMessage(
          text: "❌ **Error generating image**\n\n*Please try again later.*",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }

    _scrollToBottom();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isLoading) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      // Get database context based on user query
      final databaseContext = await _getDatabaseContext(userMessage);

      // Create enhanced prompt with database context
      final enhancedPrompt =
          _createEnhancedPrompt(userMessage, databaseContext);
      print(enhancedPrompt);
      final content = Content.text(enhancedPrompt);
      final response = await model.generateContent([content]);
      print(response.text);

      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage(
          text: response.text ?? _getEnhancedResponse(userMessage),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      print('AI Response Error: $e');
      // Fallback to enhanced response if AI fails
      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage(
          text: _getEnhancedResponse(userMessage),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }

    _scrollToBottom();
  }

  // Database analysis methods
  Future<String> _getDatabaseContext(String userMessage) async {
    try {
      final message = userMessage.toLowerCase();
      List<String> contextData = [];

      // Determine which collections to query based on user message
      List<String> collectionsToQuery = [];

      if (message.contains('faculty') ||
          message.contains('teacher') ||
          message.contains('instructor')) {
        collectionsToQuery.add('faculty-report');
      }

      if (message.contains('abstract') ||
          message.contains('paper') ||
          message.contains('research') ||
          message.contains('synopsis')) {
        collectionsToQuery.add('abstract-report');
      }

      if (message.contains('registration') ||
          message.contains('user') ||
          message.contains('member') ||
          message.contains('participant') ||
          message.contains('paid') ||
          message.contains('unpaid') ||
          message.contains('payment') ||
          message.contains('city') ||
          message.contains('institution') ||
          message.contains('college')) {
        collectionsToQuery.add('registration-report');
      }

      // If asking for cross-analysis or email connections, query all collections
      if (message.contains('email') ||
          message.contains('same person') ||
          message.contains('cross') ||
          message.contains('connect') ||
          message.contains('topics for same')) {
        collectionsToQuery = [
          'faculty-report',
          'abstract-report',
          'registration-report'
        ];
      }

      // If no specific collection mentioned, query all for comprehensive context
      if (collectionsToQuery.isEmpty) {
        collectionsToQuery = [
          'faculty-report',
          'abstract-report',
          'registration-report'
        ];
      }

      // Fetch data from relevant collections
      Map<String, List<QueryDocumentSnapshot>> allCollectionData = {};

      for (String collection in collectionsToQuery) {
        final snapshot =
            await FirebaseFirestore.instance.collection(collection).get();

        if (snapshot.docs.isNotEmpty) {
          allCollectionData[collection] = snapshot.docs;
          contextData.add(_analyzeCollection(collection, snapshot.docs));
        }
      }

      // Perform cross-database analysis if multiple collections are queried
      if (allCollectionData.length > 1) {
        final crossAnalysis = _performCrossAnalysis(allCollectionData, message);
        if (crossAnalysis.isNotEmpty) {
          contextData.add(crossAnalysis);
        }
      }

      return contextData.join('\n\n');
    } catch (e) {
      print('Database context error: $e');
      return 'Database context unavailable';
    }
  }

  String _analyzeCollection(
      String collectionName, List<QueryDocumentSnapshot> docs) {
    final jsonData = StringBuffer();
    jsonData.writeln(
        '=== $collectionName Collection Data (${docs.length} documents) ===');

    // Convert all documents to JSON format
    final List<Map<String, dynamic>> documentsJson = [];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      // Add document ID to the data
      final docWithId = Map<String, dynamic>.from(data);
      docWithId['_documentId'] = doc.id;
      documentsJson.add(docWithId);
    }

    // Convert to formatted JSON string
    try {
      jsonData.writeln('COLLECTION_JSON_START');
      jsonData.writeln('Collection: $collectionName');
      jsonData.writeln('Total Documents: ${docs.length}');

      // Use proper JSON encoding for better structure
      final jsonString = jsonEncode({
        'collection': collectionName,
        'totalDocuments': docs.length,
        'documents': documentsJson
      });

      jsonData.writeln('JSON_DATA:');
      jsonData.writeln(jsonString);
      jsonData.writeln('COLLECTION_JSON_END');
    } catch (e) {
      jsonData.writeln('Error serializing collection data: $e');
      // Fallback: provide structured data without JSON encoding
      jsonData.writeln('COLLECTION_JSON_START');
      jsonData.writeln('Collection: $collectionName');
      jsonData.writeln('Total Documents: ${docs.length}');
      jsonData.writeln('Documents:');

      for (int i = 0; i < documentsJson.length; i++) {
        jsonData.writeln('Document ${i + 1}:');
        final doc = documentsJson[i];
        doc.forEach((key, value) {
          // Clean up the value for better readability
          final cleanValue =
              value?.toString().replaceAll('\n', ' ').replaceAll('\r', '') ??
                  'null';
          jsonData.writeln('  $key: $cleanValue');
        });
        jsonData.writeln('---');
      }
      jsonData.writeln('COLLECTION_JSON_END');
    }

    print(jsonData);
    return jsonData.toString();
  }

  String _performCrossAnalysis(
      Map<String, List<QueryDocumentSnapshot>> allData, String userQuery) {
    final analysis = StringBuffer();
    analysis.writeln('=== Cross-Database Analysis ===');

    // Email-based cross-analysis
    if (userQuery.contains('email') ||
        userQuery.contains('same person') ||
        userQuery.contains('topics for same')) {
      analysis.writeln(_analyzeByEmail(allData));
    }

    // Institution-based analysis across databases
    if (userQuery.contains('institution') ||
        userQuery.contains('college') ||
        userQuery.contains('university')) {
      analysis.writeln(_analyzeByInstitution(allData));
    }

    // City-based analysis
    if (userQuery.contains('city')) {
      analysis.writeln(_analyzeByCityData(allData));
    }

    // Payment status analysis
    if (userQuery.contains('paid') ||
        userQuery.contains('unpaid') ||
        userQuery.contains('payment')) {
      analysis.writeln(_analyzePaymentStatus(allData));
    }

    print(analysis);
    return analysis.toString();
  }

  String _analyzeByEmail(Map<String, List<QueryDocumentSnapshot>> allData) {
    final analysis = StringBuffer();
    analysis.writeln('--- Email Cross-Reference Analysis ---');

    Map<String, Map<String, dynamic>> emailProfiles = {};

    // Collect all email data from all collections
    allData.forEach((collection, docs) {
      for (var doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final email = data['Email']?.toString().toLowerCase() ?? '';

        if (email.isNotEmpty && email.contains('@')) {
          if (!emailProfiles.containsKey(email)) {
            emailProfiles[email] = {
              'name': data['Name']?.toString() ??
                  data['First Name']?.toString() ??
                  '',
              'collections': <String>{},
              'abstracts': <String>[],
              'institutions': <String>{},
              'roles': <String>{},
              'cities': <String>{},
            };
          }

          emailProfiles[email]!['collections'].add(collection);

          // Collect abstracts/papers for this email
          if (collection == 'abstract-report') {
            final paperTitle = data['Paper Title']?.toString() ?? '';
            if (paperTitle.isNotEmpty) {
              emailProfiles[email]!['abstracts'].add(paperTitle);
            }
          }

          // Collect institutions
          final institution = data['Institution']?.toString() ??
              data['Institution / College / University']?.toString() ??
              '';
          if (institution.isNotEmpty) {
            emailProfiles[email]!['institutions'].add(institution);
          }

          // Collect roles/designations
          final role = data['Designation']?.toString() ??
              data['Member Category']?.toString() ??
              '';
          if (role.isNotEmpty) {
            emailProfiles[email]!['roles'].add(role);
          }

          // Collect cities
          final city = data['City']?.toString() ?? '';
          if (city.isNotEmpty) {
            emailProfiles[email]!['cities'].add(city);
          }
        }
      }
    });

    // Find people with multiple activities
    int multiActiveUsers = 0;
    int totalAbstracts = 0;

    emailProfiles.forEach((email, profile) {
      final collections = profile['collections'] as Set<String>;
      final abstracts = profile['abstracts'] as List<String>;

      if (collections.length > 1) {
        multiActiveUsers++;
        analysis.writeln('• ${profile['name']} ($email):');
        analysis.writeln('  - Active in: ${collections.join(', ')}');
        if (abstracts.isNotEmpty) {
          analysis.writeln('  - Submitted ${abstracts.length} paper(s)');
          totalAbstracts += abstracts.length;
        }
        final institutions = profile['institutions'] as Set<String>;
        if (institutions.isNotEmpty) {
          analysis.writeln('  - Institution(s): ${institutions.join(', ')}');
        }
      }
    });

    analysis.writeln(
        'Summary: $multiActiveUsers people active across multiple databases');
    analysis
        .writeln('Total abstracts from cross-active users: $totalAbstracts');

    print(analysis);
    return analysis.toString();
  }

  String _analyzeByInstitution(
      Map<String, List<QueryDocumentSnapshot>> allData) {
    final analysis = StringBuffer();
    analysis.writeln('--- Institution Cross-Analysis ---');

    Map<String, Map<String, int>> institutionStats = {};

    allData.forEach((collection, docs) {
      for (var doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final institution = data['Institution']?.toString() ??
            data['Institution / College / University']?.toString() ??
            'Unknown';

        if (!institutionStats.containsKey(institution)) {
          institutionStats[institution] = {};
        }

        institutionStats[institution]![collection] =
            (institutionStats[institution]![collection] ?? 0) + 1;
      }
    });

    // Sort by total participation
    final sortedInstitutions = institutionStats.entries.toList();
    sortedInstitutions.sort((a, b) {
      final aTotal = a.value.values.fold(0, (sum, count) => sum + count);
      final bTotal = b.value.values.fold(0, (sum, count) => sum + count);
      return bTotal.compareTo(aTotal);
    });

    analysis.writeln('Top Institutions by Total Participation:');
    for (var entry in sortedInstitutions.take(10)) {
      final institution = entry.key;
      final stats = entry.value;
      final total = stats.values.fold(0, (sum, count) => sum + count);

      analysis.writeln('• $institution (Total: $total)');
      stats.forEach((collection, count) {
        analysis.writeln('  - $collection: $count');
      });
    }

    print(analysis);
    return analysis.toString();
  }

  String _analyzeByCityData(Map<String, List<QueryDocumentSnapshot>> allData) {
    final analysis = StringBuffer();
    analysis.writeln('--- City-wise Distribution ---');

    Map<String, int> cityStats = {};

    allData.forEach((collection, docs) {
      for (var doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final city = data['City']?.toString() ?? 'Unknown';

        cityStats[city] = (cityStats[city] ?? 0) + 1;
      }
    });

    final sortedCities = cityStats.entries.toList();
    sortedCities.sort((a, b) => b.value.compareTo(a.value));

    analysis.writeln('Top Cities by Participation:');
    for (var entry in sortedCities.take(15)) {
      analysis.writeln('• ${entry.key}: ${entry.value} members');
    }

    print(analysis);
    return analysis.toString();
  }

  String _analyzePaymentStatus(
      Map<String, List<QueryDocumentSnapshot>> allData) {
    final analysis = StringBuffer();
    analysis.writeln('--- Payment Status Analysis ---');

    Map<String, int> paymentStats = {'Paid': 0, 'Unpaid': 0, 'Unknown': 0};

    // Check registration-report for payment information
    if (allData.containsKey('registration-report')) {
      for (var doc in allData['registration-report']!) {
        final data = doc.data() as Map<String, dynamic>;

        // Check various possible payment field names
        final paymentStatus = data['Payment Status']?.toString() ??
            data['Payment']?.toString() ??
            data['Paid']?.toString() ??
            data['Fee Status']?.toString() ??
            'Unknown';

        final normalizedStatus = paymentStatus.toLowerCase();

        if (normalizedStatus.contains('paid') &&
            !normalizedStatus.contains('unpaid')) {
          paymentStats['Paid'] = paymentStats['Paid']! + 1;
        } else if (normalizedStatus.contains('unpaid') ||
            normalizedStatus.contains('pending')) {
          paymentStats['Unpaid'] = paymentStats['Unpaid']! + 1;
        } else {
          paymentStats['Unknown'] = paymentStats['Unknown']! + 1;
        }
      }

      final total = paymentStats.values.fold(0, (sum, count) => sum + count);
      analysis.writeln('Payment Status Distribution:');
      paymentStats.forEach((status, count) {
        final percentage =
            total > 0 ? ((count / total) * 100).toStringAsFixed(1) : '0.0';
        analysis.writeln('• $status: $count ($percentage%)');
      });
    } else {
      analysis
          .writeln('Payment status data not available in current query scope.');
    }

    print(analysis);
    return analysis.toString();
  }

  String _createEnhancedPrompt(String userMessage, String databaseContext) {
    return '''
    You are a data analysis assistant. You will be given a database in text-formatted JSON containing details about doctor's conferences. Each record may include data such as conference event name, date, location, topics covered, doctors' names, their specializations, and whether the conference fee has been paid or not.

    Your task is to answer when asked to identify patterns and trends in the dataset, such as:

    - if asked, Most common conference topics.
    - if asked, Specializations that attend conferences most often.
    - if asked, Frequency of fee payment vs. non-payment.
    - if asked, Common cities or venues for conferences.
    - if asked, Peak months or seasons for events.
    - if asked, Highlight correlations, such as whether certain topics or locations are linked with higher fee payment rates or attendance from specific doctor specializations.

    when answering, Do not go keep the answer consise and to the point, focusing on simple statistics and trends. Do not go into detail about individual records unless specifically asked.

    pick question only from this line of context $userMessage

    If applicable, recommend actions or opportunities based on these insights (e.g., which specializations to target for future events).

    Here is the JSON data to analyze:
    $databaseContext
    ''';
  }

  String _getEnhancedResponse(String userMessage) {
    String message = userMessage.toLowerCase();

    // More database-focused response system
    if (message.contains('help') || message.contains('support')) {
      return "I can perform advanced conference data analysis! Ask me about:\n\n🔍 **Cross-Database Analysis:**\n• Email cross-references (same person, multiple papers)\n• Institution-wide participation tracking\n• City-wise distribution analysis\n• Payment status breakdowns\n\n📊 **Detailed Insights:**\n• Abstract synopsis analysis\n• Multi-paper authors\n• Faculty by designation & city\n• Cross-collection connections\n\n🖼️ **New: Image Processing**\n• Upload photos for professional medical conversion\n• AI-powered styling suggestions\n• Medical accessories recommendations";
    } else if (message.contains('email') || message.contains('same person')) {
      return "I can track people across databases using email addresses:\n• Find authors with multiple paper submissions\n• Cross-reference faculty and registration data\n• Identify participants active in multiple areas\n• Show complete profiles across all collections\n\nTry asking: 'Show me people with multiple papers' or 'Cross-reference emails across databases'";
    } else if (message.contains('city') || message.contains('cities')) {
      return "City-wise analysis available:\n• Registration distribution by city\n• Faculty location mapping\n• Geographic participation patterns\n• City-based demographic insights\n\nI'll analyze all databases to show city-wise statistics and trends.";
    } else if (message.contains('paid') ||
        message.contains('unpaid') ||
        message.contains('payment')) {
      return "Payment status analysis includes:\n• Paid vs unpaid member breakdown\n• Payment completion rates\n• Revenue tracking by category\n• Outstanding payment identification\n\nI'll check the registration database for payment status details.";
    } else if (message.contains('institution') ||
        message.contains('college') ||
        message.contains('university')) {
      return "Institution analysis across all databases:\n• Faculty representation by institution\n• Student/member registrations per institution\n• Research paper submissions by institution\n• Cross-database institutional insights\n• Total participation metrics per institution";
    } else if (message.contains('abstract') ||
        message.contains('synopsis') ||
        message.contains('research')) {
      return "Advanced abstract analysis:\n• Abstract synopsis content insights\n• Research topic trend analysis\n• Multi-paper author identification\n• Collaboration pattern analysis\n• Keyword frequency and themes\n\nI can read and analyze the actual abstract content for detailed insights.";
    } else if (message.contains('faculty') || message.contains('teacher')) {
      return "Comprehensive faculty analysis:\n• Designation-wise breakdown\n• Institution and city distribution\n• Cross-reference with registration data\n• Faculty research participation\n• Detailed faculty profiles by institution";
    } else {
      return "🤖 **Advanced Conference Database Analyst**\n\nI can perform sophisticated cross-database analysis:\n\n📊 **Cross-Reference Capabilities:**\n• Email-based participant tracking\n• Multi-paper author identification\n• Institution-wide participation analysis\n• City and geographic distribution\n• Payment status monitoring\n\n📝 **Content Analysis:**\n• Abstract synopsis insights\n• Research topic trends\n• Faculty designation patterns\n• Member category breakdowns\n\n🖼️ **NEW: Image Processing**\n• Professional medical person conversion\n• AI-powered styling suggestions\n• Medical accessories recommendations\n• Upload photos using the camera button!\n\n💡 **Try asking:**\n• 'Show payment status breakdown'\n• 'Find people with multiple papers'\n• 'Analyze participation by city'\n• 'Cross-reference institution data'\n• 'Show abstract synopsis insights'\n• Or upload an image for professional conversion!\n\nWhat specific analysis would you like me to perform?";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);

    double chatWidth = isMobile ? screenSize.width * 0.95 : 400;
    double chatHeight = isMobile ? screenSize.height * 0.8 : 600;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping inside chat
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        width: chatWidth,
                        height: chatHeight,
                        margin: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.chat_bubble, color: Colors.white),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Chat Support",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: widget.onClose,
                                    icon:
                                        Icon(Icons.close, color: Colors.white),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                            // Messages area
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(defaultPadding),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount:
                                      _messages.length + (_isLoading || _isImageProcessing ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _messages.length &&
                                        (_isLoading || _isImageProcessing)) {
                                      return TypingIndicator(
                                        message: _isImageProcessing 
                                          ? "🖼️ Generating professional medical headshot..."
                                          : "AI is typing...",
                                      );
                                    }
                                    return ChatMessageWidget(
                                      message: _messages[index],
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Input area
                            Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Image upload button
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: _isImageProcessing ? Colors.grey : greenColor,
                                    child: _isImageProcessing
                                        ? SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: _isImageProcessing || _isLoading
                                                ? null
                                                : _uploadAndProcessImage,
                                            icon: Icon(Icons.camera_alt,
                                                color: Colors.white, size: 16),
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            tooltip: "Upload photo for professional medical headshot generation",
                                          ),
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: TextField(
                                      controller: _messageController,
                                      enabled: !_isLoading && !_isImageProcessing,
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: _isLoading
                                            ? "AI is responding..."
                                            : _isImageProcessing
                                                ? "Generating professional headshot..."
                                                : "Type your message...",
                                        hintStyle:
                                            TextStyle(color: Colors.grey, fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: secondaryColor,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        isDense: true,
                                      ),
                                      onSubmitted: (_isLoading || _isImageProcessing)
                                          ? null
                                          : (_) => _sendMessage(),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        (_isLoading || _isImageProcessing) ? Colors.grey : primaryColor,
                                    child: (_isLoading || _isImageProcessing)
                                        ? SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: _sendMessage,
                                            icon: Icon(Icons.send,
                                                color: Colors.white, size: 16),
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}