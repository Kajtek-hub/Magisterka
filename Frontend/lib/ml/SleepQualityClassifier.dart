import 'dart:convert';
import 'package:tflite_flutter/tflite_flutter.dart';

class EpochResult {
  final int epochIndex;
  final int timestampS;
  final String label;
  final double confidence;
  final Map<String, double> probabilities;

  EpochResult({
    required this.epochIndex,
    required this.timestampS,
    required this.label,
    required this.confidence,
    required this.probabilities,
  });
}

class SleepQualityClassifier {
  Interpreter? _interpreter;

  // ✅ Zaktualizowane wartości z treningu — 8 cech
  final List<double> _scalerMin = [
    0.025129375834987984,
    0.004476605939169596,
    0.0017237326887670358,
    0.0004691197920397032,
    0.0004711197077384479,
    0.004778528317331143,
    0.02608160521996169,
    1.3574609435735743,
  ];

  final List<double> _scalerMax = [
    0.9140093927072099,
    0.3247631060655511,
    0.2200752442537831,
    0.1189027395385857,
    0.3501209282922048,
    2.4058410886770973,
    24.471453145689328,
    6.829112130603205,
  ];

  static const _labels = ['Restorative', 'Fragmented', 'Disrupted'];

  Future<void> load() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/sleep_quality_model.tflite',
    );
  }

  List<double> _normalize(List<double> features) {
    return List.generate(features.length, (i) {
      final range = _scalerMax[i] - _scalerMin[i];
      if (range == 0) return 0.0;
      return ((features[i] - _scalerMin[i]) / range).clamp(0.0, 1.0);
    });
  }

  // ✅ Klasyfikuj wszystkie epoki z EpochFeaturesJson
  List<EpochResult> classifyEpochs(String epochFeaturesJson) {
    if (_interpreter == null) return [];

    final epochs = jsonDecode(epochFeaturesJson) as List<dynamic>;
    final results = <EpochResult>[];

    for (final epoch in epochs) {
      // 8 cech — dodaj entropy (na razie 0 bo backend jeszcze jej nie liczy)
      final features = [
        (epoch['delta']      as num).toDouble(),
        (epoch['theta']      as num).toDouble(),
        (epoch['alpha']      as num).toDouble(),
        (epoch['sigma']      as num).toDouble(),
        (epoch['beta']       as num).toDouble(),
        (epoch['thetaAlpha'] as num).toDouble(),
        (epoch['deltaBeta']  as num).toDouble(),
        epoch['entropy'] != null ? (epoch['entropy'] as num).toDouble() : 0.0,
      ];

      final normalized = _normalize(features);
      final input  = [normalized];
      final output = List.generate(1, (_) => List.filled(3, 0.0));

      _interpreter!.run(input, output);

      final probs  = output[0];
      final maxIdx = probs.indexOf(probs.reduce((a, b) => a > b ? a : b));

      results.add(EpochResult(
        epochIndex: epoch['epochIndex'] as int,
        timestampS: epoch['timestampS'] as int,
        label:      _labels[maxIdx],
        confidence: probs[maxIdx],
        probabilities: {
          _labels[0]: probs[0],
          _labels[1]: probs[1],
          _labels[2]: probs[2],
        },
      ));
    }

    return results;
  }

  Map<String, dynamic> nightSummary(List<EpochResult> epochs) {
    if (epochs.isEmpty) return {};

    final counts = {'Restorative': 0, 'Fragmented': 0, 'Disrupted': 0};
    for (final e in epochs) {
      counts[e.label] = (counts[e.label] ?? 0) + 1;
    }

    final total       = epochs.length;
    final goodPct     = (counts['Restorative']! / total * 100).round();
    final moderatePct = (counts['Fragmented']!  / total * 100).round();
    final poorPct     = (counts['Disrupted']!   / total * 100).round();

    String overallLabel;
    if (goodPct >= 60)      overallLabel = 'Good night';
    else if (poorPct >= 40) overallLabel = 'Poor night';
    else                    overallLabel = 'Moderate night';

    return {
      'overallLabel':    overallLabel,
      'goodPercent':     goodPct,
      'moderatePercent': moderatePct,
      'poorPercent':     poorPct,
      'totalEpochs':     total,
      'durationMinutes': (total * 30 / 60).round(),
    };
  }

  void dispose() => _interpreter?.close();
}