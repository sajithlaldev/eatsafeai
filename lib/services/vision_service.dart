import 'dart:convert';
import 'package:http/http.dart' as http;

class VisionService {
  static const String baseUrl = 'http://localhost:8000/ai'; // Replace with your actual API endpoint

  Future<Map<String, dynamic>> analyzeImage(String imagePath, String query) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/vision-gemini'));
      
      // Add the image file
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));
      
      // Add the query
      request.fields['query'] = 'Analyze these food ingredients and tell me if they are safe for consumption. List any potential allergens or harmful ingredients. Also mention their side effects if any: $query';

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
