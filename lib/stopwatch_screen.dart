import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  int milliseconds = 0;
  List<int> lapTimes = [];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), _updateTime);
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  void _updateTime(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {
        milliseconds = _stopwatch.elapsedMilliseconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SnapStop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimerWidget(),
              const SizedBox(height: 16),
              _buildControls(),
              const SizedBox(height: 16),
              Expanded(child: _buildLapList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerWidget() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0,
                    ),
                  ),
                  child: CircularProgressIndicator(
                    value: milliseconds / 60000,
                    strokeWidth: 9,
                    backgroundColor: Colors.transparent,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 100,
                  child: Container(
                    height: 10,
                    width: 3,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 100,
                  child: Container(
                    height: 10,
                    width: 3,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 100,
                  child: Container(
                    height: 3,
                    width: 10,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 100,
                  child: Container(
                    height: 3,
                    width: 10,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _timeFormat(milliseconds),
                  style: const TextStyle(
                    fontSize: 33.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton('Start', _startTimer),
        _buildControlButton('Lap', _lapTimer),
        _buildControlButton('Reset', _resetTimer),
      ],
    );
  }

  Widget _buildControlButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(25),
      ),
      child: Text(label),
    );
  }

  Widget _buildLapList() {
    return ListView.builder(
      itemCount: lapTimes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            'Lap ${index + 1}: ${_timeFormat(lapTimes[index])}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _startTimer() {
    setState(() {
      _stopwatch.start();
      lapTimes.clear();
      milliseconds = 0;
    });
  }

  void _lapTimer() {
    setState(() {
      lapTimes.add(milliseconds);
      milliseconds = 0;
    });
  }

  void _resetTimer() {
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
      lapTimes.clear();
      milliseconds = 0;
    });
  }

  String _timeFormat(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String secondsString = (seconds % 60).toString().padLeft(2, '0');
    String minutesString = (minutes % 60).toString().padLeft(2, '0');
    String hoursString = (hours % 60).toString().padLeft(2, '0');

    return '$hoursString:$minutesString:$secondsString';
  }
}
