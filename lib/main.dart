import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SaveLoad());
}

final List<String> _whoreYou = ['Протеже', 'Шимпанзе', 'Конферансье', 'Атташе', 'Товарищ'];
final Map<int,String> _whoreYouMap = {
  0:'Привет, протеже', 1:'Привет, шимпанзе',
  2:'Привет, конферансье', 3:'Привет,атташе', 4:'Привет, товарищ'};

class DataStorage {
  Future<String> get _localPath async{
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/data.txt');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
    } catch(e) {
      return 'somebody';
    }
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;

    return file.writeAsString('$data');
  }
}

class SaveLoad extends StatelessWidget {
  const SaveLoad({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey
      ),
      home: MyHomePage(storage: DataStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);

  final DataStorage storage;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _whoreYouIndex = 0;
  String _userName = 'nobody';
  TextEditingController textController = TextEditingController(text: '');


  @override
  void initState() {
    super.initState();
    _loadData();
    widget.storage.readData().then((String value) {
      setState(() {
        _userName = value;
        textController.text = value;
      });
    });
  }

  Future<File> _changeName(String val) {
    setState(() {
      _userName = val;
    });

    return widget.storage.writeData(_userName);
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _whoreYouIndex = (prefs.getInt('whoreYouIndex') ?? 0);
    });
  }

  void _changeData(int? value) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _whoreYouIndex = value!;
      prefs.setInt('whoreYouIndex', _whoreYouIndex);
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text('Как к Вам обращаться?',
                  style: Theme.of(context).textTheme.headline5,),
              ),
              const SizedBox(
                height: 30,
              ),
              RadioListTile(
                title: Text(_whoreYou[0]),
                value: 0,
                groupValue: _whoreYouIndex,
                onChanged: _changeData
              ),
              RadioListTile(
                title: Text(_whoreYou[1]),
                value: 1,
                groupValue: _whoreYouIndex,
                onChanged: _changeData,
              ),
              RadioListTile(
                title: Text(_whoreYou[2]),
                value: 2,
                groupValue: _whoreYouIndex,
                onChanged: _changeData,
              ),
              RadioListTile(
                title: Text(_whoreYou[3]),
                value: 3,
                groupValue: _whoreYouIndex,
                onChanged: _changeData,
              ),
              RadioListTile(
                title: Text(_whoreYou[4]),
                value: 4,
                groupValue: _whoreYouIndex,
                onChanged: _changeData,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text('Введите Ваше имя:',
                  style: Theme.of(context).textTheme.headline5,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (val) {_changeName(val);},
                  controller: textController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text('${_whoreYouMap.values.elementAt(_whoreYouIndex)} $_userName!',
                  style: Theme.of(context).textTheme.headline5,),
              ),
            ]
          ),
        ),
      ),
    );
  }
}

