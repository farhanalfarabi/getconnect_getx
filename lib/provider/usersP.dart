import 'package:get/get.dart';
import 'dart:convert';

class UserProvider extends GetConnect {
  final url =
      "https://getconnect-project-baf0a-default-rtdb.asia-southeast1.firebasedatabase.app/";
  // Get request
  Future<Response> getData() {
    return get('${url}users.json').then((response) {
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to fetch data from the database');
      }
    }).catchError((error) {
      throw Exception('Error: $error');
    });
  }


  // Post request
  Future<Response> postData(String name, String email, String phone) {
    final body = json.encode({"name": name, "email": email, "phone": phone});
    return post(url + 'users.json', body);
  }

  // patch request
  Future<Response> editData(
      String id, String name, String email, String phone) {
    final body = json.encode({
      "name": name,
      "email": email,
      "phone": phone,
    });
    return patch(url + 'users/$id.json', body);
  }

  // Delete request
  Future<Response> deleteData(String id) => delete(url + 'users/$id.json');
}
