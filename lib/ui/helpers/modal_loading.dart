import 'package:flutter/material.dart';
import 'package:jameet_social_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_builder/localization_helper.dart';

void modalLoading(BuildContext context, String text){

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white54, 
    builder: (context) 
      => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        content: SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  TextCustom(text: LanguageJameet.project_first, color: ColorsJameet.primary, fontWeight: FontWeight.w500 ),
                  TextCustom(text: LanguageJameet.project_second, fontWeight: FontWeight.w500),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              Row(
                children:[
                  const CircularProgressIndicator( color: ColorsJameet.primary),
                  const SizedBox(width: 15.0),
                  TextCustom(text: text)
                ],
              ),
            ],
          ),
        ),
      ),
  );

}