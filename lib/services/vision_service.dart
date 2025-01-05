import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class VisionService {
  // static const String baseUrl =
  //     'http://localhost:8000'; // Replace with your actual API endpoint
  static const String baseUrl =
      'https://asia-south1-chatbot-kerala.cloudfunctions.net/api';

  Future<Map<String, dynamic>> analyzeImage(
      Uint8List imageBytes, String query) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/ai/vision-together'));

      // Add the image bytes
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'png'),
        ),
      );

      // Add the query
      request.fields['query'] =
          'Analyze these food ingredients and tell me if they are safe for consumption. List any potential allergens or harmful ingredients. Also mention their side effects if any. Also tell me if there are excess amount of calories and if it is healthy: $query';

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }
}
