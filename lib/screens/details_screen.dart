import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path/path.dart' as p;
import 'package:xicom_test/Services/api_calls.dart';
import 'package:xicom_test/Services/api_constants.dart';
import 'package:xicom_test/input_mixin.dart';
import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:xicom_test/screens/image_listing.dart';

class DetailsScreen extends StatefulWidget {
  final String url;
  const DetailsScreen({super.key, required this.url});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with InputValidationMixin {
  final formGlobalKey = GlobalKey<FormState>();
  var dio = Dio();
  ApiCall apicall = new ApiCall();

  late TextEditingController f_name_controller;
  late TextEditingController l_name_controller;
  late TextEditingController email_controller;
  late TextEditingController phone_controller;

  Future<File> _download(String url) async {
    final response = await http.get(Uri.parse(url));

    // Get the image name
    final imageName = p.basename(url);
    // Get the document directory path
    final appDir = await getApplicationDocumentsDirectory();

    // This is the saved image path
    // You can use it to display the saved image later
    final localPath = p.join(appDir.path, imageName);

    // Downloading
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes);

    return imageFile;
  }

  Future<void> _submit(String fName, String lName, String email, String phone,
      String image) async {
    var file = await _download(image);
    print("imge kya ${file.absolute.path}");
    if (formGlobalKey.currentState!.validate()) {
      formGlobalKey.currentState!.save();
      try {
        var formData = FormData.fromMap({
          "user_image": await MultipartFile.fromFile(file.path,
              filename: p.basename(file.path)),
          "first_name": fName,
          "last_name": lName,
          "email": email,
          "phone": phone,
        });

        print(
            "kkfk${MultipartFile.fromFile(file.path, filename: p.basename(file.path))}");

        print("lflfl${formData.fields}");
        print("yuuifi${formData.files}");

        var res = await apicall.postApi(ApiConstants.SAVE_DATA, formData);

        print("sttta${res.statusCode}");

        if (res.statusCode == 200) {
          Toast.show("User Data saved successfully",
              duration: Toast.lengthShort, gravity: Toast.bottom);
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(builder)=> ImageListingPage()),(route) => false,);
        } else {
          Toast.show("Something went wrong",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        }
      } catch (e) {
        print("savedata error$e");
      }

      // use the email provided here
    }
  }

  @override
  void initState() {
    f_name_controller = TextEditingController();
    l_name_controller = TextEditingController();
    email_controller = TextEditingController();
    phone_controller = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    f_name_controller.dispose();
    l_name_controller.dispose();
    email_controller.dispose();
    phone_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Details Screen")),
      body: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Column(children: [
            Container(
              height: size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(widget.url)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: size.width * 0.2, child: Text("First Name")),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                      child: TextFormField(
                          controller: f_name_controller,
                          validator: (f_name) {
                            if (isNameValid(f_name.toString()))
                              return null;
                            else
                              return 'Please enter your first name';
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: size.width * 0.2, child: Text("Last Name")),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                      child: TextFormField(
                          controller: l_name_controller,
                          validator: (l_name) {
                            if (isNameValid(l_name.toString()))
                              return null;
                            else
                              return 'Please enter your last name';
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: size.width * 0.2, child: Text("Email")),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                      child: TextFormField(
                          controller: email_controller,
                          validator: (email) {
                            if (isEmailValid(email.toString()))
                              return null;
                            else
                              return 'Enter a valid email address';
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: size.width * 0.2, child: Text("Phone")),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                      child: TextFormField(
                          inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                          controller: phone_controller,
                          validator: (phone) {
                            if (validateMobile(phone.toString()))
                              return null;
                            else
                              return 'Enter a valid phone number';
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: ()async {
                    var file = _download(widget.url.toString());

                  await  _submit(
                        f_name_controller.text.toString(),
                        l_name_controller.text.toString(),
                        email_controller.text.toString(),
                        phone_controller.text.toString(),
                        widget.url);

                       
                  },
                  child: const Text('Submit'),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
