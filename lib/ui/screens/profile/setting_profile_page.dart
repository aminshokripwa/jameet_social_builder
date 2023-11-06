//https://stackoverflow.com/questions/50573933/how-to-implement-a-share-button-in-flutter-app
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jameet_social_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_builder/ui/helpers/helpers.dart';
import 'package:jameet_social_builder/ui/screens/login/started_page.dart';
import 'package:jameet_social_builder/ui/screens/profile/account_profile_page.dart';
import 'package:jameet_social_builder/ui/screens/profile/change_password_page.dart';
import 'package:jameet_social_builder/ui/screens/profile/privacy_profile_page.dart';
import 'package:jameet_social_builder/ui/screens/profile/about_app_page.dart';
import 'package:jameet_social_builder/ui/screens/profile/help_page.dart';
import 'package:jameet_social_builder/ui/screens/profile/widgets/item_profile.dart';
import 'package:jameet_social_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_builder/ui/widgets/widgets.dart';
import 'package:share/share.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class SettingProfilePage extends StatelessWidget {

  const SettingProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TextCustom(text: LanguageJameet.setting, fontSize: 19, fontWeight: FontWeight.w500),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black)
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          children: [

            /*
            Container(
              height: 35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for',
                  hintStyle: GoogleFonts.getFont('Roboto', color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search)
                ),
              ),
            ),
            */
            const SizedBox(height: 15.0),
            ItemProfile(
              text: LanguageJameet.share_invate_friend,
              icon: Icons.person_add_alt,
              onPressed: (){
                Share.share(LanguageJameet.check_url_app, subject: LanguageJameet.header_share);
              }
            ),
            /*
            ItemProfile(
              text: 'Notifications',
              icon: Icons.notifications_none_rounded,
              onPressed: (){}
            ),
            */
            ItemProfile(
              text: LanguageJameet.privacy,
              icon: Icons.lock_outline_rounded,
              onPressed: () => Navigator.push(context, routeSlide(page: const PrivacyProgilePage()))
            ),
            ItemProfile(
              text: LanguageJameet.security,
              icon: Icons.security_outlined,
              onPressed: () => Navigator.push(context, routeSlide(page: const ChangePasswordPage()))
            ),
            ItemProfile(
              text: LanguageJameet.update_profile,
              icon: Icons.account_circle_outlined,
              onPressed: () => Navigator.push(context, routeSlide(page: const AccountProfilePage()))
            ),
            ItemProfile(
              text: LanguageJameet.help,
              icon: Icons.help_outline_rounded,
                onPressed: () => Navigator.push(context, routeSlide(page: const WebviewPage()))
            ),
            ItemProfile(
              text: LanguageJameet.about,
              icon: Icons.info_outline_rounded,
                onPressed: () => Navigator.push(context, routeSlide(page: const AboutAppPage()))
            ),
            /*
            const SizedBox(height: 20.0),
            Row(
              children: const [
                Icon(Icons.copyright_outlined),
                SizedBox(width: 5.0),
                TextCustom(text: 'Jameet DEVELOPER', fontSize: 17, fontWeight: FontWeight.w500),
              ],
            ),
            const SizedBox(height: 30.0),
            const TextCustom(text: 'Sessions', fontSize: 17, fontWeight: FontWeight.w500),
            */
            const SizedBox(height: 30.0),
            ItemProfile(
              text: '${LanguageJameet.close_acount} ${userBloc.state.user!.username}',
              icon: Icons.logout_rounded,
              colorText: ColorsJameet.primary,
              onPressed: () {
                authBloc.add( OnLogOutEvent() );
                userBloc.add( OnLogOutUser() );
                Navigator.pushAndRemoveUntil(context, routeSlide(page: const StartedPage()), (_) => false);
              }
            ),
          ],
        ),
      ),
    );
  }
}