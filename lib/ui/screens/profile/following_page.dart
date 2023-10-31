import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameet_social_network_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_network_builder/data/env/env.dart';
import 'package:jameet_social_network_builder/domain/models/response/response_followings.dart';
import 'package:jameet_social_network_builder/domain/services/user_services.dart';
import 'package:jameet_social_network_builder/ui/helpers/helpers.dart';
import 'package:jameet_social_network_builder/ui/screens/profile/profile_another_user_page.dart';
import 'package:jameet_social_network_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_network_builder/localization_helper.dart';

class FollowingPage extends StatefulWidget {

  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {

  @override
  Widget build(BuildContext context) {

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if(state is LoadingFollowingUser){
          modalLoading(context, LanguageJameet.loading);
        }else if( state is FailureUserState ){
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }else if( state is SuccessFollowingUser ){
          Navigator.pop(context);
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: LanguageJameet.friends, letterSpacing: .8, fontSize: 19),
          elevation: 0,
          leading: IconButton(
            splashRadius: 20,
            onPressed: () => Navigator.pop(context), 
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,)
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<List<Following>>(
            future: userService.getAllFollowing(),
            builder: (context, snapshot) {
              return !snapshot.hasData
              ? Column(
                  children: const [
                    ShimmerJameet(),
                    SizedBox(height: 10.0),
                    ShimmerJameet(),
                    SizedBox(height: 10.0),
                    ShimmerJameet(),
                  ],
                )
              : _ListFollowings(follow: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

class _ListFollowings extends StatelessWidget {

  final List<Following> follow;

  const _ListFollowings({ Key? key, required this.follow }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: follow.length,
      itemBuilder: (context, i){
        return InkWell(
          borderRadius: BorderRadius.circular(10.0),
          splashColor: Colors.grey[300],
          onTap: () => Navigator.push(context, routeSlide(page: ProfileAnotherUserPage(idUser: follow[i].uidUser))),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0)
            ),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.amber,
                      backgroundImage: NetworkImage(Environment.baseUrl + follow[i].avatar),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextCustom(text: follow[i].username, fontSize: 16 ),
                        TextCustom(text: follow[i].fullname, color: Colors.grey, fontSize: 15 )
                      ],
                    ),
                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(50.0)),
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    splashColor: Colors.blue[50],
                    onTap: () => userBloc.add( OnDeletefollowingEvent(follow[i].uidUser) ),
                    child: const Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 17.0, vertical: 6.0),
                      child: TextCustom(text: LanguageJameet.following, fontSize: 16),
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}





