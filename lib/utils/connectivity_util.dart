import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityState { connected, not_connected }

class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instence = ConnectivityService._();

  final _streamController = StreamController<ConnectivityState>();

  // stream to listen connectivity changes
  Stream<ConnectivityState> get stream => _streamController.stream;

  Future<ConnectivityState> makeRequestConnectionCheck() async {
    final bool isConnected = await DataConnectionChecker().hasConnection;
    if (isConnected) {
      _streamController.sink.add(ConnectivityState.connected);
      return ConnectivityState.connected;
    } else {
      _streamController.sink.add(ConnectivityState.not_connected);
      debugPrint('No Connection. Reason:');
      debugPrint(DataConnectionChecker().lastTryResults.toString());
      return ConnectivityState.not_connected;
    }
  }

  dispose() {
    _streamController.close();
  }
}
