import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/community_screen.dart';
import 'package:myapp/news_screen.dart';
import 'package:myapp/price_tracker_screen.dart';
import 'package:myapp/schemes_screen.dart';
import 'package:myapp/services/notification_service.dart';

import 'irrigation_control_card.dart';
import 'water_tank_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL: "https://agrosmart-f1233-default-rtdb.asia-southeast1.firebasedatabase.app/",
  ).ref();

  StreamSubscription<DatabaseEvent>? _sensorSubscription;
  final NotificationService _notificationService = NotificationService();

  String? _selectedCrop;
  String _irrigationSuggestion = "Select a crop to get a suggestion.";

  // State variables for sensor and crop data
  Map<dynamic, dynamic>? _crops;
  double _waterLevel = 0.0;
  num _temperature = 0;
  num _humidity = 0;
  String _status = 'N/A';

  // Simulation variables
  Timer? _simulationTimer;
  double _simulatedSoilMoisture = 70.0;
  bool _isValveOpen = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _listenToSensorData();
    _startSimulation();
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadInitialData() async {
    await _checkAndCreateCropsData();
    final snapshot = await _database.child('crops').get();
    if (mounted && snapshot.exists) {
      setState(() {
        _crops = snapshot.value as Map<dynamic, dynamic>?;
        _isLoading = false;
      });
    }
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          if (_isValveOpen) {
            _simulatedSoilMoisture = min(100, _simulatedSoilMoisture + 2);
          } else {
            _simulatedSoilMoisture = max(0, _simulatedSoilMoisture - 1);
          }
        });
      }
    });
  }

  void _listenToSensorData() {
    _sensorSubscription = _database.child('SensorData').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && mounted) {
        final distance = data['Distance'] ?? 0;
        final double waterLevel = (1.0 - (distance / 30.0)).clamp(0.0, 1.0) * 100.0;
        
        setState(() {
          _waterLevel = waterLevel;
          _temperature = data['Temperature'] ?? 0;
          _humidity = data['Humidity'] ?? 0;
          _status = data['status'] ?? 'N/A';
        });

        if (waterLevel < 20) {
          _notificationService.showNotification(
            'Low Water Level',
            'Water tank level is critically low: ${waterLevel.toStringAsFixed(1)}%',
          );
        }
      }
    });
  }

  Future<void> _checkAndCreateCropsData() async {
    final snapshot = await _database.child('crops').get();
    if (!snapshot.exists || snapshot.value == null) {
      await _database.child('crops').set({
        "Tomato": {
          "minMoisture": 60,
          "maxMoisture": 80,
          "minTemp": 21,
          "maxTemp": 29,
          "watering_frequency": "Every 2-3 days"
        },
        "Lettuce": {
          "minMoisture": 50,
          "maxMoisture": 70,
          "minTemp": 15,
          "maxTemp": 22,
          "watering_frequency": "Every 1-2 days"
        },
        "Bell Pepper": {
          "minMoisture": 55,
          "maxMoisture": 75,
          "minTemp": 23,
          "maxTemp": 32,
          "watering_frequency": "Every 2-3 days"
        }
      });
    }
  }

  void _updateIrrigationSuggestion() {
    if (_crops != null && _selectedCrop != null) {
      final selectedCropData = _crops![_selectedCrop] as Map<dynamic, dynamic>?;
      if (selectedCropData != null) {
        final sensors = {
          'Temperature': _temperature,
          'Humidity': _humidity,
        };
        _getIrrigationSuggestion(sensors, selectedCropData);
      }
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_crops != null) _buildCropSelector(_crops!),
            const SizedBox(height: 16),
            _buildSuggestionCard(),
            const SizedBox(height: 16),
            IrrigationControlCard(
              onValveToggled: (isOpen) {
                if (mounted) {
                  setState(() {
                    _isValveOpen = isOpen;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            WaterTankCard(waterLevel: _waterLevel, tankCapacity: 1000),
            const SizedBox(height: 16),
            _buildSensorCard(
              icon: Icons.opacity,
              title: 'soil_moisture'.tr(),
              value: '${_simulatedSoilMoisture.toStringAsFixed(1)}%',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildSensorCard(
              icon: Icons.thermostat,
              title: 'temp_and_humidity'.tr(),
              value: '$_temperature°C / $_humidity%',
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildStatusCard(_status),
            const SizedBox(height: 16),
            _buildWeatherCard(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      _buildDashboardContent(),
      const PriceTrackerScreen(),
      const CommunityScreen(),
      const NewsScreen(),
      const SchemesScreen(),
    ];

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('dashboard_title').tr()),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('fetching_data').tr(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('dashboard_title').tr()),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Prices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Schemes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme
            .of(context)
            .colorScheme
            .primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCropSelector(Map<dynamic, dynamic> crops) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: DropdownButton<String>(
          hint: const Text('select_crop').tr(),
          value: _selectedCrop,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          items: crops.keys.map<DropdownMenuItem<String>>((key) {
            return DropdownMenuItem<String>(
              value: key as String,
              child: Text(key),
            );
          }).toList(),
          onChanged: (newValue) {
            if (mounted) {
              setState(() {
                _selectedCrop = newValue;
                _updateIrrigationSuggestion();
              });
            }
          },
        ),
      ),
    );
  }

  void _getIrrigationSuggestion(
      Map<dynamic, dynamic> sensors, Map<dynamic, dynamic> crop) {
    final moisture = _simulatedSoilMoisture;
    final temp = sensors['Temperature'];

    if (temp is! num) {
      _irrigationSuggestion = "Waiting for valid sensor data.";
      return;
    }

    final minMoisture = crop['minMoisture'] as num;
    final maxMoisture = crop['maxMoisture'] as num;
    final minTemp = crop['minTemp'] as num;
    final maxTemp = crop['maxTemp'] as num;

    if (moisture < minMoisture) {
      _irrigationSuggestion =
          "Water needed. Soil moisture is below the ideal range.";
    } else if (moisture > maxMoisture) {
      _irrigationSuggestion =
          "Too much water. Soil moisture is above the ideal range.";
    } else if (temp < minTemp) {
      _irrigationSuggestion = "Conditions are too cold for this crop.";
    } else if (temp > maxTemp) {
      _irrigationSuggestion = "Conditions are too hot for this crop.";
    } else {
      _irrigationSuggestion =
          "Conditions are ideal. No irrigation needed.";
    }
  }

  Widget _buildSuggestionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, size: 40, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _irrigationSuggestion,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.yellow[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 40, color: Colors.amber),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                status,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'weather_forecast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherDay('Mon', Icons.wb_sunny, '30°'),
                _buildWeatherDay('Tue', Icons.cloud, '28°'),
                _buildWeatherDay('Wed', Icons.grain, '26°'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildWeatherDay(String day, IconData icon, String temp) {
    return Column(
      children: [
        Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(temp),
      ],
    );
  }
}
