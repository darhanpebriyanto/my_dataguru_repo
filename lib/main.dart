import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Mhs>> fetchMhss(http.Client client) async {
  final response =
      await client.get('https://darhanpebriyanto.000webhostapp.com/readDatajson.php');

  // Use the compute function to run parseMhss in a separate isolate.
  return compute(parseMhss, response.body);
}

// A function that converts a response body into a List<Mhs>.
List<Mhs> parseMhss(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Mhs>((json) => Mhs.fromJson(json)).toList();
}

class Mhs {
  final String nig;
  final String nama_guru;
  final String jenjang_akademik;
  final String pendidikan_terakhir;
  final String home_base;

  Mhs({this.nig, this.nama_guru, this.jenjang_akademik, this.pendidikan_terakhir, this.home_base});

  factory Mhs.fromJson(Map<String, dynamic> json) {
    return Mhs(
      nig: json['nig'] as String,
      nama_guru: json['nama_guru'] as String,
      jenjang_akademik: json['jenjang_akademik'] as String,
      pendidikan_terakhir: json['pendidikan_terakhir'] as String,
      home_base: json['home_base'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Guru';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Mhs>>(
        future: fetchMhss(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MhssList(MhsData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MhssList extends StatelessWidget {
  final List<Mhs> MhsData;

  MhssList({Key key, this.MhsData}) : super(key: key);



Widget viewData(var data,int index)
{
return Container(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.orange,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
            
          ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].nig, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].nama_guru, style: TextStyle(color: Colors.white)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: MhsData.length,
      itemBuilder: (context, index) {
        return viewData(MhsData,index);
      },
    );
  }
}