library lw_color_picker;
import 'package:flutter/material.dart';

/*
  This file was inspired by fuyumi's flutter color picker @ https://github.com/mchome/flutter_colorpicker
*/

class LWColorPicker extends StatefulWidget{
  LWColorPicker({
    this.callback,
    this.width: 500.0,
    this.heightToWidthRatio: 0.7,
    }
  );
  final ValueChanged<Color> callback;
  final double width;
  final double heightToWidthRatio;


  @override
  State<StatefulWidget> createState() => LWColorPickerState();

}

class LWColorPickerState extends State<LWColorPicker> {
  double hue;
  double saturation;
  double value;

  void _update(){
    if(widget.callback != null){
      widget.callback(getCurrentColor());
    }

    setState((){});
  }

  Color getCurrentColor(){
    return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  }

  @override
  initState() {
    super.initState();
    HSVColor color = HSVColor.fromColor(Colors.purple);
    hue = color.hue;
    saturation = color.saturation;
    value = 1.0;
  }

    @override
  Widget build(BuildContext context) {
    double width = widget.width;
    double height = width * widget.heightToWidthRatio;

    return Column(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details){
              RenderBox box = context.findRenderObject();
              Offset localOffset = box.globalToLocal(details.globalPosition);
              print("hi");
              setState(() {
                this.hue = (localOffset.dx.clamp(0.0, width) / width) * 360.0;
                this.saturation = 1 - localOffset.dy.clamp(0.0, height) / height;
              });
            },
            child: CustomPaint(
              size: Size(width, height),
              painter: ColorPainter(
                hue: this.hue,
                saturation: this.saturation,
                value: this.value
              ),
            ),
          ),
        ),
        Slider(
          onChanged: (val){
            setState(() {
              this.value = val;
            });
          },
          value: this.value,
        )
      ],
    );
  }
}

class ColorPainter extends CustomPainter {
  ColorPainter({
    this.hue: 0.0,
    this.saturation: 1.0,
    this.value: 1.0,
  });

  double hue;
  double saturation;
  double value;

  @override
  paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Gradient gradientBW = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 0, 0, 0),
        HSVColor.fromAHSV(1.0, 0.0, 0.0, value).toColor(),
      ],
    );

    Gradient gradientColor = LinearGradient(
      colors: [
        HSVColor.fromAHSV(1.0, 0.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 45.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 90.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 135.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 180.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 225.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 270.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 315.0, 1.0, value).toColor(),
      ],
    );
    
    
    canvas.drawRect(
        rect,
        Paint()
          ..shader = gradientColor.createShader(rect));
    canvas.drawRect(
        rect, 
        Paint()
          ..shader = gradientBW.createShader(rect)
          ..blendMode = BlendMode.lighten);
    canvas.drawCircle(
        Offset(size.width * (hue / 360.0), size.height * (1 - saturation)),
        size.height * 0.04,
        Paint()
          ..color = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor()
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}