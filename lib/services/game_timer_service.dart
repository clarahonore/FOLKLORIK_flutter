import 'dart:async';

class GameTimerService {
  static final GameTimerService _instance = GameTimerService._internal();
  factory GameTimerService() => _instance;
  GameTimerService._internal();

  final int _initialMinutes = 45;
  late Duration remainingTime;
  Timer? _timer;
  bool isRunning = false;

  final List<void Function(Duration)> _listeners = [];

  void start() {
    if (isRunning) return;
    remainingTime = Duration(minutes: _initialMinutes);
    _startTicker();
  }

  void _startTicker() {
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        remainingTime -= const Duration(seconds: 1);
        _notifyListeners();
      } else {
        timer.cancel();
        isRunning = false;
        _notifyListeners(); // 🔔 informe TimerButton que c’est fini
      }
    });
  }

  void toggle() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
    } else {
      _startTicker();
    }
  }

  // 🛑 Ajout : stop() (appelé quand le temps est fini ou manuellement)
  void stop() {
    _timer?.cancel();
    isRunning = false;
    _notifyListeners();
  }

  // 🔁 Ajout : reset() pour redémarrer le chrono
  void reset() {
    stop();
    remainingTime = Duration(minutes: _initialMinutes);
    _notifyListeners();
  }

  void addListener(void Function(Duration) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(Duration) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(remainingTime);
    }
  }

  void dispose() {
    _timer?.cancel();
    _listeners.clear();
  }
}