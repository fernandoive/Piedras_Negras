import 'package:flutter/material.dart';

double sizeWidth(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.9;
}

double sizeWidth4(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.35;
}

double sizeWidth25(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.25;
}

double sizeWidth5(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.5;
}

double sizeTotalWidth(BuildContext context) {
  return MediaQuery.of(context).size.width * 1;
}

double sizeWidthPerson(BuildContext context, double width) {
  return MediaQuery.of(context).size.width * width;
}