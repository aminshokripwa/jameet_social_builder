import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameet_social_network_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_network_builder/ui/helpers/helpers.dart';
import 'package:jameet_social_network_builder/ui/screens/home/home_page.dart';
import 'package:jameet_social_network_builder/ui/screens/login/forgot_password_page.dart';
import 'package:jameet_social_network_builder/ui/screens/login/verify_email_page.dart';
import 'package:jameet_social_network_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_network_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_network_builder/localization_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.clear();
    emailController.dispose();
    passwordController.clear();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        
        if( state is LoadingAuthentication ){

          modalLoading(context, LanguageJameet.checking);

        } else if( state is FailureAuthentication ) {

          Navigator.pop(context);

          if( state.error == 'Please check your email' ){
            Navigator.push(context, routeSlide(page: VerifyEmailPage(email: emailController.text.trim())));
          }

          errorMessageSnack(context, state.error);

        } else if( state is SuccessAuthentication ){

          userBloc.add(OnGetUserAuthenticationEvent());
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, routeSlide(page: const HomePage()), (_) => false);

        }

      },
      child: Scaffold(
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
              child: Form(
                key: _keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    const TextCustom(
                       text: LanguageJameet.welcome_back,
                       letterSpacing: 1.5, 
                       fontWeight: FontWeight.w600, 
                       fontSize: 30, 
                       color: ColorsJameet.secundary
                    ),
              
                    const SizedBox(height: 10.0),
                    const TextCustom(
                       text: LanguageJameet.sign_to_continue,
                       fontSize: 18,
                       letterSpacing: 1.0,
                    ),
              
                    const SizedBox(height: 70.0),
                    TextFieldJameet(
                      controller: emailController,
                      hintText: LanguageJameet.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: validatedEmail,
                    ),
              
                    const SizedBox(height: 50.0),
                    TextFieldJameet(
                      controller: passwordController,
                      hintText: LanguageJameet.password,
                      isPassword: true,
                      validator: passwordValidator,
                    ),
              
                    const SizedBox(height: 80.0),
                    BtnJameet(
                      text: LanguageJameet.log_in,
                      width: size.width,
                      onPressed: (){
    
                        if( _keyForm.currentState!.validate() ){
    
                          authBloc.add( OnLoginEvent(emailController.text.trim(), passwordController.text.trim()) );
                          
                        }
                      },
                    ),
              
                    const SizedBox(height: 30.0),
                    Center(
                      child: InkWell(
                        onTap: () => Navigator.push(context, routeSlide(page: const ForgotPasswordPage())),
                        child: const TextCustom(text: LanguageJameet.forgot_password)
                      )
                    )
              
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}