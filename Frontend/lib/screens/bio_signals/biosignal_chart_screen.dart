import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magisterka/api/biosignal_service.dart';
import 'package:magisterka/api/secure_storage.dart';
import 'package:magisterka/screens/bio_signals/SignalViewerScreen.dart';
import 'package:magisterka/screens/bio_signals/SleepAnalysisScreen.dart';
import 'package:magisterka/theme.dart';

class BioSignalChartScreen extends StatefulWidget {
  const BioSignalChartScreen({super.key});

  @override
  State<BioSignalChartScreen> createState() => _BioSignalChartScreenState();
}

class _BioSignalChartScreenState extends State<BioSignalChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loadingList = true;
  List<dynamic> _recordings = [];
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadRecordings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRecordings() async {
    setState(() => _loadingList = true);
    try {
      final userId = await SecureStorage.getUserId();
      if (userId == null) return;
      final data = await BioSignalService.getRecordings(userId);
      setState(() => _recordings = data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      setState(() => _loadingList = false);
    }
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
                        "Biosignals",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadRecordings,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loadingList
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : _recordingsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recordingsList() {
    if (_recordings.isEmpty) {
      return const Center(
        child: Text("No recordings",
            style: TextStyle(color: Colors.white54, fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recordings.length,
      itemBuilder: (_, i) {
        final r = _recordings[i] as Map<String, dynamic>;
        final isMovesense = r['deviceType'] == 'Movesense';
        final date = DateTime.parse(r['recordedAt']).toLocal();
        final dateStr =
            "${date.day.toString().padLeft(2, '0')}."
            "${date.month.toString().padLeft(2, '0')}."
            "${date.year}  "
            "${date.hour.toString().padLeft(2, '0')}:"
            "${date.minute.toString().padLeft(2, '0')}";
        final hasEpochs = r['epochFeaturesJson'] != null;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _selectedId == r['id'] ? Colors.white : Colors.white24,
              width: _selectedId == r['id'] ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r['deviceType'] as String,
                    style: TextStyle(
                      color: isMovesense
                          ? Colors.redAccent
                          : Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(dateStr,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                r['fileName'] as String,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 10),

              // Metryki
              if (isMovesense) ...[
                if (r['heartRate'] != null)
                  _metricRow("HR", "${r['heartRate']} bpm"),
                if (r['hRV'] != null)
                  _metricRow("HRV (RMSSD)", "${r['hRV']} ms"),
              ] else ...[
                if (r['eegDelta'] != null)
                  _metricRow("Delta", "${r['eegDelta']}"),
                if (r['eegTheta'] != null)
                  _metricRow("Theta", "${r['eegTheta']}"),
                if (r['eegAlpha'] != null)
                  _metricRow("Alpha", "${r['eegAlpha']}"),
                if (r['eegBeta'] != null)
                  _metricRow("Beta", "${r['eegBeta']}"),
              ],

              const SizedBox(height: 10),

              // ── Dwa przyciski ─────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _selectedId = r['id'] as String);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignalViewerScreen(
                              preloadedRecordingId:   r['id']       as String,
                              preloadedRecordingName: r['fileName'] as String,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.show_chart, size: 16),
                      label: const Text("Signal"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Przycisk Analyze tylko dla BITalino z epochFeaturesJson
                  if (!isMovesense && hasEpochs)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SleepAnalysisScreen(
                                preloadedRecording: r,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bedtime, size: 16),
                        label: const Text("Analyze"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}