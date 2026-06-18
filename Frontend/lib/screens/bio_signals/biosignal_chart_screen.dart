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
    _tabController = TabController(length: 2, vsync: this); // ← 2 zakładki
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

  // Filtruj nagrania po typie urządzenia
  List<dynamic> get _eegRecordings =>
      _recordings.where((r) => r['deviceType'] == 'BITalino').toList();

  List<dynamic> get _ecgRecordings =>
      _recordings.where((r) => r['deviceType'] == 'Movesense').toList();

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

              // ── Zakładki EEG / EKG ───────────────────
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                indicatorColor: Theme_Colors.primary,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.psychology),
                    text: "EEG — BITalino",
                  ),
                  Tab(
                    icon: Icon(Icons.favorite),
                    text: "EKG — Movesense",
                  ),
                ],
              ),

              Expanded(
                child: _loadingList
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _recordingsList(_eegRecordings, isMovesense: false),
                          _recordingsList(_ecgRecordings, isMovesense: true),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recordingsList(List<dynamic> recordings, {required bool isMovesense}) {
    if (recordings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isMovesense ? Icons.favorite_outline : Icons.psychology_outlined,
              color: Colors.white24,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              isMovesense
                  ? "No Movesense recordings yet"
                  : "No BITalino recordings yet",
              style: const TextStyle(color: Colors.white54, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              "Upload a recording through\nthe recording screen",
              style: const TextStyle(color: Colors.white38, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recordings.length,
      itemBuilder: (_, i) {
        final r = recordings[i] as Map<String, dynamic>;
        final date = DateTime.parse(r['recordedAt']).toLocal();
        final dateStr =
            "${date.day.toString().padLeft(2, '0')}."
            "${date.month.toString().padLeft(2, '0')}."
            "${date.year}  "
            "${date.hour.toString().padLeft(2, '0')}:"
            "${date.minute.toString().padLeft(2, '0')}";
        final hasEpochs = r['epochFeaturesJson'] != null;
        final color = isMovesense ? Colors.redAccent : Colors.blueAccent;

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
                  Row(
                    children: [
                      Icon(
                        isMovesense ? Icons.favorite : Icons.psychology,
                        color: color,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        r['deviceType'] as String,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // ── Metryki ───────────────────────────────
              if (isMovesense) ...[
                if (r['heartRate'] != null)
                  _metricRow("Heart Rate", "${r['heartRate']} bpm"),
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

              // ── Przyciski ─────────────────────────────
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
                  // Przycisk Analyze tylko dla BITalino z epochFeaturesJson
                  if (!isMovesense && hasEpochs) ...[
                    const SizedBox(width: 8),
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