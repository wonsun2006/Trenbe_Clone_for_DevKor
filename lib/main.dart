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

  addOne() {
    setState(() {
      a++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Builder(
        builder: (context_sub) {
          return FloatingActionButton(
            child: Text(a.toString()),
            onPressed: () {
              setState(() {
                a++;
              });
              showDialog(
                  context: context_sub,
                  builder: (context_sub) {
                    return DialogUI(state: a, addOne: addOne);
                  });
            },
          );
        },
      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (c, i) {
            return ListTile(
              leading: Text("head"),
              title: Text(name[i]),
              trailing: TextButton(
                child: Text("버튼"),
                onPressed: () {},
              ),
            );
          }),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.state, this.addOne}) : super(key: key);

  var state;
  final addOne;
  var inputData = TextEditingController();
  var inputData2 = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(
              controller: inputData,
              // onChanged: (text) {
              //   inputData2 = text;
              // },
            ),
            Text(state.toString()),
            TextButton(
                onPressed: () {
                  addOne();
                },
                child: Text("확인")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("취소"))
          ],
        ),
      ),
    );
  }
}
