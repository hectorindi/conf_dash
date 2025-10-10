import 'package:flutter/material.dart';
import 'color_constants.dart';

class StyleConstants {
  // Text Styles
  static const TextStyle whiteText = TextStyle(color: Colors.white);
  static const TextStyle whiteTextSmall = TextStyle(color: Colors.white, fontSize: 13);
  static const TextStyle whiteTextTiny = TextStyle(color: Colors.white, fontSize: 10);
  static const TextStyle whiteTextLarge = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle white54Text = TextStyle(color: Colors.white54);
  static const TextStyle white60Text = TextStyle(color: Colors.white60, fontSize: 10);
  static const TextStyle white70Text = TextStyle(color: Colors.white70, fontSize: 13);
  
  static const TextStyle greyText = TextStyle(color: Colors.grey);
  static const TextStyle greyTextSmall = TextStyle(color: Colors.grey, fontSize: 12);
  
  static const TextStyle greenText = TextStyle(color: greenColor);
  
  static const TextStyle mediumText = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static const TextStyle boldText = TextStyle(fontWeight: FontWeight.w600);
  static const TextStyle smallBoldText = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
  
  // Chat specific text styles
  static const TextStyle chatMessageText = TextStyle(color: Colors.white, fontSize: 13);
  static const TextStyle chatTimestampText = TextStyle(color: Colors.white60, fontSize: 10);
  static const TextStyle chatHintText = TextStyle(color: Colors.grey, fontSize: 12);
  
  // Button Styles
  static ButtonStyle primaryElevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    minimumSize: const Size(0, 32),
  );
  
  static ButtonStyle greenElevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: greenColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    minimumSize: const Size(0, 32),
  );
  
  static ButtonStyle primaryTextButtonStyle = TextButton.styleFrom(
    foregroundColor: primaryColor,
  );
  
  // Responsive button style function
  static ButtonStyle responsiveElevatedButtonStyle(BuildContext context, bool isMobile) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding * 1.5,
        vertical: defaultPadding / (isMobile ? 2 : 1),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
  
  // Form button styles
  static ButtonStyle formSubmitButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  static ButtonStyle formSecondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  // Container Decorations
  static BoxDecoration chatContainerDecoration = BoxDecoration(
    color: secondaryColor,
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ],
  );
  
  static BoxDecoration chatHeaderDecoration = const BoxDecoration(
    color: primaryColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    ),
  );
  
  static BoxDecoration chatInputDecoration = const BoxDecoration(
    color: bgColor,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
  );
  
  static BoxDecoration messageUserDecoration = const BoxDecoration(
    color: primaryColor,
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );
  
  static BoxDecoration messageAiDecoration = BoxDecoration(
    color: Colors.grey[800],
    borderRadius: const BorderRadius.all(Radius.circular(16)),
  );
  
  // Input Decorations
  static InputDecoration chatInputFieldDecoration = InputDecoration(
    hintStyle: greyTextSmall,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: secondaryColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    isDense: true,
  );
  
  // Padding and Sizing
  static const EdgeInsets chatMessagePadding = EdgeInsets.symmetric(vertical: 6, horizontal: 4);
  static const EdgeInsets chatContainerPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets chatHeaderPadding = EdgeInsets.all(defaultPadding);
  static const EdgeInsets chatInputPadding = EdgeInsets.all(defaultPadding);
  
  // Icon sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 18.0;
  static const double largeIconSize = 24.0;
  
  // Avatar sizes
  static const double smallAvatarRadius = 14.0;
  static const double mediumAvatarRadius = 18.0;
  
  // Box constraints
  static const BoxConstraints chatImageConstraints = BoxConstraints(maxHeight: 200);
  static BoxConstraints responsiveChatConstraints(BuildContext context) {
    return BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.7,
    );
  }
  
  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration typingAnimationDuration = Duration(milliseconds: 1500);
  
  // Border radius
  static const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(8));
  static const BorderRadius messageBorderRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius imageBorderRadius = BorderRadius.all(Radius.circular(8));
}