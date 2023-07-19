import 'package:flutter/material.dart';
import 'package:dedeowner/global.dart' as global;
import 'package:get_storage/get_storage.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  SelectLanguageScreenState createState() => SelectLanguageScreenState();
}

class SelectLanguageScreenState extends State<SelectLanguageScreen> {
  List<String> countryNames = ["English", "Thai", "Laos", "Chiness", "Japan", "Korea"];
  List<String> countryCodes = ["en", "th", "lo", "zh", "ja", "ko"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: countryNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: Row(children: [
                        Image.asset(
                          'assets/flags/${countryCodes[index]}.png',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(width: 10),
                        Text(countryNames[index])
                      ]),
                      onTap: () {
                        setState(() {
                          global.userLanguage = countryCodes[index];
                          GetStorage().write('language', global.userLanguage);
                          global.languageSelect(global.userLanguage);
                          Navigator.of(context).pushReplacementNamed('/menu');
                        });
                      },
                    );
                  }))),
    );
  }
}
