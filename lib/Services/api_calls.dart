import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class ApiCall {
  var dio=Dio();
  Future<Response> postApi(String url, dynamic body) async {
    var response;

    try{
  response = await dio.post(url,
            data: body, options: Options(contentType: "multipart/form-data"));

    print("PostApi--${url}, request:-$body ==> ${response.data}");

  
    }catch(e){
      print("error in fetching list $e");
    }
    return response;
   
  }


}
