import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jameet_social_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.clear();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const TextCustom(
                    text: LanguageJameet.recover_your_account,
                    letterSpacing: 1.5, 
                    fontWeight: FontWeight.w500, 
                    fontSize: 25, 
                    color: ColorsJameet.secundary
                ),
          
                const SizedBox(height: 10.0),
                const TextCustom(
                    text: LanguageJameet.enter_your_email_to_recovery,
                    fontSize: 17,
                    letterSpacing: 1.0,
                    maxLines: 2,
                ),
          
                SizedBox(
                  height: 300,
                  width: size.width,
                  child: SvgPicture.asset('assets/svg/undraw_forgot_password.svg'),
                ),
          
                const SizedBox(height: 10.0),
                TextFieldJameet(
                  controller: emailController,
                  hintText: LanguageJameet.email,
                  keyboardType: TextInputType.emailAddress,
                ),
          
                const SizedBox(height: 40.0),
                BtnJameet(
                  text: LanguageJameet.search_account,
                  width: size.width,
                  onPressed: (){},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}