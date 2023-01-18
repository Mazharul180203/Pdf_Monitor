import 'package:flutter/material.dart';

import 'database_helper.dart';

class HistoryScreen extends StatefulWidget {
  final List historyList;

  HistoryScreen({this.historyList});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  get dbHelper => DatabaseHelper.instance;

  @override
  void initState() {

    super.initState();
    print('History List:');
    print(widget.historyList);
  }

  @override
  Widget build(BuildContext context) {
    void _delete() async {


      final id = await dbHelper.queryRowCount();
      final rowsDeleted = await dbHelper.delete(id);

      print('deleted $rowsDeleted row(s): row $id');
    }

    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.history),
          title: Text("History"),
        ),
        body: ListView(
          children: [
            RaisedButton(
              onPressed: _delete,
              color: Colors.green,
              child: Text(
                "delete",
              ),
            ),

            SizedBox(height: 15,),
            ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.historyList.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin:  EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.deepOrange.shade50,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PDF  NAME: ${widget.historyList[index]['pdfName']}',style: TextStyle(fontSize: 16),),
                        Text('READ TIME: ${widget.historyList[index]['readTime']}',style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  );
                })
          ],
        ));
  }

}