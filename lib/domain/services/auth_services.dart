import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jameet_social_builder/data/storage/secure_storage.dart';
import 'package:jameet_social_builder/domain/models/response/response_login.dart';
import 'package:jameet_social_builder/data/env/env.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class AuthServices {

  
  Future<ResponseLogin> login(String email, String password) async {

    final resp = await http.post(Uri.parse('${Environment.urlApi}/auth-login'),
      headers: { 'Accept': 'application/json' , 'server-key': LanguageJameet.serverKey},
      body: {
        'email' : email,
        'password': password
      }
    );
    return ResponseLogin.fromJson( jsonDecode( resp.body ));
  }


  Future<ResponseLogin> renewLogin() async {

    final token = await secureStorage.readToken();

    final resp = await http.get(Uri.parse('${Environment.urlApi}/auth/renew-login'),
      headers: { 'Accept': 'application/json', 'jmt-token' : token! , 'server-key': LanguageJameet.serverKey}
    );
    return ResponseLogin.fromJson( jsonDecode( resp.body ));
  }



}

final authServices = AuthServices();