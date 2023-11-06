import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jameet_social_builder/data/env/env.dart';
import 'package:jameet_social_builder/data/storage/secure_storage.dart';
import 'package:jameet_social_builder/domain/models/response/default_response.dart';
import 'package:jameet_social_builder/domain/models/response/response_list_stories.dart';
import 'package:jameet_social_builder/domain/models/response/response_stories.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class StoryServices {


  Future<DefaultResponse> addNewStory(String image) async {

    final token = await secureStorage.readToken();

    var request = http.MultipartRequest('POST', Uri.parse('${Environment.urlApi}/story/create-new-story'))
      ..headers['Accept'] = 'application/json'
      ..headers['jmt-token'] = token!
      ..headers['server-key'] = LanguageJameet.serverKey;
      request.files.add( await http.MultipartFile.fromPath('imageStory', image));


    final response = await request.send();
    var data = await http.Response.fromStream(response);

    return DefaultResponse.fromJson( jsonDecode(data.body) ); 
  }


  Future<List<StoryHome>> getAllStoriesHome() async {

    final token = await secureStorage.readToken();

    final resp = await http.get(Uri.parse('${Environment.urlApi}/story/get-all-stories-home'),
      headers: { 'Accept': 'application/json', 'jmt-token': token! , 'server-key': LanguageJameet.serverKey }
    );

    return ResponseStoriesHome.fromJson(jsonDecode(resp.body)).stories;
  }

  
  Future<List<ListStory>> getStoryByUSer(String uidStory) async {

    final token = await secureStorage.readToken();

    final resp = await http.get(Uri.parse('${Environment.urlApi}/story/get-story-by-user/'+ uidStory),
      headers: { 'Accept': 'application/json', 'jmt-token': token! , 'server-key': LanguageJameet.serverKey }
    );
    return ResponseListStories.fromJson(jsonDecode(resp.body)).listStories;
  }








  

}

final storyServices = StoryServices();