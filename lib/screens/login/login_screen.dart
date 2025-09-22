import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/core/widgets/app_button_widget.dart';
import 'package:admin/core/widgets/input_widget.dart';
import 'package:admin/screens/home/home_screen.dart';
import 'package:admin/screens/login/components/slider_widget.dart';
import 'package:admin/data/login_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.title}) : super(key: key);
  final String title;
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  var tweenLeft = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
      .chain(CurveTween(curve: Curves.ease));
  var tweenRight = Tween<Offset>(begin: Offset(0, 0), end: Offset(2, 0))
      .chain(CurveTween(curve: Curves.ease));
      
  AnimationController? _animationController;
  bool _isMoved = false;
  bool _isEnabled = true;
  bool isChecked = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

void _onLoginPressed() {
  if (!_isEnabled) return;
  
  setState(() {
    _isEnabled = false;
  });

  Future(() => authService.value.signIn(
    emailController.text,
    passwordController.text,
  ))
  .then((userCredential) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  })
  .catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ),
    );
  })
  .whenComplete(() {
    if (mounted) {
      setState(() {
        _isEnabled = true;
      });
    }
  });
}

@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final isDesktop = size.width >= 600;

  return Scaffold(
    backgroundColor: bgColor, // Change this
    body: SafeArea(
      child: Container( // Add this container
        color: bgColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                height: constraints.maxHeight,
                color: bgColor, // Add this
                child: isDesktop 
                    ? Row(
                        children: _buildContent(context),
                      )
                    : Column(
                        children: _buildContent(context),
                      ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

  List<Widget> _buildContent(BuildContext context) {
  final isDesktop = MediaQuery.of(context).size.width >= 600;
  
  return <Widget>[
    if (isDesktop)
      Flexible(
        flex: 1,
        child: Container(
          color: Colors.white,
          child: SliderWidget(),
        ),
      ),
    Flexible(
      flex: 1,
      child: Container(
        color: bgColor,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 16,
          vertical: 16,
        ),
        child: Center( // Add Center widget here
          child: SingleChildScrollView( // Add SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: bgColor,
                  child: Container(
                    width: isDesktop ? 500 : MediaQuery.of(context).size.width * 0.9, // Adjust width
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center, // Add this
                      children: <Widget>[
                        Image.asset(
                          "assets/logo/logo_icon.png",
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 24.0),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: _isMoved
                              ? _registerScreen(context)
                              : _loginScreen(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ];
}

  Widget _registerScreen(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          InputWidget(
            keyboardType: TextInputType.emailAddress,
            onSaved: (String? value) {},
            onChanged: (String? value) {},
            validator: (String? value) {
              return (value != null && value.contains('@'))
                  ? 'Do not use the @ char.'
                  : null;
            },
            topLabel: "Name",
            hintText: "Enter Name",
          ),
          SizedBox(height: 8.0),
          InputWidget(
            keyboardType: TextInputType.emailAddress,
            onSaved: (String? value) {},
            onChanged: (String? value) {},
            validator: (String? value) {
              return (value != null && value.contains('@'))
                  ? 'Do not use the @ char.'
                  : null;
            },
            topLabel: "Email",
            hintText: "Enter E-mail",
          ),
          SizedBox(height: 8.0),
          InputWidget(
            topLabel: "Password",
            obscureText: true,
            hintText: "Enter Password",
            onSaved: (String? uPassword) {},
            onChanged: (String? value) {},
            validator: (String? value) {},
          ),
          SizedBox(height: 24.0),
          AppButton(
            type: ButtonType.PRIMARY,
            text: "Sign Up",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Text("Remember Me")
                ],
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Center(
            child: Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isMoved = !_isMoved;
                    });
                  },
                  child: Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                          fontWeight: FontWeight.w400,
                          color: greenColor,
                        ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginScreen(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          InputWidget(
            keyboardType: TextInputType.emailAddress,
            kController: emailController,
            onSaved: (String? value) {},
            onChanged: (String? value) {},
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            topLabel: "Email",
            hintText: "Enter E-mail",
          ),
          SizedBox(height: 16.0),
          InputWidget(
            topLabel: "Password",
            obscureText: true,
            hintText: "Enter Password",
            kController: passwordController,
            onSaved: (String? value) {},
            onChanged: (String? value) {},
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 24.0),
          Container(
            height: 48,
            child: _isEnabled
              ? AppButton(
                  type: ButtonType.PRIMARY,
                  text: "Sign In",
                  onPressed: _onLoginPressed,
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                  ),
                ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Text("Remember Me")
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: greenColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Don't have an account yet?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isMoved = !_isMoved;
                    });
                  },
                  child: Text(
                    "Sign up",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                          fontWeight: FontWeight.w400,
                          color: greenColor,
                        ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}