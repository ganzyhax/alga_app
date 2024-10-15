import 'dart:developer';

import 'package:alga_app/app/utils/local_utils.dart';
import 'package:alga_app/constants/app_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static Future<dynamic> get(String endpoint, {String? lToken}) async {
    String localLang = await LocalUtils.getLanguage();
    final url = Uri.parse(AppConstant.baseUrl.toString() + endpoint);
    Future<http.Response> makeGetRequest() async {
      String token = await LocalUtils.getAccessToken() ?? '';

      return await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'appLanguage': localLang,
          'Authorization':
              (lToken == null) ? 'Bearer $token' : 'Bearer $lToken',
        },
      );
    }

    http.Response response = await makeGetRequest();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'data': jsonDecode(response.body),
        'status': response.statusCode.toString(),
      };
    }

    if (response.statusCode == 401) {
      await _refreshToken(response);
      response = await makeGetRequest();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'status': response.statusCode.toString(),
        };
      } else {
        return {
          'success': false,
          'data': jsonDecode(response.body),
          'status': response.statusCode.toString(),
        };
      }
    }

    return {
      'success': false,
      'data': jsonDecode(response.body),
      'status': response.statusCode.toString(),
    };
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      {String? lToken}) async {
    String localLang = await LocalUtils.getLanguage();

    final url = Uri.parse(AppConstant.baseUrl.toString() + endpoint);
    Future<http.Response> makePostRequest() async {
      String token = await LocalUtils.getAccessToken() ?? '';

      return await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'appLanguage': localLang,
          'Authorization':
              (lToken == null) ? 'Bearer $token' : 'Bearer $lToken',
          // 'Mobapp-Version': mbVer
        },
        body: jsonEncode(data),
      );
    }

    http.Response response = await makePostRequest();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }
    if (response.statusCode == 401) {
      await _refreshToken(response);
      response = await makePostRequest();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'data': jsonDecode(response.body)};
      }
    }
    return {'success': false, 'data': jsonDecode(response.body)};
  }

  static Future<dynamic> postUnAuth(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    String localLang = await LocalUtils.getLanguage();
    // String mbVer = await AuthUtils.getIndexMobileVersion();
    final url = Uri.parse(AppConstant.baseUrl.toString() + endpoint);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'appLanguage': localLang,
        // 'Mobapp-Version': mbVer
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {'success': false, 'data': jsonDecode(response.body)};
    }
  }

  static Future<dynamic> getUnAuth(String endpoint) async {
    String localLang = await LocalUtils.getLanguage();
    final url = Uri.parse(AppConstant.baseUrl.toString() + endpoint);
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'appLanguage': localLang,
      // 'Mobapp-Version': mbVer
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {'success': false, 'data': jsonDecode(response.body)};
    }
  }

  static Future<void> _refreshToken(http.Response response) async {
    final refreshToken = await LocalUtils.getRefreshToken();
    final url = Uri.parse(AppConstant.baseUrl + 'api/auth/refreshAccessToken');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await LocalUtils.setAccessToken(data['accessToken']);
    } else {
      print('Failed to refresh token');
    }
  }
}
