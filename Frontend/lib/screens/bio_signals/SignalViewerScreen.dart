import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magisterka/api/biosignal_service.dart';
import 'package:magisterka/api/secure_storage.dart';
import 'package:magisterka/theme.dart';

class SignalViewerScreen extends StatefulWidget {
  final String? preloadedRecordingId;
  final String? preloadedRecordingName;
  
  const SignalViewerScreen({
    super.key,
    this.preloadedRecordingId,
    this.preloadedRecordingName,
  });

  @override
  State<SignalViewerScreen> createState() => _SignalViewerScreenState();
}

class _SignalViewerScreenState extends State<SignalViewerScreen> {
  bool _loadingList = true;
  bool _loadingSignal = false;
  List<dynamic> _recordings = [];
  List<dynamic> _allSamples = [];
  String? _selectedId;
  String _selectedName = '';
  int _currentEpoch = 0;
  int _totalEpochs = 0;
  final _epochInputController = TextEditingController();

  static const int _samplesPerEpoch = 3000; // 30s × 100Hz


    @override
  void dispose() {
    _epochInputController.dispose();
    
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadRecordings().then((_) {
      if (widget.preloadedRecordingId != null) {
        _loadSignal(
          widget.preloadedRecordingId!,
          widget.preloadedRecordingName ?? '',
        );
      }
    });
  }

  Future<void> _loadRecordings() async {
    try {
      final userId = await SecureStorage.getUserId();
      if (userId == null) return;
      final data = await BioSignalService.getRecordings(userId);
      setState(() {
        _recordings = data;
        _loadingList = false;
      });
    } catch (e) {
      setState(() => _loadingList = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Błąd: $e")),
        );
      }
    }
  }

  Future<void> _loadSignal(String id, String fileName) async {
    setState(() => _loadingSignal = true);

    try {
      final raw = await BioSignalService.getRawSamples(id);
      final samples = (raw['samples'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      setState(() {
        _selectedId   = id;
        _selectedName = fileName;
        _allSamples   = samples;
        // ceil żeby ostatnia niepełna epoka też się liczyła
        _totalEpochs  = (samples.length / _samplesPerEpoch).ceil();
        _currentEpoch = 0;
        _loadingSignal = false;
      });
    } catch (e) {
      setState(() => _loadingSignal = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Błąd ładowania: $e")),
        );
      }
    }
  }

  // Próbki aktualnej epoki — ostatnia może być niepełna
  List<dynamic> get _currentSamples {
    final start = _currentEpoch * _samplesPerEpoch;
    final end = (start + _samplesPerEpoch).clamp(0, _allSamples.length);
    return _allSamples.sublist(start, end);
  }

  // Rzeczywisty czas trwania aktualnej epoki w sekundach
  int get _currentEpochDuration {
    return (_currentSamples.length / 100).ceil();
  }

  bool get _isLastEpochPartial =>
      _currentEpoch == _totalEpochs - 1 &&
      _currentSamples.length < _samplesPerEpoch;

  // Zastąp metodę _formatTime i dodaj nową _formatSeconds
  String _formatSeconds(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    return h > 0
        ? "${h.toString().padLeft(2, '0')}:"
          "${m.toString().padLeft(2, '0')}:"
          "${s.toString().padLeft(2, '0')}"
        : "${m.toString().padLeft(2, '0')}:"
          "${s.toString().padLeft(2, '0')}";
  }

  String _formatTime(int epochIndex) {
    return _formatSeconds(epochIndex * 30);
  }

  // Czas końca aktualnej epoki — zawsze dokładny
  String get _epochEndTime {
    final startSeconds = _currentEpoch * 30;
    final endSeconds   = startSeconds + _currentEpochDuration;
    return _formatSeconds(endSeconds);
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
                        "Signal Viewer",
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
              const SizedBox(height: 12),
              Expanded(
                child: _loadingList
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Lista nagrań — ukryj jeśli załadowano z zewnątrz
                            if (widget.preloadedRecordingId == null)
                              _recordingPicker(),
                            if (_loadingSignal)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                              // W Column w SingleChildScrollView:
                              else if (_selectedId != null) ...[
                                const SizedBox(height: 12),
                                _epochHeader(),
                                const SizedBox(height: 12),
                                _signalChart(),
                                const SizedBox(height: 12),
                                _navigationControls(),
                                const SizedBox(height: 12),
                                _epochJumpField(),   // ← DODAJ
                                const SizedBox(height: 12),
                                _timelineSlider(),
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
          "Brak nagrań. Wgraj nagranie przez ekran nagrywania.",
          style: TextStyle(color: Colors.white54),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Wybierz nagranie:",
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 8),
        ..._recordings.map((r) {
          final date = DateTime.parse(r['recordedAt']).toLocal();
          final dateStr =
              "${date.day.toString().padLeft(2, '0')}."
              "${date.month.toString().padLeft(2, '0')}."
              "${date.year}  "
              "${date.hour.toString().padLeft(2, '0')}:"
              "${date.minute.toString().padLeft(2, '0')}";
          final isSelected = _selectedId == r['id'];
          final deviceType = r['deviceType'] as String;
          final color = deviceType == 'Movesense'
              ? Colors.redAccent
              : Colors.blueAccent;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white24,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ListTile(
              leading: Icon(
                deviceType == 'Movesense'
                    ? Icons.favorite
                    : Icons.psychology,
                color: color,
              ),
              title: Text(dateStr,
                  style:
                      const TextStyle(color: Colors.white, fontSize: 13)),
              subtitle: Text(
                "$deviceType — ${r['fileName']}",
                style:
                    const TextStyle(color: Colors.white54, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: ElevatedButton(
                onPressed: isSelected
                    ? null
                    : () => _loadSignal(
                          r['id'] as String,
                          r['fileName'] as String,
                        ),
                child: Text(isSelected ? "Loaded" : "Load"),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _epochHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _selectedName,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Epoka ${_currentEpoch + 1} / $_totalEpochs",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          // Pokaż czas — przy niepełnej ostatniej epoce zaznacz pomarańczowo
          Text(
            _isLastEpochPartial
                ? "${_currentEpochDuration}s ⚠"
                : _formatTime(_currentEpoch),
            style: TextStyle(
              color: _isLastEpochPartial
                  ? Colors.orangeAccent
                  : Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _signalChart() {
    final samples = _currentSamples;
    if (samples.isEmpty) return const SizedBox();

    final step = (samples.length / 300).ceil().clamp(1, 100);
    final spots = samples
        .asMap()
        .entries
        .where((e) => e.key % step == 0)
        .map((e) => FlSpot(
              (e.key / 100).toDouble(),
              (e.value['value'] as num).toDouble(),
            ))
        .toList();

    final values = spots.map((s) => s.y).toList();
    final minY = values.reduce((a, b) => a < b ? a : b) - 5;
    final maxY = values.reduce((a, b) => a > b ? a : b) + 5;

    // Kolor zależny od urządzenia
    final isMovesense = _selectedName.toLowerCase().contains('movesense');
    final lineColor = isMovesense ? Colors.redAccent : Colors.blueAccent;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info o niepełnej epoce
          if (_isLastEpochPartial)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Ostatni fragment: ${_currentEpochDuration}s "
                "(niepełna epoka)",
                style: const TextStyle(
                    color: Colors.orangeAccent, fontSize: 11),
              ),
            ),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: Colors.white12, strokeWidth: 0.5),
                  getDrawingVerticalLine: (_) =>
                      FlLine(color: Colors.white12, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white24)),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text(
                      "Czas (s)",
                      style:
                          TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 5,
                      getTitlesWidget: (v, _) => Text(
                        "${v.toInt()}s",
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 9),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (v, _) => Text(
                        v.toInt().toString(),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 9),
                      ),
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
                    color: lineColor,
                    barWidth: 1,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.first_page, color: Colors.white),
          onPressed: _currentEpoch > 0
              ? () => setState(() => _currentEpoch = 0)
              : null,
        ),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: _currentEpoch > 0
              ? () => setState(() => _currentEpoch--)
              : null,
        ),
        const SizedBox(width: 8),
       
        Text(
          "${_formatTime(_currentEpoch)} – $_epochEndTime",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: _currentEpoch < _totalEpochs - 1
              ? () => setState(() => _currentEpoch++)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.last_page, color: Colors.white),
          onPressed: _currentEpoch < _totalEpochs - 1
              ? () => setState(() => _currentEpoch = _totalEpochs - 1)
              : null,
        ),
      ],
    );
  }

  void _jumpToEpoch(String input) {
  final number = int.tryParse(input.trim());

  if (number == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Podaj poprawną liczbę")),
    );
    return;
  }

  if (number < 1 || number > _totalEpochs) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Numer epoki musi być między 1 a $_totalEpochs",
        ),
      ),
    );
    return;
  }

  setState(() => _currentEpoch = number - 1);
  _epochInputController.clear();
  FocusScope.of(context).unfocus();
  }

  Widget _epochJumpField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _epochInputController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Przejdź do epoki (1 – $_totalEpochs)",
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
              ),
              onSubmitted: _jumpToEpoch, // ← Enter na klawiaturze też działa
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _jumpToEpoch(_epochInputController.text),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Idź"),
          ),
        ],
      ),
    );
  }

  Widget _timelineSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("00:00",
                style: TextStyle(color: Colors.white54, fontSize: 11)),
            const Text("Pozycja w nagraniu",
                style: TextStyle(color: Colors.white54, fontSize: 11)),
            Text(
              _formatTime(_totalEpochs),
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
        Slider(
          value: _currentEpoch.toDouble(),
          min: 0,
          max: (_totalEpochs - 1).toDouble().clamp(0, double.infinity),
          divisions: _totalEpochs > 1 ? _totalEpochs - 1 : 1,
          activeColor: Colors.blueAccent,
          inactiveColor: Colors.white24,
          onChanged: (v) => setState(() => _currentEpoch = v.toInt()),
        ),
      ],
    );
  }
}