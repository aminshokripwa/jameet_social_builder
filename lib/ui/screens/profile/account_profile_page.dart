import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:jameet_social_network_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_network_builder/ui/helpers/helpers.dart';
import 'package:jameet_social_network_builder/ui/screens/profile/widgets/text_form_profile.dart';
import 'package:jameet_social_network_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_network_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_network_builder/localization_helper.dart';

class AccountProfilePage extends StatefulWidget {
  const AccountProfilePage({Key? key}) : super(key: key);

  @override
  State<AccountProfilePage> createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {

  late TextEditingController _userController;
  late TextEditingController _descriptionController;
  late TextEditingController _emailController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  final _keyForm = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    final userBloc = BlocProvider.of<UserBloc>(context).state;

    _userController = TextEditingController(text: userBloc.user!.username);
    _descriptionController = TextEditingController(text: userBloc.user!.description);
    _emailController = TextEditingController(text: userBloc.user!.email);
    _fullNameController = TextEditingController(text: userBloc.user!.fullname);
    _phoneController = TextEditingController(text: userBloc.user!.phone);

  }

  @override
  void dispose() {
    _userController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        
        if( state is LoadingEditUserState ){

          modalLoading(context, LanguageJameet.updating_data);

        }
        if ( state is FailureUserState ){

          Navigator.pop(context);
          errorMessageSnack(context, state.error);

        }
        if( state is SuccessUserState ){

          Navigator.pop(context);
          modalSuccess(context, LanguageJameet.updated, onPressed: () => Navigator.pop(context));

        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: LanguageJameet.update_profile, fontSize: 19),
          elevation: 0,
          leading: IconButton(
            highlightColor: Colors.transparent,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: (){
                if( _keyForm.currentState!.validate() ){
                  userBloc.add( OnUpdateProfileEvent(
                    _userController.text.trim(), 
                    _descriptionController.text.trim(), 
                    _fullNameController.text.trim(), 
                    _phoneController.text.trim()
                  ));
                }
              }, 
              child: const TextCustom(text: LanguageJameet.save, color: ColorsJameet.primary, fontSize: 14)
            )
          ],
        ),
        body: Form(
          key: _keyForm,
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
          
                const SizedBox(height: 20.0),
                TextFormProfile(
                  controller: _userController,
                  labelText: 'User',
                  validator: MultiValidator([
                    RequiredValidator(errorText: LanguageJameet.username_required),
                    MinLengthValidator(3, errorText: LanguageJameet.minmum_3_charecters)
                  ])
                ),
          
                const SizedBox(height: 10.0),
                TextFormProfile(
                  controller: _descriptionController,
                  labelText: LanguageJameet.description,
                  maxLines: 3
                ),
                const SizedBox(height: 20.0),
                TextFormProfile(
                  controller: _emailController,
                  isReadOnly: true,
                  labelText: LanguageJameet.email,
                ),
          
                const SizedBox(height: 20.0),
                TextFormProfile(
                  controller: _fullNameController,
                  labelText: LanguageJameet.full_name,
                  validator: MultiValidator([
                    RequiredValidator(errorText: LanguageJameet.name_required),
                    MinLengthValidator(3, errorText: LanguageJameet.minmum_3_charecters)
                  ])
                ),
          
                const SizedBox(height: 20.0),
                TextFormProfile(
                  controller: _phoneController,
                  labelText: LanguageJameet.telephone,
                  keyboardType: TextInputType.number,
                ),
          
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}