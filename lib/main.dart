import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TrenbeApp()));
}

class TrenbeApp extends StatefulWidget {
  const TrenbeApp({Key? key}) : super(key: key);

  @override
  State<TrenbeApp> createState() => _TrenbeAppState();
}

class _TrenbeAppState extends State<TrenbeApp> {
  var a = 1;
  var name = ["김하나", "박둘", "이셋"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text(a.toString()),
        onPressed: () {
          setState(() {
            a++;
          });
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(child: Text("hello"));
              });
        },
      ),
      body: ListView.builder(itemBuilder: (c, i) {
        return ListTile(
          leading: Text("head"),
          title: Text(name[i]),
          trailing: TextButton(
            child: Text("버튼"),
            onPressed: () {},
          ),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        child: Text("hello"),
      ),
    );
  }
}
