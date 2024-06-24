import 'package:chat_app/setting/widgets/inner_setting/notification.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/setting/models/setting.dart';

class DataUsages extends StatefulWidget {
  const DataUsages({super.key});

  @override
  State<DataUsages> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<DataUsages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 44, 44),
        title: Text(
          'Data Usage and Proxy',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Media Auto-Download',
              style: TextStyle(
                color: kprimaryColor,
                fontSize: ksmallFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(
                settings.length,
                (index) => InnerSettingSwitch(setting: settings5[index]),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
