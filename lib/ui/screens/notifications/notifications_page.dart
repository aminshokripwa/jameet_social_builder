import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameet_social_network_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_network_builder/domain/models/response/response_notifications.dart';
import 'package:jameet_social_network_builder/domain/services/notifications_services.dart';
import 'package:jameet_social_network_builder/ui/helpers/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jameet_social_network_builder/data/env/env.dart';
import 'package:jameet_social_network_builder/ui/screens/home/home_page.dart';
import 'package:jameet_social_network_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_network_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_network_builder/localization_helper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if( state is LoadingUserState ){
          modalLoading(context, LanguageJameet.loading);
        }else if( state is FailureUserState ){
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }else if ( state is SuccessUserState ){
          Navigator.pop(context);
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: LanguageJameet.activity, fontWeight: FontWeight.w500, letterSpacing: .9, fontSize: 19 ),
          elevation: 0,
          leading: IconButton(
            splashRadius: 20,
            onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const HomePage()), (_) => false),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black)
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<List<Notificationsdb>>(
            future: notificationServices.getNotificationsByUser(),
            builder: (context, snapshot) {
              return !snapshot.hasData
              ? Column(
                  children: const[
                    ShimmerJameet(),
                    SizedBox(height: 10.0),
                    ShimmerJameet(),
                    SizedBox(height: 10.0),
                    ShimmerJameet(),
                  ],
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(Environment.baseUrl + snapshot.data![i].avatar),
                              ),
                              const SizedBox(width: 5.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(text: snapshot.data![i].follower, fontWeight: FontWeight.w500, fontSize: 16),
                                      TextCustom(text: timeago.format(snapshot.data![i].createdAt, locale: 'en_short'), fontSize: 14, color: Colors.grey),
                                    ],
                                  ),
                                  const SizedBox(width: 5.0),
                                  if( snapshot.data![i].typeNotification == '1' )
                                    const TextCustom(text: LanguageJameet.send_you_request, fontSize: 16),
                                  if( snapshot.data![i].typeNotification == '3' )
                                    const TextCustom(text: LanguageJameet.start_following_you, fontSize: 16),
                                  if( snapshot.data![i].typeNotification == '2' )
                                    Row(
                                      children: const [
                                        TextCustom(text:LanguageJameet.he, fontSize: 16),
                                        TextCustom(text:LanguageJameet.liked, fontSize: 16, fontWeight: FontWeight.w500 ),
                                        TextCustom(text:LanguageJameet.your_post, fontSize: 16),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                          
                          if( snapshot.data![i].typeNotification == '1' )
                            Card(
                              color: ColorsJameet.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                              elevation: 0,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50.0),
                                splashColor: Colors.white54,
                                onTap: (){
                                  userBloc.add(
                                    OnAcceptFollowerRequestEvent(snapshot.data![i].followersUid, snapshot.data![i].uidNotification)
                                  );
                                },
                                child: const Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  child: TextCustom(text: LanguageJameet.accept, fontSize: 16, color: Colors.white),
                                )
                              ),
                            ),
                        ],
                      ),
                    );
                  },
              );
            },  
          )        
        ),
      ),
    );
  }
}

