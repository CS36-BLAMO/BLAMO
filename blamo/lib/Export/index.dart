import 'package:blamo/main.dart';
import 'package:flutter/material.dart';


/*This page will serve as a manual export option for both email and cloud save
 *
 */
class ExportPage extends StatefulWidget {
  @override
  _ExportPageState createState() => _ExportPageState();


}

class _ExportPageState extends State<ExportPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
       child: new ListView(
           children: <Widget> [
             new UserAccountsDrawerHeader(
               decoration: new BoxDecoration(
                   image: new DecorationImage(
                       image: new AssetImage('assets/images/OSU-eng-logo.png')
                   )
               ),
             ),
             new ListTile(
                 title: new Text("Home"),
                 leading: Icon(
                     Icons.home,
                     color: Colors.blue
                 ),
                 onTap: () {
                    Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
             ),
             Divider(),
             new ListTile(
               title: new Text("Export"),
               leading: Icon(
                   Icons.import_export,
                   color: Colors.blue
               ),
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => ExportPage()),
                 );
               },
             ),
             Divider()
           ]
       )
      ),
      appBar: new AppBar(
          title: new Text("Export"),
          actions: <Widget>[
          ],
          backgroundColor: Colors.deepOrangeAccent
      ),
      body: Center(
        child: Center(child:_exportList()),
      ),
    );
  }
}
Widget _exportList() => ListView(
  children: [
    Center(child:_tile('Email',Icons.email)),
    Divider(),
    Center(child:_tile('Box',Icons.cloud_upload))
  ],
);
ListTile _tile(String destination, IconData icon) => ListTile(
  title: Text(destination,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize:25
      )),
  leading: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Icon(
      icon,
      color: Colors.blue,
    ),
  ),
);

//TODO Add functionality for onclick to grab CSV and email, text popup for email to send to
//TODO cloud save to Box(Both form AND CSV?)