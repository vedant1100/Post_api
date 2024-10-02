import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_register_api/constants.dart';

class UploadText extends StatefulWidget {
  const UploadText({super.key});

  @override
  State<UploadText> createState() => _UploadTextState();
}

class _UploadTextState extends State<UploadText> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  var affectedRows;

  Future addData(
      String id, String first_name, String last_name, String email) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/Request'),
      headers: <String, String>{
        "Content-type": "application/json",
      },
      body: jsonEncode({
        'id': _id.text,
        'first_name': _firstName.text,
        'last_name': _lastName.text,
        'email': _email.text,
      }),
    );
    print('res: ${response.statusCode}');
    if (response.statusCode == 200) {
      affectedRows = jsonDecode(response.body)["affectedRows"];
      print(affectedRows);
      return affectedRows;
    } else {
      throw Exception('error occured');
    }

    // if (response.statusCode == 200) {
    //   var data = jsonDecode(response.body);
    //   print('Account Created Successfully');
    //   return _futureResult!.fromJson(data);
    // } else {
    //   throw Exception("Failed to create account");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign up API'),
      ),
      body: Container(
        padding: const EdgeInsets.all(18),
        child: affectedRows == null
            ? Column(
                children: [
                  TextFormField(
                    controller: _id,
                    decoration: const InputDecoration(hintText: 'id'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _firstName,
                    decoration: const InputDecoration(hintText: 'first_name'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastName,
                    decoration: const InputDecoration(hintText: 'last_name'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(hintText: 'email'),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: FilledButton(
                      onPressed: () async {
                        await addData(_id.text, _firstName.text, _lastName.text,
                                _email.text)
                            .then((_) => setState(() {}));
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Text(
                affectedRows.toString(),
                style: const TextStyle(fontSize: 30),
              ),
      ),
    );
  }
}
