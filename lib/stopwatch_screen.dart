import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Stopwatch _stopwatch = Stopwatch();
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
        title: const Text('SnapStop'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimerWidget(),
              SizedBox(height: 16),
              _buildControls(),
              SizedBox(height: 16),
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
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: milliseconds / 60000,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Text(
                  _timeFormat(milliseconds),
                  style: const TextStyle(
                    fontSize: 33.0,
                    color: Colors.black,
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
        shape: CircleBorder(),
        padding: EdgeInsets.all(25),
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
              color: Colors.black,
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
