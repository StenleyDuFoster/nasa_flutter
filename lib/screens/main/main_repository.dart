import 'package:flutter_nasa_app/screens/main/main_api.dart';
import 'package:flutter_nasa_app/entitys/apod_entity.dart';
import 'package:flutter_nasa_app/entitys/entity_state.dart';
import 'package:flutter_nasa_app/entitys/request_error.dart';
import 'package:flutter_nasa_app/utils/connectivity_util.dart';

class MainRepository {

  final api = MainAPI();

  Future<EntityState<ApodEntity>> getPictureOfTheDay() async {
    ConnectivityState connectivityState = await ConnectivityService.instence.makeRequestConnectionCheck();

    if (connectivityState == ConnectivityState.connected) {
      final data = await api.getPictureOfTheDay();
      return EntityState(data, null);
    } else {
      return EntityState(null, RequestError.ConnectionError);
    }
  }

}