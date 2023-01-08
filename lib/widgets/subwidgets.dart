import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectPerBottomSheet extends StatelessWidget {
  const SelectPerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          Container(
            child: Column(
              children: [
                Text("인원수 입력"),
                TextField(),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('sdfs'),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('sdfs'),
          ),
          ListTile(
            leading: null,
            title: Text(''),
          )
        ],
      ),
    );
  }
}
