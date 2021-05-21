import 'package:flutter_nasa_app/entitys/request_error.dart';

class EntityState<T> {

  EntityState(
      this.data,
      this.error
      );

  T? data;
  RequestError? error;

}