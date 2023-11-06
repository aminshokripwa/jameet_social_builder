import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:jameet_social_builder/data/env/env.dart';
import 'package:jameet_social_builder/domain/blocs/blocs.dart';
import 'package:jameet_social_builder/domain/blocs/post/post_bloc.dart';
import 'package:jameet_social_builder/ui/helpers/helpers.dart';
import 'package:jameet_social_builder/ui/screens/home/home_page.dart';
import 'package:jameet_social_builder/ui/themes/colors_jameet.dart';
import 'package:jameet_social_builder/ui/widgets/widgets.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class AddPostPage extends StatefulWidget {

  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}


class _AddPostPageState extends State<AddPostPage> {

  late TextEditingController _descriptionController;
  final _keyForm = GlobalKey<FormState>();
  late List<AssetEntity> _mediaList = [];
  late File fileImage;

  @override
  void initState() {
    _assetImagesDevice();
    super.initState();
    _descriptionController = TextEditingController();

  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }


  _assetImagesDevice() async {

    var result = await PhotoManager.requestPermissionExtend();
    if( result.isAuth ){

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true);
      if(albums.isNotEmpty){
        List<AssetEntity> photos = await albums[0].getAssetListPaged(page: 0, size: 50);
        setState(() => _mediaList = photos);
      }

    }else{
      PhotoManager.openSetting();
    }
  }

 
  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context).state;
    final postBloc = BlocProvider.of<PostBloc>(context);
    final size = MediaQuery.of(context).size;

    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if( state is LoadingPost ){
          modalLoading(context, LanguageJameet.creat_posts);
        }else if( state is FailurePost ){
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }else if( state is SuccessPost ){
          Navigator.pop(context);
          modalSuccess(context, LanguageJameet.post_created,
            onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const HomePage()), (_) => false) 
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _appBarPost(),
          
                  const SizedBox(height: 10.0),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 120,
                                    width: size.width * .125,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(Environment.baseUrl + userBloc.user!.image),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 100,
                                width: size.width * .78,
                                color: Colors.white,
                                child: TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 10.0, top: 10.0),
                                    border: InputBorder.none,
                                    hintText: LanguageJameet.add_a_comment,
                                    hintStyle: GoogleFonts.roboto(fontSize: 18)
                                  ),
                                  validator: RequiredValidator(errorText: LanguageJameet.the_field_is_required),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 65.0, right: 10.0),
                            child: BlocBuilder<PostBloc, PostState>(
                              buildWhen: (previous, current) => previous != current,
                              builder: (_, state) 
                              => ( state.imageFileSelected != null ) 
                              ?   ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.imageFileSelected!.length,
                                  itemBuilder: (_, i) 
                                    => Stack(
                                        children: [
                                          Container(
                                            height: 150,
                                            width: size.width * .95,
                                            margin: const EdgeInsets.only(bottom: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage( state.imageFileSelected![i] )
                                              )
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: InkWell(
                                              onTap: () => postBloc.add( OnClearSelectedImageEvent(i) ),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.black38,
                                                child: Icon(Icons.close_rounded, color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                              )
                              : const SizedBox()
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 5.0),
                  // Container(
                  //   padding: const EdgeInsets.all(5),
                  //   height: 90,
                  //   width: size.width,
                  //   // color: Colors.amber,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: _mediaList.length,
                  //     itemBuilder: (context, i) {
                  //       return InkWell(
                  //         onTap: () async {
                  //           fileImage = (await _mediaList[i].file)!; 
                  //           postBloc.add( OnSelectedImageEvent(fileImage));
                  //         },
                  //         child: FutureBuilder(
                  //           future: _mediaList[i].thumbDataWithSize(200, 200),
                  //           builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
                  //             if( snapshot.connectionState == ConnectionState.done ){
                  //               return Container(
                  //                 height: 85,
                  //                 width: 100,
                  //                 margin: const EdgeInsets.only(right: 5.0),
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                   image: DecorationImage(
                  //                     fit: BoxFit.cover,
                  //                     image: MemoryImage(snapshot.data!)
                  //                   )
                  //                 ),
                  //               );
                  //             }
                  //             return const SizedBox();
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
          
                  const SizedBox(height: 5.0),
                  const Divider(),
                  InkWell(
                    onTap: () => modalPrivacyPost(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          BlocBuilder<PostBloc, PostState>(
                            builder: (_, state){
                              if(state.privacyPost == 1) return const Icon(Icons.public_rounded);
                              if(state.privacyPost == 2) return const Icon(Icons.group_outlined);
                              if(state.privacyPost == 3) return const Icon(Icons.lock_outline_rounded);
                              return const SizedBox();
                            }
                          ),
                          const SizedBox(width: 5.0),
                          BlocBuilder<PostBloc, PostState>(
                            builder: (_, state){
                              if(state.privacyPost == 1) return const TextCustom(text: LanguageJameet.everyone_can_comment, fontSize: 16);
                              if(state.privacyPost == 2) return const TextCustom(text: LanguageJameet.only_fllowers, fontSize: 16);
                              if(state.privacyPost == 3) return const TextCustom(text: LanguageJameet.nobody, fontSize: 16);
                              return const SizedBox();
                            }
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
          
                  const SizedBox(height: 5.0),
                  SizedBox(
                    height: 40,
                    width: size.width,
                    child: Row(
                      children: [
                        IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            AppPermission().permissionAccessGalleryMultiplesImagesNewPost(
                              await Permission.storage.request(), 
                              context
                            );
                          },
                          icon: SvgPicture.asset('assets/svg/gallery.svg' )
                        ),
                        IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            AppPermission().permissionAccessGalleryOrCameraForNewPost(
                              await Permission.camera.request(), 
                              context, 
                              ImageSource.camera
                            );
                          },
                          icon: SvgPicture.asset('assets/svg/camera.svg' )
                        ),
                        /*
                        IconButton(
                          splashRadius: 20,
                          onPressed: (){},
                          icon: SvgPicture.asset('assets/svg/gif.svg' )
                        ),
                        IconButton(
                          splashRadius: 20,
                          onPressed: (){},
                          icon: SvgPicture.asset('assets/svg/location.svg' )
                        ),
                        */
                      ],
                    ),
                  ),
          
                ],
              ),
            ),
          )
        ),
      ),
    );
  }


  Widget _appBarPost(){
    final postBloc = BlocProvider.of<PostBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          splashRadius: 20,
          onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const HomePage()), (_) => false), 
          icon: const Icon(Icons.close_rounded)
        ),
        BlocBuilder<PostBloc, PostState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) => TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              backgroundColor: ColorsJameet.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
            ),
            onPressed: (){
              
              if(_keyForm.currentState!.validate()){
                if(state.imageFileSelected != null){
                  postBloc.add( OnAddNewPostEvent(_descriptionController.text.trim()) );
                } else {
                  modalWarning(context, LanguageJameet.no_media_selected);
                }
              }
              
            },
            child: const TextCustom(
              text: 'Post',
              color: Colors.white, 
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              letterSpacing: .7,
            )
          ),
        )
      ],
    );
  }


}
