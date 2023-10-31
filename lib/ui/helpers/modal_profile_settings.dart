import 'package:flutter/material.dart';
import 'package:jameet_social_network_builder/ui/helpers/helpers.dart';
import 'package:jameet_social_network_builder/ui/screens/profile/setting_profile_page.dart';
import 'package:jameet_social_network_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_network_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_network_builder/ui/screens/notifications/notifications_page.dart';
import 'package:jameet_social_network_builder/ui/screens/messages/list_messages_page.dart';
import 'package:jameet_social_network_builder/localization_helper.dart';

modalProfileSetting(BuildContext context, Size size) {

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
    backgroundColor: Colors.white,
    builder: (context) => Container(
      height: size.height * .25,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(50.0)
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Item(
              icon: Icons.settings,
              text: LanguageJameet.setting,
              size: size,
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, routeSlide(page: const SettingProfilePage()));
              },
            ),
            Item(
              icon: Icons.history,
              text: LanguageJameet.your_activity,
              size: size,
              onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const NotificationsPage()), (_) => false),
            ),
            Item(
              icon: Icons.question_answer,
              text: LanguageJameet.messeges,
              size: size,
              onPressed: () => Navigator.push(context, routeSlide(page: const ListMessagesPage())),
            ),
          ],
        ),
      ),
    ),
  );

}

class Item extends StatelessWidget {

  final IconData icon;
  final String text;
  final Size size;
  final VoidCallback onPressed;

  const Item({
    Key? key,
    required this.icon,
    required this.text,
    required this.size,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: size.width,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: ColorsJameet.secundary
        ),
        child: Align(
          alignment: Alignment.centerLeft, 
          child: Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 10.0),
              TextCustom(text: text, fontSize: 17)
            ],
          )
        ),
      ),
    );
  }
}