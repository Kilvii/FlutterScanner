import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class QRCodeInfoScreen extends StatefulWidget {
  final String _qrCodeInfo;
  QRCodeInfoScreen(this._qrCodeInfo);

  @override
  _QRCodeInfoScreenState createState() => _QRCodeInfoScreenState();
}

class _QRCodeInfoScreenState extends State<QRCodeInfoScreen> {
  late List<String> splittedData;
  late int age;
  late int classroom;
  late int passport_series;
  late int passport_number;
  late String roomId;
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    super.initState();
    splittedData = widget._qrCodeInfo.split('; ');
    final String phoneNumber = splittedData[6];
    final String cleanedPhoneNumber = "+" + phoneNumber.replaceAll(new RegExp(r'\s|-'), '');
    splittedData[6] = cleanedPhoneNumber;
    age = int.parse(splittedData[5]);
    classroom = int.parse(splittedData[10]);
    passport_series = int.parse(splittedData[13]);
    passport_number = int.parse(splittedData[14]);

    _sendDataToServer();

  }

  Future<void> _sendDataToServer() async {
    final Dio dio = Dio();

    final response = await dio.post(
      'http://5.42.220.6:3000/api/users/store',
      data: {
        "surname": splittedData[0],
        "firstname": splittedData[1],
        "patronymic": splittedData[2],
        "gender": splittedData[3],
        "birthdate": splittedData[4],
        "age": age,
        "phone": splittedData[6],
        "email": splittedData[7],
        "school": splittedData[8],
        "address": splittedData[9],
        "classroom": classroom,
        "subject": splittedData[11],
        "citizenship": splittedData[12],
        "passport_series": passport_series,
        "passport_number": passport_number,
      },
    );
    setState(() {
      _response = response.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_response.isEmpty) {
      return Center(child:
      SizedBox( width: 30, height: 30, child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Info'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('${_response['user']['surname']} ${_response['user']['firstname']} ${_response['user']['patronymic']}'),
            Text('Садится в аудиторию №${_response['user']['room_id']}'),
            Text('На место под номером №${_response['user']['seat']}'),
          ],
        ),
      ),
    );
  }
}