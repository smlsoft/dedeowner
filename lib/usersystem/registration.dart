// import 'package:dedeowner/components/singin_button.dart';
// import 'package:dedeowner/usersystem/create_shop.dart';
// import 'package:dedeowner/usersystem/login_shop.dart';
// import 'package:flutter/material.dart';
// import 'package:dedeowner/global.dart' as global;
// import 'package:flutter_html/flutter_html.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
// import 'package:dedeowner/usersystem/otp/otp_screen.dart';
// import 'package:dedeowner/usersystem/otp/telephone_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({Key? key}) : super(key: key);

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   global.LoginEnum loginType = global.LoginEnum.none;
//   String messages = """<b>เจ้าของกิจการหมายถึง</b> ผู้ที่สามารถสร้างกิจการ โดยสามารถสร้างบริษัทภายใต้กิจการได้หลายบริษัท และหลายสาขา พร้อมทั้งมีสิทธิ์ในการจัดการกิจการได้ 
//           เช่น เพิ่มผู้ดูแลกิจการเสริม เพิ่มผู้ดูแลบริษัท เพิ่มพนักงาน และเพิ่มสาขา<br/><br/>
//           <b>นโยบายด้านความปลอดภัย</b> ระบบ Thai 7 ทั้งหมด จะเข้าใช้โดยผ่าน ระบบ Login ของ Google หรือ Facebook หรือ Apple ID และระบบจะไม่เก็บรหัสผ่านใดๆ ไว้ในระบบ เพื่อความปลอดภัยสูงสุด เพราะฉะนั้น
//           ก่อนใช้งาน จะต้องมีบัญชีของ Google หรือ Facebook หรือ Apple ID<br/><br/>
//           <b>พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล</b> ลูกค้าจะต้องยินยอมให้ระบบเก็บข้อมูลส่วนตัวของลูกค้า และข้อมูลทั้งหมด ไว้ในระบบ<br/><br/>
//           <b>ขั้นตอนการลงทะเบียน</b> มี 3 ขั้นตอนคือ<br/>
//           <ul>
//             <li>Login ด้วย Google,Facebook,Apple ID อย่างใดอย่างหนึ่ง</li>
//             <li>ยินยอมให้ระบบเก็บข้อมูลส่วนตัวของลูกค้า และข้อมูลทั้งหมด ไว้ในระบบ Thai 7 Cloud</li>
//             <li>บันทึกหมายเลขโทรศัพท์เพื่อรับ OTP จากเรา และทำการยืนยันตัวตน ด้วย OTP จึงจะสามารถเข้าใช้งานได้</li>
//           </ul>""";

//   // Future googleSignIn() async {
//   //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//   //   final GoogleSignInAuthentication googleAuth =
//   //       await googleUser!.authentication;
//   //   final credential = GoogleAuthProvider.credential(
//   //     accessToken: googleAuth.accessToken,
//   //     idToken: googleAuth.idToken,
//   //   );
//   //   await FirebaseAuth.instance.signInWithCredential(credential);
//   //   global.loginName = googleUser.displayName!;
//   //   global.loginEmail = googleUser.email;
//   //   global.loginPhotoUrl = googleUser.photoUrl!;
//   //   return googleUser.email;
//   // }

//   Future<UserCredential?> googleSignIn() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['https://www.googleapis.com/auth/contacts.readonly']).signIn();

//       // Obtain the auth details from the request
//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//         // Create a new credential
//         final OAuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );

//         // Sign in to Firebase with the Google [UserCredential]

//         return await _auth.signInWithCredential(credential);
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<String?> getCurrentUserIdToken() async {
//     User? currentUser = _auth.currentUser;

//     if (currentUser != null) {
//       String? idToken = await currentUser.getIdToken();
//       return idToken;
//     } else {
//       // No user is signed in.
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             appBar: AppBar(
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               title: const Text('ลงทะเบียนใหม่'),
//             ), //
//             body: SingleChildScrollView(
//                 child: Center(
//                     child: Column(children: <Widget>[
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 "ลงทะเบียนใหม่ เพื่อเป็นเจ้าของกิจการ",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Html(data: messages),
//               const SizedBox(
//                 height: 20,
//               ),
//               Column(
//                 children: [
//                   Container(
//                       margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
//                       child: SingInButton(
//                         labelText: 'Sing in with Line',
//                         press: () {
//                           setState(() {
//                             loginType = global.LoginEnum.google;
//                             googleSignIn().then((value) async {
//                               if (value != null) {
//                                 String? userIdToken = await getCurrentUserIdToken();

//                                 print(userIdToken);
//                               }
//                             });
//                           });
//                         },
//                         img: const AssetImage("assets/img/line_logo.png"),
//                       )),
//                   Container(
//                       margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
//                       child: SingInButton(
//                         labelText: 'Sing in with Google',
//                         press: () {
//                           setState(() {
//                             loginType = global.LoginEnum.google;
//                             googleSignIn().then((value) {
//                               if (value != null) {
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const TelephoneScreen()));
//                               }
//                             });
//                           });
//                         },
//                         img: const AssetImage("assets/img/google_logo.png"),
//                       )),
//                   Container(
//                     margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
//                     child: SingInButton(
//                       labelText: 'Sing in with Facebook',
//                       press: () {},
//                       img: const AssetImage("assets/img/facebook_logo.png"),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
//                     child: SingInButton(
//                       labelText: 'Sing in with Apple ID',
//                       press: () {},
//                       img: const AssetImage("assets/img/apple_logo.png"),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
//                     child: SingInButton(
//                       labelText: 'Sing in with Phone Number',
//                       press: () {},
//                       img: const AssetImage("assets/img/apple_logo.png"),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 100,
//                   )
//                 ],
//               ),
//             ])))));
//   }
// }
