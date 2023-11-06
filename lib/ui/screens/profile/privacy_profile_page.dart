//https://fonts.google.com/icons?selected=Material+Icons:question_answer:&icon.platform=flutter&icon.query=setting
//https://stackoverflow.com/questions/73027350/flutter-how-to-wrap-text-inside-a-given-width
//https://codingwithrashid.com/how-to-justify-text-in-flutter/#:~:text=You%20can%20justify%20text%20in,Thats%20it.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameet_social_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_builder/ui/helpers/helpers.dart';
//import 'package:jameet_social_builder/ui/screens/profile/widgets/item_profile.dart';
import 'package:jameet_social_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class PrivacyProgilePage extends StatelessWidget {

  const PrivacyProgilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {

        if( state is LoadingChangeAccount ){
          modalLoading(context, LanguageJameet.changing_privacy);
        }else if( state is FailureUserState ){
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }else if ( state is SuccessUserState ){
          Navigator.pop(context);
          modalSuccess(context, LanguageJameet.privacy_changed, onPressed: () => Navigator.pop(context));
        }

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: LanguageJameet.privacy, fontSize: 19, fontWeight: FontWeight.w500 ),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black)
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            physics: const BouncingScrollPhysics(),
            children: [
              
              const TextCustom(text: LanguageJameet.account_privacy, fontSize: 16, fontWeight: FontWeight.w500),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  child: BlocBuilder<UserBloc, UserState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (_, state) => Row(
                      children: [
                        const Icon(Icons.lock_outlined),
                        const SizedBox(width: 10),
                        const TextCustom(text: LanguageJameet.private_account, fontSize: 17 ),
                        const Spacer(),
                        ( state.user != null && state.user!.isPrivate == 1)
                          ? const Icon(Icons.radio_button_checked_rounded, color: ColorsJameet.primary)
                          : const Icon(Icons.radio_button_unchecked_rounded),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  onTap: () => modalPrivacyProfile(context),
                ),
              ),

              const SizedBox(height: 5.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Expanded(
                    child: Text(
                      LanguageJameet.public_description,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Expanded(
                    child: Text(
                      LanguageJameet.private_description,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
             /*
              const Divider(),
              const SizedBox(height: 10.0),
              */
            ],
          ),
        ),
      ),
    );
  }
}