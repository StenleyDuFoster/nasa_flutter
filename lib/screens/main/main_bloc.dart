import 'dart:async';

import 'package:flutter_nasa_app/entitys/apod_entity.dart';
import 'package:flutter_nasa_app/screens/main/main_repository.dart';

class MainBloc {

  final _mainRepository = MainRepository();
  final _streamController = StreamController<NewState>();

  Stream<NewState> get items => _streamController.stream;

  Future loadData() async {
    _streamController.sink.add(NewState._loading());

    final response = await _mainRepository.getPictureOfTheDay();

    if (response.data != null) {
      _streamController.sink.add(NewState._data(response.data!));
    } else {
      _streamController.sink.add(NewState());
    }
  }

  void dispose() {
    _streamController.close();
  }

}

class NewState {
  NewState();
  factory NewState._data(ApodEntity apodEntity) = MainDataState;
  factory NewState._loading() = MainLoadingState;
}

class NewInitState extends NewState {}

class MainLoadingState extends NewState {
  MainLoadingState();
}

class MainDataState extends NewState {
  final ApodEntity apodEntity;

  MainDataState(this.apodEntity);
}