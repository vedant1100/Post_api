import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

class uploadImage extends StatefulWidget {
  const uploadImage({super.key});

  @override
  State<uploadImage> createState() => _uploadImageState();
}

class _uploadImageState extends State<uploadImage> {
  File? image;
  // final _picker=ImagePicker();
  bool showSpinner = false;
  String? selectedValue;

  List<String> imageType = ['Gallery', 'Camera'];

  Future postImage(String newValue) async {
    XFile? pickedFile;
    if (newValue == 'Gallery') {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else if (newValue == 'Camera') {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    }

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    }
    return;
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner=true;
    });

    try{
      var stream=http.ByteStream(image!.openRead());
      stream.cast();

      var length=await image!.length();
      var uri=Uri.parse('https://fakestoreapi.com/products');
      var request=http.MultipartRequest('POST', uri);
      request.fields['title']='Static Title';
      var MultiPort= http.MultipartFile('image', stream, length);
      request.files.add(MultiPort);
      var response=await request.send();

      if(response.statusCode==200){
        setState(() {
          showSpinner=false;
        });
        print('Image Uploaded');
      }
      else{
        setState(() {
          showSpinner=false;
        });
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Upload Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                child: image == null
                    ? Center(
                        child: DropdownButton<String>(
                            value: selectedValue,
                            hint: const Text('Pick Image'),
                            items: imageType.map((String type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedValue = newValue;
                                });
                              }
                              postImage(newValue ?? " ");
                            }),
                      )
                    : Center(
                        child: Image.file(image!,
                            height: 100, width: 100, fit: BoxFit.cover),
                      )),

            const SizedBox(height: 200),
            GestureDetector(
              onTap: (){
                uploadImage();
              },
              child: Container(
                height: 50, color: Colors.green,
                child: const Text('Upload'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
