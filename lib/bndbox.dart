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

  String formerClass = '';

  List formerClasses = [];

  @override
  Widget build(BuildContext context) {
    if (widget.results.isEmpty) {
      setState(() {
        formerClass = '';
        formerClasses = [];
      });
    }

    List<Widget> _renderBoxes() {
      var lengthy = widget.results.length;

      var temp = widget.results;

//      print("the lenght of temp is: ${temp.length}");

      return widget.results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;

        if (lengthy > 1) {
          if (formerClasses.isEmpty) {
            var totalAmount = 0;

            temp.forEach((f) {
              if (double.tryParse(
                      '${(f["confidenceInClass"] * 100).toStringAsFixed(0)}') >=
                  80) {
                formerClasses.add("${f['detectedClass']}");

                switch ("${f['detectedClass']}") {
                  case "five naira":
                    {
                      totalAmount += 5;
                      break;
                    }
                  case "ten naira":
                    {
                      totalAmount += 10;
                      break;
                    }
                  case "twenty naira":
                    {
                      totalAmount += 20;
                      break;
                    }
                  case "fifty naira":
                    {
                      totalAmount += 50;
                      break;
                    }
                  case "one hundred naira":
                    {
                      totalAmount += 100;
                      break;
                    }
                  case "two hundred naira":
                    {
                      totalAmount += 200;
                      break;
                    }
                  case "five hundred naira":
                    {
                      totalAmount += 500;
                      break;
                    }
                  case "one thousand naira":
                    {
                      totalAmount += 1000;
                      break;
                    }
                  default:
                    break;
                }
              }
            });
            modelSpeak("$totalAmount naira");
            print("total amount in naira : $totalAmount naira");
          }
        } else if (double.tryParse(
                '${(re["confidenceInClass"] * 100).toStringAsFixed(0)}') >=
            80) {
          if (formerClass != "${re["detectedClass"]}" || formerClass.isEmpty) {
            modelSpeak("${re["detectedClass"]}");
            setState(() => formerClass = "${re["detectedClass"]}");
          }
        }

        if (widget.screenH / widget.screenW >
            widget.previewH / widget.previewW) {
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

          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
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
