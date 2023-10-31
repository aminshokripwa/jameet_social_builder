import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameet_social_network_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_network_builder/domain/blocs/post/post_bloc.dart';
import 'package:jameet_social_network_builder/ui/screens/intro/checking_login_page.dart';
import 'package:jameet_social_network_builder/localization_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark )
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add( OnCheckingLoginEvent())),
        BlocProvider(create: (_) => UserBloc()),
        BlocProvider(create: (_) => PostBloc()),
        BlocProvider(create: (_) => StoryBloc()),
        BlocProvider(create: (_) => ChatBloc()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: LanguageJameet.project_name,
        home: CheckingLoginPage(),
      ),
    );
  }
}