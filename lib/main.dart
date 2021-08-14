import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextflow_covid_today/covid_today_result.dart';
import 'package:nextflow_covid_today/stat_box.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19 Status',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyHomePage(title: 'Covid-19 Status'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() { 
    super.initState();
    getData();
  }

  Future<CovidTodayResult> getData() async {
    var response = await http.get('https://covid19.th-stat.com/api/open/today');
    final result = covidTodayResultFromJson(response.body);
    return result;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<CovidTodayResult> snapshot) { 
          if(snapshot.connectionState == ConnectionState.done) {

            final result = snapshot.data;
            
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  StatBox(title: 'ผู้ติดเชื้อสะสม', total: result?.confirmed, backgroundColor: Color(0xffFF173E)),
                    SizedBox(height: 10,),
                    
                  StatBox(title: 'หายแล้ว', total: result?.recovered, backgroundColor: Color(0xff46E36D)),
                    SizedBox(height: 10,),

                  StatBox(title: 'กำลังรักษา', total: result?.hospitalized, backgroundColor: Color(0xff43A1D9)),
                    SizedBox(height: 10,),

                  StatBox(title: 'จำนวนผู้เสียชีวิต', total: result?.deaths, backgroundColor: Color(0xffE68A1C)),
                  ListTile(
                    title: Text('ข้อมูลจากกรมควบคุมโรค ณ วันที่ '),
                    subtitle: Text('${result?.updateDate ?? 'กำลังโหลด'}'),
                  )          
                ],
              ),
            );
          }

        return LinearProgressIndicator();
      },),
    );
  }
}
