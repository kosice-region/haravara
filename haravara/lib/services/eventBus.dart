import 'dart:async';

class EventBus {
  // Создаем инстанс EventBus
  static final EventBus _instance = EventBus._internal();

  // Приватный конструктор
  EventBus._internal();

  // Получаем инстанс EventBus
  factory EventBus() => _instance;

  final _streamController = StreamController<dynamic>.broadcast();

  void sendEvent(dynamic event) {
    _streamController.sink.add(event);
  }

  Stream<dynamic> on<T>() {
    return _streamController.stream.where((event) => event is T);
  }

  void dispose() {
    _streamController.close();
  }
}
