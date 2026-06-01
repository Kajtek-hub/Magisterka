import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magisterka/api/secure_storage.dart';
import 'package:magisterka/api/test_service.dart';
import 'package:magisterka/theme.dart';

class ResultScreen extends StatefulWidget {

  const ResultScreen(this.onResultScreen,{super.key});
  final void Function() onResultScreen;

  @override
  State<ResultScreen> createState() => _ResultScreen();
}

class _ResultScreen extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['PVT', 'Go/No-Go', 'N-Back', 'Stroop', 'KSS'];

  String? _userId;
  bool _loading = true;

  // Wyniki każdego testu
  List<dynamic> _pvtResults = [];
  List<dynamic> _gonogoResults = [];
  List<dynamic> _nbackResults = [];
  List<dynamic> _stroopResults = [];
  List<dynamic> _kssResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);

    try {
      _userId = await SecureStorage.getUserId();

      if (_userId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Session expired, please log in again")),
          );
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
        return;
      }

      final results = await Future.wait([
        TestService.getPVTResults(_userId!),
        TestService.getGoNoGoResults(_userId!),
        TestService.getNBackResults(_userId!),
        TestService.getStroopResults(_userId!),
        TestService.getKSSResults(_userId!),
      ]);

      setState(() {
        _pvtResults    = results[0];
        _gonogoResults = results[1];
        _nbackResults  = results[2];
        _stroopResults = results[3];
        _kssResults    = results[4];
        _loading       = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading results: $e")),
        );
      }
    }
  }

  // Formatowanie daty
  String _formatDate(String isoDate) {
    final dt = DateTime.parse(isoDate).toLocal();
    return "${dt.day.toString().padLeft(2, '0')}."
        "${dt.month.toString().padLeft(2, '0')}."
        "${dt.year}  "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  //Pojedyncza karta wyniku
  Widget _resultCard(Map<String, dynamic> item, List<Widget> rows) {
    final date = _formatDate(item['createdAt'] as String);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ...rows,
        ],
      ),
    );
  }

  // Wiersz danych w karcie
  Widget _dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Pusta lista 
  Widget _emptyState(String testName) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, color: Colors.white38, size: 64),
          const SizedBox(height: 16),
          Text(
            "No $testName results yet",
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Listy dla każdego testu 

  Widget _pvtList() {
    if (_pvtResults.isEmpty) return _emptyState("PVT");
    return ListView.builder(
      itemCount: _pvtResults.length,
      itemBuilder: (_, i) {
        final item = _pvtResults[i] as Map<String, dynamic>;
        final r = item['results'] as Map<String, dynamic>;
        return _resultCard(item, [
          _dataRow("Reaction time", "${r['reactionTime']} ms"),
        ]);
      },
    );
  }

  Widget _gonogoList() {
    if (_gonogoResults.isEmpty) return _emptyState("Go/No-Go");
    return ListView.builder(
      itemCount: _gonogoResults.length,
      itemBuilder: (_, i) {
        final item = _gonogoResults[i] as Map<String, dynamic>;
        final r = item['results'] as Map<String, dynamic>;
        return _resultCard(item, [
          _dataRow("Hits",               "${r['hits']}"),
          _dataRow("Misses",             "${r['misses']}"),
          _dataRow("False alarms",       "${r['falseAlarms']}"),
          _dataRow("Correct rejections", "${r['correctRejections']}"),
        ]);
      },
    );
  }

  Widget _nbackList() {
    if (_nbackResults.isEmpty) return _emptyState("N-Back");
    return ListView.builder(
      itemCount: _nbackResults.length,
      itemBuilder: (_, i) {
        final item = _nbackResults[i] as Map<String, dynamic>;
        final r = item['results'] as Map<String, dynamic>;
        return _resultCard(item, [
          _dataRow("Hits",         "${r['hits']}"),
          _dataRow("Misses",       "${r['misses']}"),
          _dataRow("False alarms", "${r['falseAlarms']}"),
        ]);
      },
    );
  }

  Widget _stroopList() {
    if (_stroopResults.isEmpty) return _emptyState("Stroop");
    return ListView.builder(
      itemCount: _stroopResults.length,
      itemBuilder: (_, i) {
        final item = _stroopResults[i] as Map<String, dynamic>;
        final r = item['results'] as Map<String, dynamic>;
        final correct   = r['correct']   as int;
        final incorrect = r['incorrect'] as int;
        final total     = correct + incorrect;
        final pct       = total > 0
            ? (correct / total * 100).toStringAsFixed(1)
            : "0.0";
        return _resultCard(item, [
          _dataRow("Correct",   "$correct"),
          _dataRow("Incorrect", "$incorrect"),
          _dataRow("Accuracy",  "$pct%"),
        ]);
      },
    );
  }

  Widget _kssList() {
    if (_kssResults.isEmpty) return _emptyState("KSS");

    const labels = {
      1: "Extremely alert",
      2: "",
      3: "Alert",
      4: "",
      5: "Neither alert nor sleepy",
      6: "",
      7: "Sleepy, but resisting",
      8: "",
      9: "Extremely sleepy",
    };

    return ListView.builder(
      itemCount: _kssResults.length,
      itemBuilder: (_, i) {
        final item  = _kssResults[i] as Map<String, dynamic>;
        final r     = item['results'] as Map<String, dynamic>;
        final level = r['sleepinessLevel'] as int;
        final label = labels[level] ?? "";
        return _resultCard(item, [
          _dataRow("Sleepiness level", "$level / 9"),
          if (label.isNotEmpty)
            _dataRow("Description", label),
        ]);
      },
    );
  }

  // BUILD 

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

              // Nagłówek 
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
                        "Your Results",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Przycisk odświeżania
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadAll,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // TabBar 
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                indicatorColor: Theme_Colors.primary,
                
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),

              const SizedBox(height: 8),

              //Zawartość 
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _pvtList(),
                          _gonogoList(),
                          _nbackList(),
                          _stroopList(),
                          _kssList(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}