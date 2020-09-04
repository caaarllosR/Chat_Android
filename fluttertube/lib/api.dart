import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/video.dart';
const API_KEY = "AIzaSyDucVZqKcMLfNIRraVLCuZJBgew2jY0iH0";

const _maxResults = 10;


class Api {

  List<Video> decode(http.Response response){

    if(response.statusCode == 200){
      var decoded = json.decode(response.body);
      List<Video> videos = decoded["items"].map<Video>(
          (map){
            return Video.fromJson(map);
          }
      ).toList();

      return videos;
    }else {
      throw Exception("Failed to load videos");
    }
  }

  Future<List<Video>> search(String search) async {

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=$_maxResults"
    );
    return decode(response);
  }

}