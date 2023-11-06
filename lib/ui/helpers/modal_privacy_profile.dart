import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameet_social_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_builder/localization_helper.dart';

modalPrivacyProfile(BuildContext context) {

  final size = MediaQuery.of(context).size;
  final userBloc = BlocProvider.of<UserBloc>(context);

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
    backgroundColor: Colors.white,
    barrierColor: Colors.black26,
    builder: (context) => Container(
      height: size.height * .41,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(50.0)
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Center(
              child: BlocBuilder<UserBloc, UserState>(
                buildWhen: (previous, current) => previous != current,
                builder: (_, state) 
                  => TextCustom(text: ( state.user != null && state.user!.isPrivate == 0)
                    ? LanguageJameet.change_account_to_private
                    : LanguageJameet.change_account_to_public,
                    fontWeight: FontWeight.w500
                  )
              )
            ),
            /*
            const SizedBox(height: 5.0),
            const Divider(),
            */
            const SizedBox(height: 10.0),
            const Divider(),
            const SizedBox(height: 10.0),

            BlocBuilder<UserBloc, UserState>(
              buildWhen: (previous, current) => previous != current,
              builder: (_, state) => BtnJameet(
                text: ( state.user != null && state.user!.isPrivate == 0) ? LanguageJameet.change_to_private: LanguageJameet.switch_to_public,
                width: size.width,
                fontSize: 17,
                backgroundColor: ColorsJameet.primary,
                onPressed: (){
                  Navigator.pop(context);
                  userBloc.add( OnChangeAccountToPrivacy() );
                },
              ),
            )

          ],
        ),
      ),
    ),
  );

}
