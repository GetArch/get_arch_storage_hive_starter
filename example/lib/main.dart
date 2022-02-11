import 'dart:math';

import 'package:example/src/config/const.dart';
import 'package:example/src/config/injector.dart';
import 'package:example/src/domain/aggregate.dart';
import 'package:example/src/interface/person_repo.dart';
import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetArchApplication.run(kEnvDev, packages: [
    ExamplePackage(), // 将您的Package放在第一行, 可以确保相关配置文件能够正常打印(这不影响程序运行)
    GetArchStorageHiveStarter(),
  ]);
  runApp(const MyApp());
}

class ExamplePackage extends BaseGetArchPackage {
  @override
  InitPackageDI? get initPackageDI => configPackageDI;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp build');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Person> data;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    setState(() {
      data = sl<PersonRepo2>().findAll().toList();
    });
  }

  void _addRandomPerson() {
    final rdm = Random();
    final id = rdm.nextInt(1000000).toString().padLeft(6, '0');
    final age = rdm.nextInt(100);
    final name = 'name-$age';
    final p = Person(id, name, age);
    sl<PersonRepo2>().save(p);
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (ctx, i) {
            final p = data[i];
            return ListTile(
              title: Text(p.name),
              subtitle: Text(p.age.toString()),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRandomPerson,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
