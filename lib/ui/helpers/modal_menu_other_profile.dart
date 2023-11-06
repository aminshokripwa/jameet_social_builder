import 'package:flutter/material.dart';
import 'package:jameet_social_builder/ui/helpers/modal_profile_settings.dart';
import 'package:jameet_social_builder/localization_helper.dart';

modalMenuOtherProfile(BuildContext context, Size size) {

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
    backgroundColor: Colors.white,
    builder: (context) => Container(
      height: size.height * .48,
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
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50.0)
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            Item(
              icon: Icons.report,
              text: LanguageJameet.report,
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.block,
              text: LanguageJameet.block,
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.remove_circle_outline_rounded,
              text: LanguageJameet.restrict,
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.visibility_off_outlined,
              text: LanguageJameet.hide_your_story,
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.copy_all_rounded,
              text: LanguageJameet.copy_profile_url,
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.send,
              text: LanguageJameet.send_message,
              size: size,
              onPressed: (){},
            ),
            Item(
              icon: Icons.share_outlined,
              text: LanguageJameet.share_this_profile,
              size: size,
              onPressed: (){},
            ),
          ],
        ),
      ),
    ),
  );

}
