import 'dart:io';
import 'package:dio/dio.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/features/scanner/data/disease_response_model.dart';

class AiService {
  static Future<Map<String, dynamic>> detectDisease(File image) async {
    try {
      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
      });

      var response = await DioSingleton.instance.dio.post(
        Endpoints.detectDisease,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': DiseaseDetectionResponse.fromJson(response.data),
        };
      } else {
        return {
          'success': false,
          'message': response.statusMessage ?? 'Something went wrong',
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage =
            e.response?.data['message'] ?? e.message ?? 'Network error';
      } else if (e.response?.statusMessage != null) {
        errorMessage =
            '${e.response?.statusCode}: ${e.response?.statusMessage}';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
