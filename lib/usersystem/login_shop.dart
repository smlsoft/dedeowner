import 'package:dedeowner/components/singin_button.dart';
import 'package:dedeowner/dashboard.dart';
import 'package:dedeowner/model/create_shop_model.dart';
import 'package:dedeowner/model/global_model.dart';
import 'package:dedeowner/repositories/client.dart';
import 'package:dedeowner/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:dedeowner/bloc/list_shop/list_shop_bloc.dart';
import 'package:dedeowner/bloc/login_bloc/login_bloc.dart';
import 'package:dedeowner/bloc/shop_select/shop_select_bloc.dart';
import 'package:dedeowner/model/shop_model.dart';
import 'package:dedeowner/utils/util.dart';
import 'package:dedeowner/global.dart' as global;

class LoginShop extends StatefulWidget {
  const LoginShop({Key? key}) : super(key: key);

  @override
  State<LoginShop> createState() => LoginShopState();
}

class LoginShopState extends State<LoginShop> {
  bool _isLoaderVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userControl = TextEditingController();
  final TextEditingController _passControl = TextEditingController();
  final appConfig = GetStorage("AppConfig");
  bool _isListShop = false;
  bool _isListShopNotFound = false;

  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  global.LoginEnum loginType = global.LoginEnum.none;
  final bool _showPopup = false;
  late CreateShopModel createShopData;

  // Future<UserCredential?> googleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['https://www.googleapis.com/auth/contacts.readonly']).signIn();

  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  //       final OAuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       return await _auth.signInWithCredential(credential);
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<String?> getCurrentUserIdToken() async {
  //   User? currentUser = _auth.currentUser;
  //   print(currentUser);
  //   if (currentUser != null) {
  //     String? idToken = await currentUser.getIdToken();
  //     return idToken;
  //   } else {
  //     // No user is signed in.
  //     print("No user is signed in");
  //     return null;
  //   }
  // }

  @override
  void initState() {
    _userControl.text = "maxkorn";
    _passControl.text = "maxkorn";
    createShopData = CreateShopModel(
      name1: "",
      telephone: "",
      branchcode: "",
      profilepicture: "",
    );
    super.initState();
  }

  // void logoutWithGoogle() async {
  //   // await _auth.signOut();
  //   await getCurrentUserIdToken();
  // }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomRight, colors: [
            Color(0xFFF88975),
            Color(0xFFF56045),
          ])),
          child: MultiBlocListener(
            listeners: [
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    if (state.userLogin.token != '') {
                      context.read<ListShopBloc>().add(ListShopLoad());
                    }
                  }
                  if (state is TokenLoginSuccess) {
                    if (state.userLogin.token != '') {
                      context.read<ListShopBloc>().add(ListShopLoad());
                    }
                  }
                  if (state is CreateShopSuccess) {
                    context.read<ListShopBloc>().add(ListShopLoad());
                  }
                },
              ),
              BlocListener<ListShopBloc, ListShopState>(
                listener: (context, state) {
                  if (state is ListShopLoadSuccess) {
                    setState(() {
                      _isListShop = true;
                    });
                  }
                },
              ),
              BlocListener<ShopSelectBloc, ShopSelectState>(
                listener: (context, state) {
                  if (state is ShopSelectLoadSuccess) {
                    appConfig.write('shopid', state.shop.shopid);
                    Navigator.pushNamed(context, '/home');
                  }
                },
              ),
            ],
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(child: (_isListShop) ? listShopSelect() : loginShop()),
            ),
          ),
        ),
      ),
    );
  }

  void showPopup(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your details:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  setState(() {
                    createShopData.name1 = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Telephone',
                ),
                onChanged: (value) {
                  setState(() {
                    createShopData.telephone = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<LoginBloc>().add(CreateShop(createShop: createShopData));
                Navigator.pop(context, null);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget listShopSelect() {
    return Align(
      child: Card(
        color: Colors.grey.shade200,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: SizedBox(
            width: 600,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: const Text(
                        "Select Shop ",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              //logoutWithGoogle();
                              _isListShop = false;
                            });
                          },
                          child: const Text("Logout")),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: BlocBuilder<ListShopBloc, ListShopState>(
                    builder: (context, state) {
                      return (state is ListShopLoadSuccess)
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.shop.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cardItem(state.shop[index]);
                              })
                          : Container();
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget cardItem(ShopModel data) {
    return Card(
        elevation: 3,
        child: ListTile(
            onTap: (() {
              context.read<ShopSelectBloc>().add(ShopSelect(shop: data));
            }),
            title: Text(
              (data.name.isEmpty)
                  ? data.names.firstWhere((ele) => ele.code == "th", orElse: () => LanguageModel(code: 'en', name: '', codeTranslator: '', use: false)).name
                  : data.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )));
  }

  Widget loginShop() {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Card(
          color: Colors.grey.shade200,
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: SizedBox(
            width: 600,
            child: loginForm(),
          ),
        ),
      ),
    );
  }

  // Widget loginWithGoogle() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 25),
  //     child: Container(
  //       margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
  //       child: SingInButton(
  //         labelText: 'Sing in with Google',
  //         press: () {
  //           setState(() {
  //             loginType = global.LoginEnum.google;

  //             googleSignIn().then((value) async {
  //               print(value);
  //               if (value != null) {
  //                 String? userIdToken = await getCurrentUserIdToken();
  //                 if (userIdToken != null) {
  //                   context.read<LoginBloc>().add(TokenLogin(token: userIdToken));
  //                 }
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text('Login Fail User Not Found'),
  //                   ),
  //                 );
  //               }
  //             });
  //           });
  //         },
  //         img: const AssetImage("assets/img/google_logo.png"),
  //       ),
  //     ),
  //   );
  // }

  Widget loginDemo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (global.apiConnected == false) {
              if (!global.isLoginProcess) {
                global.isLoginProcess = true;
                UserRepository userRepository = UserRepository();
                await userRepository
                    .authenUser(global.apiUserName, global.apiUserPassword)
                    .then((result) async {
                      if (result.success) {
                        global.apiConnected = true;
                        global.apiToken = result.data["token"];
                        global.appConfig.write("token", result.data["token"]);
                        ApiResponse selectShop = await userRepository.selectShop(global.apiShopCode);
                        if (selectShop.success) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DashboardScreen()),
                          );
                        }
                      }
                    })
                    .catchError((e) {})
                    .whenComplete(() async {
                      global.isLoginProcess = false;
                    });
              }
            }
          },
          child: const Text(
            "DEMO",
            style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget imageLogo() {
    return Image.asset(
      "assets/img/dede-merchant-icon.png",
      height: 140,
    );
  }

  Widget loginForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageLogo(),
            const SizedBox(
              height: 25,
            ),
            usernameField(),
            const SizedBox(
              height: 10,
            ),
            passwordField(),
            const SizedBox(
              height: 10,
            ),
            loginButton(),
            // loginDemo(),
            // loginWithGoogle(),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is TokenLoginInProgress) {
                  context.loaderOverlay.show(widget: const ReconnectingOverlay());
                } else {
                  context.loaderOverlay.hide();
                }
                return (state is TokenLoginFailed)
                    ? Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      )
                    : Container();
              },
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginInProgress) {
                  context.loaderOverlay.show(widget: const ReconnectingOverlay());
                } else {
                  context.loaderOverlay.hide();
                }
                return (state is LoginFailed)
                    ? Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      )
                    : Container();
              },
            ),
            BlocBuilder<ListShopBloc, ListShopState>(
              builder: (context, state) {
                if (state is ListShopLoadFailed) {
                  return Text(
                    'ERROR SHOP ' + state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return Container();
              },
            ),
            _isListShopNotFound
                ? const Text(
                    'Shop Not Found',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget usernameField() {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _userControl,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.person,
              color: Color(0xff4c5166),
            ),
            hintText: 'ชื่อผู้ใช้',
            hintStyle: TextStyle(color: Colors.black38)),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _passControl,
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.security,
              color: Color(0xff4c5166),
            ),
            hintText: 'รหัสผ่าน',
            hintStyle: TextStyle(color: Colors.black38)),
      ),
    );
  }

  Widget loginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => DashboardScreen()),
            // );

            context.read<LoginBloc>().add(LoginOnLoad(userName: _userControl.text, passWord: _passControl.text));
          },
          child: const Text(
            "เข้าสู่ระบบ",
            style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void showSncakBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
