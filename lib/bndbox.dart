import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'models.dart';

import "package:flutter_tts/flutter_tts.dart";

class BndBox extends StatefulWidget {

  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;


  BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      this.model);

  @override
  _BndBoxState createState() => _BndBoxState();
}

class _BndBoxState extends State<BndBox> {
  final FlutterTts flutterTts = FlutterTts();

modelSpeak(amount) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.85);
    await flutterTts.speak(amount);
    await flutterTts.setSpeechRate(0.75);
  }



  @override
  Widget build(BuildContext context) {

    List<Widget> _renderBoxes()  {
      return widget.results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;


        if ((double.tryParse('${(re["confidenceInClass"]*100).toStringAsFixed(0)}') >= 80)){
          modelSpeak('${re["detectedClass"]}');
          Future.delayed(Duration(seconds: 12),()=>modelSpeak("${re["detectedClass"]}"));
        }


//  String formerClass = '';
//  @override
//  Widget build(BuildContext context) {
//
//    List<Widget> _renderBoxes() {
//      return widget.results.map((re) {
//        var _x = re["rect"]["x"];
//        var _w = re["rect"]["w"];
//        var _y = re["rect"]["y"];
//        var _h = re["rect"]["h"];
//        var scaleW, scaleH, x, y, w, h;
//        if(double.tryParse('${(re["confidenceInClass"] * 100).toStringAsFixed(0)}') >= 80){
//
//
//          if(formerClass != "${re["detectedClass"]}" || formerClass.isEmpty){
//            modelSpeak("${re["detectedClass"]}");
//            setState(()=> formerClass = "${re["detectedClass"]}");
//          }
//        }




//        else{
//              print("${re["detectedClass"]}, ${DateTime.now()}");
//        }

//        if(double.tryParse('${(re["confidenceInClass"]*100).toStringAsFixed(0)}') >= 80){

          //modelSpeak('${re["detectedClass3"]}');

//          Timer(Duration(seconds: 12), ()=>modelSpeak("${re["detectedClass"]}"));

//          Future.delayed(Duration(seconds: 12),()=> print("${re["detectedClass"]}, ${DateTime.now()}"));

          //modelSpeak("${re["detectedClass"]}")
//        }

//       //
//        if(double.tryParse('${(re["confidenceInClass"] * 100).toStringAsFixed(0)}')>=60 ){
//          modelSpeak("${re["detectedClass"]}");
//        }

      //  modelSpeak('${re["detectedClass"]}');

        if (widget.screenH / widget.screenW > widget.previewH / widget.previewW) {
          scaleW = widget.screenH / widget.previewH * widget.previewW;
          scaleH = widget.screenH;
          var difW = (scaleW - widget.screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = widget.screenW / widget.previewW * widget.previewH;
          scaleW = widget.screenW;
          var difH = (scaleH - widget.screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                width: 3.0,
              ),
            ),
            child: Text(
              "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    List<Widget> _renderStrings() {
      double offset = -10;
      return widget.results.map((re) {
        offset = offset + 14;
        return Positioned(
          left: 10,
          top: offset,
          width: widget.screenW,
          height: widget.screenH,
          child: Text(
            "${re["label"]} ${(re["confidence"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList();
    }

    List<Widget> _renderKeyPoints() {
      var lists = <Widget>[];
      widget.results.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW > widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          return Positioned(
            left: x - 6,
            top: y - 6,
            width: 100,
            height: 12,
            child: Container(
              child: Text(
                "● ${k["part"]}",
                style: TextStyle(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }).toList();

        lists..addAll(list);
      });

      return lists;
    }

    return Stack(
      children: widget.model == mobilenet
          ? _renderStrings()
          : widget.model == posenet ? _renderKeyPoints() : _renderBoxes(),
    );
  }
}
