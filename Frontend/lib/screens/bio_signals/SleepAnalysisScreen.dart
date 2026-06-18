import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magisterka/api/biosignal_service.dart';
import 'package:magisterka/api/secure_storage.dart';
import 'package:magisterka/ml/SleepQualityClassifier.dart';
import 'package:magisterka/theme.dart';

class SleepAnalysisScreen extends StatefulWidget {
  final Map<String, dynamic>? preloadedRecording; // ← NOWE

  const SleepAnalysisScreen({
    super.key,
    this.preloadedRecording, // ← NOWE
  });

  @override
  State<SleepAnalysisScreen> createState() => _SleepAnalysisScreenState();
}

class _SleepAnalysisScreenState extends State<SleepAnalysisScreen> {
  final _classifier = SleepQualityClassifier();
  bool _loading = true;
  List<dynamic> _recordings = [];
  List<EpochResult> _epochResults = [];
  Map<String, dynamic> _summary = {};
  String? _selectedRecordingId;

  int _windowStart = 0;
  static const int _windowSize = 60;

  @override
  void initState() {
    super.initState();
    _classifier.load().then((_) {
      if (widget.preloadedRecording != null) {
        // ← Wejście z BioSignalChartScreen — analizuj od razu
        setState(() => _loading = false);
        _analyze(widget.preloadedRecording!);
      } else {
        // ← Wejście z menu — pokaż listę nagrań
        _loadRecordings();
      }
    });
  }

  @override
  void dispose() {
    _classifier.dispose();
    super.dispose();
  }

  Future<void> _loadRecordings() async {
    try {
      final userId = await SecureStorage.getUserId();
      if (userId == null) return;
      final data = await BioSignalService.getRecordings(userId);
      setState(() {
        _recordings = data.where((r) =>
          r['deviceType'] == 'BITalino' &&
          r['epochFeaturesJson'] != null
        ).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _analyze(Map<String, dynamic> recording) {
    try {
      print("Starting analysis...");
      print("epochFeaturesJson: ${recording['epochFeaturesJson']}");
      
      final results = _classifier.classifyEpochs(
        recording['epochFeaturesJson'] as String,
      );
      
      print("Results count: ${results.length}");
      
      setState(() {
        _selectedRecordingId = recording['id'] as String;
        _epochResults = results;
        _summary = _classifier.nightSummary(results);
        _windowStart = 0;
      });
      
      print("Summary: $_summary");
      
    } catch (e) {
      print("Analysis error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Analysis error: $e")),
        );
      }
    }
  }

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    return h > 0 ? "${h}h ${m}min" : "${m}min";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme_Colors.background1, Theme_Colors.background2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        "Sleep Analysis",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pokaż picker tylko gdy wejście z menu
                            if (widget.preloadedRecording == null)
                              _recordingPicker(),
                            if (_epochResults.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _summaryCard(),
                              const SizedBox(height: 16),
                              _epochChart(),
                              const SizedBox(height: 12),
                              _windowControls(),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recordingPicker() {
    if (_recordings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          "No recordings with epoch data.\n"
          "Upload a BITalino recording through the recording screen.",
          style: TextStyle(color: Colors.white54),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select recording:",
            style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 8),
        ..._recordings.map((r) {
          final date = DateTime.parse(r['recordedAt']).toLocal();
          final dateStr =
              "${date.day.toString().padLeft(2,'0')}."
              "${date.month.toString().padLeft(2,'0')}."
              "${date.year}  "
              "${date.hour.toString().padLeft(2,'0')}:"
              "${date.minute.toString().padLeft(2,'0')}";
          final isSelected = _selectedRecordingId == r['id'];

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.greenAccent : Colors.white24,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ListTile(
              title: Text(dateStr,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              subtitle: Text(
                r['fileName'] as String,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              trailing: ElevatedButton(
                onPressed: () => _analyze(r as Map<String, dynamic>),
                child: const Text("Analyze"),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _summaryCard() {
    final label    = _summary['overallLabel'] as String;
    final goodPct  = _summary['goodPercent']  as int;
    final modPct   = _summary['moderatePercent'] as int;
    final poorPct  = _summary['poorPercent']  as int;
    final duration = _summary['durationMinutes'] as int;

    Color labelColor;
    if (label.contains('Good'))      labelColor = Colors.greenAccent;
    else if (label.contains('Poor')) labelColor = Colors.redAccent;
    else                             labelColor = Colors.orangeAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: labelColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: labelColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              Text("${duration ~/ 60}h ${duration % 60}min",
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 12),
          _summaryBar("Restorative", goodPct, Colors.greenAccent),
          _summaryBar("Fragmented",  modPct,  Colors.orangeAccent),
          _summaryBar("Disrupted",   poorPct, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _summaryBar(String label, int percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text("$percent%",
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: Colors.white12,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _epochChart() {
    final windowEnd =
        (_windowStart + _windowSize).clamp(0, _epochResults.length);
    final visible = _epochResults.sublist(_windowStart, windowEnd);

    final spots = visible.asMap().entries.map((e) {
      final val = e.value.label == 'Restorative' ? 2.0
                : e.value.label == 'Fragmented'  ? 1.0
                : 0.0;
      return FlSpot(e.key.toDouble(), val);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sleep quality — 30s epochs "
          "(${_formatTime(_windowStart * 30)} – "
          "${_formatTime(windowEnd * 30)})",
          style: const TextStyle(color: Colors.white, fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: -0.2,
              maxY: 2.2,
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: Colors.white12, strokeWidth: 0.5),
                getDrawingVerticalLine: (_) =>
                    FlLine(color: Colors.white12, strokeWidth: 0.5),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white24),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 72,
                    interval: 1,
                    getTitlesWidget: (v, _) {
                      final labels = {
                        0.0: 'Disrupted',
                        1.0: 'Fragmented',
                        2.0: 'Restorative',
                      };
                      return Text(
                        labels[v] ?? '',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 9),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    interval: 10,
                    getTitlesWidget: (v, _) {
                      final epochIdx = _windowStart + v.toInt();
                      final secs = epochIdx * 30;
                      return Text(
                        _formatTime(secs),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 9),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: Colors.transparent,
                  barWidth: 0,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, ___) {
                      final color = spot.y >= 2
                          ? Colors.greenAccent
                          : spot.y >= 1
                              ? Colors.orangeAccent
                              : Colors.redAccent;
                      return FlDotCirclePainter(
                        radius: 4,
                        color: color,
                        strokeWidth: 0,
                        strokeColor: Colors.transparent,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _windowControls() {
    final maxStart =
        (_epochResults.length - _windowSize).clamp(0, _epochResults.length);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: _windowStart > 0
              ? () => setState(() =>
                  _windowStart = (_windowStart - _windowSize).clamp(0, maxStart))
              : null,
        ),
        Expanded(
          child: Slider(
            value: _windowStart.toDouble(),
            min: 0,
            max: maxStart.toDouble(),
            divisions: maxStart > 0 ? maxStart : 1,
            activeColor: Theme_Colors.primary,
            inactiveColor: Colors.white24,
            onChanged: (v) => setState(() => _windowStart = v.toInt()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: _windowStart < maxStart
              ? () => setState(() =>
                  _windowStart = (_windowStart + _windowSize).clamp(0, maxStart))
              : null,
        ),
      ],
    );
  }
}