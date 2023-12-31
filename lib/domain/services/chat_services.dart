import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jameet_social_builder/data/env/env.dart';
import 'package:jameet_social_builder/data/storage/secure_storage.dart';
import 'package:jameet_social_builder/domain/models/response/response_list_chat.dart';
import 'package:jameet_social_builder/domain/models/response/response_list_messages.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class ChatServices {


  Future<List<ListChat>> getListChatByUser() async {

    final token = await secureStorage.readToken();

    final resp = await http.get(Uri.parse('${Environment.urlApi}/chat/get-list-chat-by-user'),
      headers: { 'Accept': 'application/json', 'jmt-token': token! , 'server-key': LanguageJameet.serverKey }
    );  

    return ResponseListChat.fromJson(jsonDecode(resp.body)).listChat;
  }


  Future<List<ListMessage>> listMessagesByUser(String uid) async {

    final token = await secureStorage.readToken();

    final resp = await http.get(Uri.parse('${Environment.urlApi}/chat/get-all-message-by-user/'+ uid),
      headers: { 'Accept': 'application/json', 'jmt-token' : token! , 'server-key': LanguageJameet.serverKey }
    );

    return ResponseListMessages.fromJson(jsonDecode(resp.body)).listMessage;
  }







}

final chatServices = ChatServices();