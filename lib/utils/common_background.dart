import 'package:flutter/material.dart';
import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';

const BoxDecoration commonBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [CustomColors.backgroundColor, CustomColors.backgroundLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);
