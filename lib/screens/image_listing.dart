import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xicom_test/Services/api_calls.dart';
import 'package:xicom_test/Services/api_constants.dart';
import 'package:xicom_test/screens/details_screen.dart';

import '../model/image.dart';

class ImageListingPage extends StatefulWidget {
  const ImageListingPage({super.key});

  @override
  State<ImageListingPage> createState() => _ImageListingPageState();
}

class _ImageListingPageState extends State<ImageListingPage> {
  int offset = 0;
  var isLoading = false;
  List<dynamic> imageList = [];
  var items = [];

  @override
  void initState() {
    getImages(1);
    super.initState();
  }

  getImages(int offset) async {
    setState(() {
      isLoading = true;
    });

    if (offset > 1) {
      imageList.removeLast();
    }

    var formData = FormData.fromMap(
        {"user_id": "108", "offset": "$offset", "type": "popular"});
    ApiCall apicall = new ApiCall();
    var res = await apicall.postApi(ApiConstants.FETCH_IMAGE, formData);
    print("res${res.data}");
    var decode = jsonDecode(res.data);
    final rawList = await decode['images'] as List;

    if (res.statusCode == 200) {
      if (imageList.isNotEmpty) {
        imageList.addAll(rawList.map((e) => Img.fromJson(e)).toList());
      } else {
        imageList = rawList.map((e) => Img.fromJson(e)).toList();
      }
    }

    print("imageLisdt$imageList");

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("XICOM TEST")),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: imageList.length,
              itemBuilder: (ctx, index) => index == imageList.length - 1
                  ? Container(
                      width: size.width * 0.2,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      child: ElevatedButton(
                          onPressed: () => getImages(offset++),
                          child: Text("Click here to load more...")),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailsScreen(url: imageList[index].xt_image),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: size.width,
                          height: size.height * 0.3,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 5,
                                  spreadRadius: 5,
                                  offset: Offset(
                                    5,
                                    0,
                                  )),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(imageList[index].xt_image)),
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }
}
