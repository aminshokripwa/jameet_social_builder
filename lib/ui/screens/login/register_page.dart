import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:jameet_social_network_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_network_builder/ui/helpers/helpers.dart';
import 'package:jameet_social_network_builder/ui/screens/login/login_page.dart';
import 'package:jameet_social_network_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_network_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_network_builder/localization_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  late TextEditingController fullNameController;
  late TextEditingController userController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    userController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        
        if( state is LoadingUserState ){

          modalLoading(context, 'Charging...');

        }else if( state is SuccessUserState ){

          Navigator.pop(context);
          modalSuccess(
            context, 'Registered user',
            onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const LoginPage()), (route) => false)
          );

        }else if( state is FailureUserState ){

          Navigator.pop(context);
          errorMessageSnack(context, state.error);

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
                    const TextCustom(
                       text: LanguageJameet.hello,
                       letterSpacing: 1.5, 
                       fontWeight: FontWeight.w500, 
                       fontSize: 28, 
                       color: ColorsJameet.secundary
                    ),
                          
                    const SizedBox(height: 10.0),
                    const TextCustom(
                       text: LanguageJameet.creat_a_new_account,
                       fontSize: 17,
                       letterSpacing: 1.0,
                    ),
                          
                    const SizedBox(height: 40.0),
                    TextFieldJameet(
                      controller: fullNameController,
                      hintText: LanguageJameet.full_name,
                      validator: RequiredValidator(errorText: LanguageJameet.name_required),
                    ),
                  
                    const SizedBox(height: 40.0),
                    TextFieldJameet(
                      controller: userController,
                      hintText: LanguageJameet.username,
                      validator: RequiredValidator(errorText: LanguageJameet.username_required),
                    ),
                    
                    const SizedBox(height: 40.0),
                    TextFieldJameet(
                      controller: emailController,
                      hintText: LanguageJameet.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: validatedEmail,
                    ),
                    
                    const SizedBox(height: 40.0),
                    TextFieldJameet(
                      controller: passwordController,
                      hintText: LanguageJameet.password,
                      isPassword: true,
                      validator: passwordValidator,
                    ),
                  
                    const SizedBox(height: 60.0),
                    const TextCustom(
                       text: LanguageJameet.agree_to_term,
                       fontSize: 15,
                       maxLines: 2,
                    ),
                          
                    const SizedBox(height: 20.0),
                    BtnJameet(
                      text: LanguageJameet.register,
                      width: size.width,
                      onPressed: (){
                        if( _keyForm.currentState!.validate() ){
                          userBloc.add( 
                            OnRegisterUserEvent(
                              fullNameController.text.trim(), 
                              userController.text.trim(), 
                              emailController.text.trim(),
                              passwordController.text.trim()
                            )
                          );
                        }
                      }
                      
                    ),
                  
                    
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