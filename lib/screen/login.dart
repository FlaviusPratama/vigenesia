//import '/../Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'mainscreen.dart';
import 'register.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:myapp/models/login_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? iduser;
  String? nama;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<LoginModels?> postLogin(String email, String password) async {
    var dio = Dio();
    String baseurl =
        "https://9e7d-180-242-215-247.ngrok-free.app/vigenesia/"; // ganti dengan ip address kamu / tempat kamu menyimpan backend

    Map<String, dynamic> data = {"email": email, "password": password};

    try {
      final response = await dio.post("$baseurl/api/login/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(response.data);

        return loginModel;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
    return null;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // <-- Berfungsi Untuk Bisa Scroll
        child: SafeArea(
          // < -- Biar Gak Keluar Area Screen HP
          child: Container(
            // Tambahkan gradien merah dan putih di sini
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.white], // Warna gradien
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Security System-Login",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 50), // <-- Kasih Jarak Tinggi : 50px
                  Center(
                    child: Form(
                      key: _fbKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: "email",
                              controller: emailController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(),
                                labelText: "Email",
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              obscureText:
                                  true, // <-- Buat bikin setiap inputan jadi bintang " * "
                              name: "password",
                              controller: passwordController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(),
                                labelText: "Password",
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Dont Have Account? ',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const Register(),
                                          ),
                                        );
                                      },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await postLogin(emailController.text,
                                          passwordController.text)
                                      .then((value) => {
                                            if (value != null)
                                              {
                                                setState(() {
                                                  iduser = value.data?.id;
                                                  nama = value.data?.nama;
                                                  print(
                                                      "ID User: ${iduser} Nama: ${nama}");
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MainScreens(
                                                        iduser: iduser!,
                                                        nama: nama!,
                                                      ),
                                                    ),
                                                  );
                                                })
                                              }
                                            else if (value == null)
                                              {
                                                Flushbar(
                                                  message:
                                                      "Check Your Email / Password",
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  flushbarPosition:
                                                      FlushbarPosition.TOP,
                                                ).show(context)
                                              }
                                          });
                                },
                                child: const Text("Sign In"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}