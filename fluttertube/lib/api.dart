import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertube/models/video.dart';

const API_KEY = "AIzaSyDucVZqKcMLfNIRraVLCuZJBgew2jY0iH0";

const _maxResults = 10;


class Api {

  String _search;
  String _nextToken;

  List<Video> decode(http.Response response){
    if(response.statusCode == 200){
      var decoded = json.decode(response.body);
      _nextToken = decoded["nextPageToken"];
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

    _search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=$_maxResults"
    );
    return decode(response);
  }

  Future<List<Video>> nextPage() async {

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=$_maxResults&pageToken=$_nextToken"
    );
    return decode(response);
  }
}