import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:myapp/constant/const.dart';
import 'package:myapp/screen/editpage.dart';
import 'login.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:myapp/models/motivasi_model.dart';

class MainScreens extends StatefulWidget {
  final String? nama;
  final String? iduser;

  const MainScreens({super.key, this.nama, this.iduser});

  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl = "https://9e7d-180-242-215-247.ngrok-free.app/vigenesia";

  var dio = Dio();
  TextEditingController titleController = TextEditingController();

  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {
      "isi_motivasi": isi,
      "iduser": widget.iduser ?? ''
    };

    try {
      print("ID User adalah ${widget.iduser}");
      Response response = await dio.post(
        "$baseurl/api/dev/POSTmotivasi/",
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) => true,
        ),
      );
      print(
          "Respon Send Motivasi -> ${response.data} + ${response.statusCode}");
      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  Future<dynamic> deletePost(String id) async {
    dynamic data = {
      "id": id,
    };
    var response = await dio.delete('$baseurl/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {"Content-type": "application/json"}));

    print(" ${response.data}");

    var resbody = response.data;
    return resbody;
  }

  Future<List<MotivasiModel>> getData() async {
    var response = await dio.get('$baseurl/api/Get_motivasi/');

    print("Respon GetDataMotivasi -> ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> _getData() async {
    setState(() {
      getData();
    });
  }

  TextEditingController isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hallo entry  ${widget.nama}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        child: const Icon(Icons.logout),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => new Login(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    controller: isiController,
                    name: "isi_motivasi",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        await sendMotivasi(isiController.text).then((value) => {
                              if (value != null)
                                {
                                  Flushbar(
                                    message: "Berhasil Submit",
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.greenAccent,
                                    flushbarPosition: FlushbarPosition.TOP,
                                  ).show(context)
                                },
                              //_getData(),
                              print("Sukses"),
                            });
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    child: const Icon(Icons.refresh),
                    onPressed: () {
                      _getData();
                    },
                  ),
                  FutureBuilder(
                      future: getData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<MotivasiModel>> snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              for (var item in snapshot.data!)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item.isiMotivasi.toString()),
                                            Row(
                                              children: [
                                                TextButton(
                                                  child: const Icon(
                                                      Icons.settings),
                                                  onPressed: () {
                                                    String id;
                                                    String isiMotivasi;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              EditPage(
                                                                  id: item.id,
                                                                  isi_motivasi:
                                                                      item.isiMotivasi),
                                                        ));
                                                  },
                                                ),
                                                TextButton(
                                                  child:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    deletePost(item.id!)
                                                        .then((value) => {
                                                              if (value != null)
                                                                {
                                                                  Flushbar(
                                                                    message:
                                                                        "Berhasil Delete",
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            2),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .redAccent,
                                                                    flushbarPosition:
                                                                        FlushbarPosition
                                                                            .TOP,
                                                                  ).show(
                                                                      context)
                                                                }
                                                            });
                                                    _getData();
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return const Text("No Data");
                        } else {
                          return const CircularProgressIndicator();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}