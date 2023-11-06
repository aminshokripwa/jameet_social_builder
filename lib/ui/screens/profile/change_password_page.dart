import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:jameet_social_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_builder/ui/helpers/helpers.dart';
import 'package:jameet_social_builder/ui/screens/profile/widgets/text_form_profile.dart';
import 'package:jameet_social_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class ChangePasswordPage extends StatefulWidget {

  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _newPasswordAgainController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _newPasswordAgainController = TextEditingController();

  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordAgainController.dispose();

    super.dispose();
  }

  void clear(){
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _newPasswordAgainController.clear();
  }


  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {

        if( state is LoadingUserState ){

          modalLoading(context, LanguageJameet.update_password);

        }else if( state is FailureUserState ){

          Navigator.pop(context);
          errorMessageSnack(context, state.error);

        }else if( state is SuccessUserState ){

          Navigator.pop(context);
          modalSuccess(context, LanguageJameet.password_changed, onPressed: (){
            clear();
            Navigator.pop(context);
          });

        }

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: LanguageJameet.password, fontSize: 19),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: (){
                if( _keyForm.currentState!.validate() ){
    
                  userBloc.add( OnChangePasswordEvent(
                    _currentPasswordController.text.trim(), 
                    _newPasswordAgainController.text.trim()
                  ));
    
                }
              }, 
              child: const TextCustom(text: LanguageJameet.save, fontSize: 15, color: ColorsJameet.primary)
            )
          ],
        ),
        body: Form(
          key: _keyForm,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
        
                    TextFormProfile(
                      controller: _currentPasswordController, 
                      labelText: LanguageJameet.current_password,
                      validator: MultiValidator([
                        MinLengthValidator(8, errorText: LanguageJameet.minmum_8_charecters),
                        RequiredValidator(errorText: LanguageJameet.this_field_not_empty)
                      ]),
                    ),
        
                    const SizedBox(height: 20.0),
                    TextFormProfile(
                      controller: _newPasswordController, 
                      labelText: LanguageJameet.new_password,
                      validator: MultiValidator([
                        MinLengthValidator(8, errorText: LanguageJameet.minmum_8_charecters),
                        RequiredValidator(errorText: LanguageJameet.this_field_not_empty)
                      ]),
                    ),
        
                    const SizedBox(height: 20.0),
                    TextFormProfile(
                      controller: _newPasswordAgainController, 
                      labelText: LanguageJameet.repeat_password,
                      validator: MultiValidator([
                        MinLengthValidator(8, errorText: LanguageJameet.minmum_8_charecters),
                        RequiredValidator(errorText: LanguageJameet.this_field_not_empty)
                      ]),
                    ),
        
                  ],
                ),
              ),
            ) 
          ),
        )
      ),
    );
  }
}