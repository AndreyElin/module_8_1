import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _findController = TextEditingController();
  String text = '';

  @override
  void dispose() {
    _findController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: TextField(
                    controller: _findController,
                    decoration: const InputDecoration(
                      hintText: 'Введите имя файла',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  height: 70,
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () {
                      find();
                    },
                    child: const Text('Найти'),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(text),
            ),
          ),
          FutureBuilder(
              future: fetchFileFromAssets('assets/${_findController.text}'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          child: Text(snapshot.data),
                        ),
                      );
                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                } else if (snapshot.hasError && snapshot.error == 'isEmpty') {
                  return const Center(
                    child: Text('Здесь будет выведен текст файла'),
                  );
                } else {
                  return const Center(
                    child: Text('Файл не найден'),
                  );
                }
              }),
        ],
      ),
    );
  }

  void find() {
    setState(() {
      text = _findController.text;
    });
  }

  Future<String> fetchFileFromAssets(String assetsPath) {
    if (assetsPath == 'assets/') {
      return Future.error('isEmpty');
    }
    return rootBundle
        .loadString(assetsPath)
        .then((file) => file.toString())
        .catchError((error) {});
  }
}