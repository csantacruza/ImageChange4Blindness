import 'dart:typed_data';
import 'package:photofilters/models.dart';

int clampPixel(int x) => x.clamp(0, 255);
int avgRed = 0;
int avgGreen = 0;
int avgBlue = 0;
List<double> typeMatrix;

//Taked from https://gist.github.com/Lokno/df7c3bfdc9ad32558bb7

final matrixTritanopia = [
  0.950,
  0.050,
  0.000,
  0.000,
  0.433,
  0.567,
  0.000,
  0.475,
  0.525
];

final matrixTritanomaly = [
  0.967,
  0.033,
  0.00,
  0.00,
  0.733,
  0.267,
  0.00,
  0.183,
  0.817
];

final matrixDeuteranopia = [
  0.625,
  0.375,
  0.000,
  0.700,
  0.300,
  0.000,
  0.000,
  0.300,
  0.700
];

final matrixDeuteranomaly = [
  0.800,
  0.200,
  0.000,
  0.258,
  0.742,
  0.000,
  0.000,
  0.142,
  0.858
];

final matrixProtanopia = [
  0.567,
  0.433,
  0.000,
  0.558,
  0.442,
  0.000,
  0.000,
  0.242,
  0.758
];

final matrixProtanomaly = [
  0.817,
  0.183,
  0.000,
  0.333,
  0.667,
  0.000,
  0.000,
  0.125,
  0.875
];

void blindnessImage(Uint8List bytes,String typeBlindness) {
  switch(typeBlindness){
    //condition where theblue (third) pigment is missing, ‘blueblind’.
    case "Tritanopia":{typeMatrix = matrixTritanopia;} break;
    //theoretically the ‘blueinsensitive’ anomalous condition, butthe condition is not known to exist.
    case "Tritanomaly":{typeMatrix = matrixTritanomaly;} break;
    //condition where thegreen (second) pigment is missing,‘green blind’.
    case "Deuteranopia":{typeMatrix = matrixDeuteranopia;} break;
    //‘green insensi-tive’ anomalous condition.
    case "Deuteranomaly":{typeMatrix = matrixDeuteranomaly;} break;
    //condition where thered (first) pigment is missing, ‘redblind’.
    case "Protanopia":{typeMatrix = matrixProtanopia;} break;
    //‘red insensitive’anomalous  condition
    case "Protanomaly":{typeMatrix = matrixProtanomaly;} break;
    }

  for (int i = 0; i < bytes.length; i += 4) {
    int r = bytes[i], g = bytes[i + 1], b = bytes[i + 2];
    
    avgRed =
        (typeMatrix[0] * r + typeMatrix[1] * g + typeMatrix[2] * b).round();
    avgGreen =
        (typeMatrix[3] * r + typeMatrix[4] * g + typeMatrix[5] * b).round();
    avgBlue =
        (typeMatrix[6] * r + typeMatrix[7] * g + typeMatrix[8] * b).round();

    bytes[i] = clampPixel(avgRed);
    bytes[i + 1] = clampPixel(avgGreen);
    bytes[i + 2] = clampPixel(avgBlue);
  }
}

//Confuse BLUE with GREEN and YELLOW with VIOLET
RGBA blindnessColor(RGBA color,String typeBlindness) {

  switch(typeBlindness){
    //condition where theblue (third) pigment is missing, ‘blueblind’.
    case "Tritanopia":{typeMatrix = matrixTritanopia;} break;
    //theoretically the ‘blueinsensitive’ anomalous condition, butthe condition is not known to exist.
    case "Tritanomaly":{typeMatrix = matrixTritanomaly;} break;
    //condition where thegreen (second) pigment is missing,‘green blind’.
    case "Deuteranopia":{typeMatrix = matrixDeuteranopia;} break;
    //‘green insensi-tive’ anomalous condition.
    case "Deuteranomaly":{typeMatrix = matrixDeuteranomaly;} break;
    //condition where thered (first) pigment is missing, ‘redblind’.
    case "Protanopia":{typeMatrix = matrixProtanopia;} break;
    //‘red insensitive’anomalous  condition
    case "Protanomaly":{typeMatrix = matrixProtanomaly;} break;
    }

  avgRed = (typeMatrix[0] * color.red +
          typeMatrix[1] * color.green +
          typeMatrix[2] * color.blue)
      .round();
  avgGreen = (typeMatrix[3] * color.red +
          typeMatrix[4] * color.green +
          typeMatrix[5] * color.blue)
      .round();
  avgBlue = (typeMatrix[6] * color.red +
          typeMatrix[7] * color.green +
          typeMatrix[8] * color.blue)
      .round();

  return new RGBA(
    red: clampPixel(avgRed),
    green: clampPixel(avgGreen),
    blue: clampPixel(avgBlue),
    alpha: color.alpha,
  );
}