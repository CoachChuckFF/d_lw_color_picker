import 'package:flutter/material.dart';
import 'lw_color_picker.dart';

main() => runApp(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('LW Flutter Picker'),
          ),
          body: MyApp(),
        ),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Card(
      child: 
      Center(
        child: LWColorPicker(width: width*0.89, callback: (color){
          print(color.toString());
        },),
      )
    );
  }

}