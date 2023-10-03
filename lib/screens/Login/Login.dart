import 'package:assignment/screens/nav/bloc/incidents_bloc.dart';
import 'package:assignment/screens/nav/stack_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment/screens/Login/bloc/Login_bloc.dart';


class SharedPreferencesHelper {
  static const _kLoggedInKey = 'loggedIn';

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kLoggedInKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedInKey) ?? false;
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Map<String, String> validUsers = {
    'user1': '123',
    'user2': '456',
  };
  bool visiblePassword = false;
  bool CheckedValue = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose(){
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
}
  @override
  Widget build(BuildContext context) {
    final Logbloc = Provider.of<LoginBloc>(context, listen: false);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 64, 110),
      body: Form(
        key: _formkey,
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage("assets/images/logo.jpg")),
                StreamBuilder<String>(
                    stream: Logbloc.loginUsername,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)
                            )
                        ),
                        onChanged: (value) => Logbloc.changeLoginUsername,
                      );
                    }
                ),
                SizedBox(
                  height: 25,
                ),
                StreamBuilder(
                    stream: Logbloc.loginPassword,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: visiblePassword ? false : true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)
                            ),
                            suffixIcon: IconButton(
                              icon: visiblePassword
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  visiblePassword = !visiblePassword;
                                });
                              },
                            )
                        ),
                        onChanged: (value) => Logbloc.changeLoginPassword,
                      );
                    }
                ),
                Row(
                  children: [
                    //                 CheckboxListTile(
                    //                   title: Text("Remember me"),
                    //                   value: CheckedValue,
                    //                   onChanged: (newValue){},
                    //                   controlAffinity: ListTileControlAffinity.leading,
                    //
                    // ),
                    SizedBox(width: 10,),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Forgot Password?",
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  //TODO ADD FORGOTPASSWORDSCREEN
                                }
                          )
                        ]
                    ))
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Container(
                    width: 359,
                    child: ElevatedButton(
                      onPressed: () async {
                        print('Username:${usernameController.text}');
                        print('Password:${passwordController.text}');
                        final enteredUsername = usernameController.text;
                        final enteredPassword = passwordController.text;
                        if (validUsers.containsKey(enteredUsername)) {
                          if (validUsers[enteredUsername] == enteredPassword) {
                            await SharedPreferencesHelper.setLoggedIn(true);
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  StackViewScreen(bloc: IncidentsBloc())),
                            );
                            usernameController.clear();
                            passwordController.clear();
                          }
                          else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Authentication Error'),
                                  content: Text('Incorrect password.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                        else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Authentication Error'),
                                content: Text('Username not found.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        };
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        backgroundColor: Colors.white54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      child: Text('SIGN IN'),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),

      ),
    );
  }
}


