import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'database_helper.dart';


class FullPdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String pdfName;

  FullPdfViewerScreen(this.pdfPath, this.pdfName);

  @override
  _FullPdfViewerScreenState createState() => _FullPdfViewerScreenState();
}

class _FullPdfViewerScreenState extends State<FullPdfViewerScreen> {
  int time;
  String pdfName;
  String readTime;
  Timer _timer;
  int _start = 0;
  int id;
  final dbHelper = DatabaseHelper.instance;
  List readTimeList;

  Future<int> _insert(pdfName, readTime) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnPdfName: pdfName,
      DatabaseHelper.columnReadTime: readTime,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    return id;
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _start++;

        });
      },
    );
  }

  List timeFormatter(time) {
    int hour, minutes, seconds;
    String sh='', sm='', ss='';
    seconds = time % 60;
    minutes = time ~/ 60;
    hour = minutes ~/ 60;
    minutes = minutes % 60;
    if (hour != 0) {
      sh = '$hour hours';
    }
    if(minutes != 0){
      sm = '$minutes minutes';
    }
    if(seconds!=0){
      ss = "$seconds seconds";
    }

    return [sh, sm, ss];
  }

  @override
  void initState() {
    // TODO: implement initState // Called when at the beginning of widget life cycle
    super.initState();
    startTimer();
  }

  // Future<int> sessionSaveSql() async {
  //   _insert(pdfName, readTime)
  // }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // sessionSaveSql();
        pdfName = widget.pdfName;
        readTimeList = timeFormatter(_start);
        readTime = '${readTimeList[0]} ${readTimeList[1]} ${readTimeList[2]}';
        setState(() {});
        int id = await _insert(pdfName, readTime);
        if (id != null) {
          Navigator.pop(context);
        }
        return null;
      },
      child: PDFViewerScaffold(
        appBar: AppBar(
          title: Text("${widget.pdfName}"),
          backgroundColor: Colors.red,
        ),
        path: widget.pdfPath,
      ),
    );
  }
}
