import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      shadowColor: Colors.green,
      semanticLabel: "My Drawer",
      child: Column(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            alignment: Alignment.bottomCenter,
            color: Colors.blue,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('My Drawer', style: TextStyle(fontSize: 22,color: Colors.white, fontFamily: "normal"),),
            ),
          ),
          const SizedBox(height: 10,),
          const Center(
            child: CircleAvatar(
              // backgroundImage: NetworkImage("https://images.app.goo.gl/HJEVPsWtHY9xxXn2A"),
              radius: 32,
              backgroundImage: AssetImage("assets/images/avatar.png"),
            )
          ),
          const Divider(thickness: 3,),
          const ListTile(
            title: Text("Mohit Soni", style: TextStyle(fontSize: 24, fontFamily: 'cursive'),),
            leading: Icon(Icons.home, color: Colors.deepPurple,),
          ),
          // const SizedBox(height: 6,),
          const ListTile(
            title: Text("+91 8769103837", style: TextStyle(fontSize: 18, fontFamily: 'normal', fontWeight: FontWeight.w100),),
            leading: Icon(Icons.phone, color: Colors.deepPurple,),
          ),
          // const SizedBox(height: 6,),
          const ListTile(
            title: Text("mohitsoni.2004.works@gmail.com", style: TextStyle(fontSize: 18, fontFamily: 'normal'),),
            leading: Icon(Icons.mail, color: Colors.deepPurple,),
          ),

        ],
      ),
    );
  }
}