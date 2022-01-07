import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';
import 'UserDta.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'WelcomePage.dart';
import 'HomePageDoctor.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'DocsPath.dart';

class DocsViewer extends StatefulWidget {
  DocsViewerState createState() => DocsViewerState();
}

class DocsViewerState extends State<DocsViewer> {
  File toupload;
  bool _isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  PDFDocument document;

  changePDF(String url) async {
    setState(() => _isLoading = true);

    document = await PDFDocument.fromURL(
      // "https://crenelate-intervals.000webhostapp.com/uploads/1619468904.pdf"
      url,
    );

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    changePDF(DocsPath.DocsPathName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                "Useful documents",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      backgroundColor: Colors.white,
      key: _scaffoldstate,
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
                document: document,
                zoomSteps: 1,
              ),
      ),
    );
  }
}
