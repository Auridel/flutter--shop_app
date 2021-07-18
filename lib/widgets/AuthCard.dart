import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/helpers/error_helper.dart' as errorHelper;
import 'package:shop_app/screens/product_overview_screen.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  
  void _showErrorDialog(String message) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text('An error occured'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(ctx).pop();
        }, child: Text('Okay'))
      ],
    ));
  }

  Future<void> _submit() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'] ?? '', _authData['password'] ?? '');
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'] ?? '', _authData['password'] ?? '');
      }
      Navigator.of(context).pushReplacementNamed(ProductOverviewScreen.routeName);
    } on HttpException catch (e) {
      print(e.toString());
      final errorMessage = errorHelper.getErrorMessage(e);
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('Could not authenticate you. Please try again later.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthModel() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Invalid email';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value ?? '';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return 'Password too short';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value ?? '';
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value == null ||
                                value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        color: Theme.of(context).primaryTextTheme.button?.color,
                      )),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthModel,
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'} INSTEAD',
                  ),
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 4),
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
