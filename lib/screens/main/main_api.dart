import 'package:flutter_nasa_app/services/api_struct.dart';
import 'package:flutter_nasa_app/services/base_rest_client.dart';
import 'package:flutter_nasa_app/entitys/apod_entity.dart';

class MainAPI extends BaseRestClient {

  Future getPictureOfTheDay() async {

    final String url = baseUrl + Requests.pictureOfTheDay;

    var response = await sendRequest(RequestType.getRequest, url);
    final result = await parsedJson(response, ApodEntity());

    return result;
  }

}