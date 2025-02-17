import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../../../models/jobpostings/jobpostings_model.dart';
import '../../../models/jobpostings_application/jobpostings_application_model.dart';


class jobpostings_api {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  Future<List<JobPosting>> getJobPostingsList({int page = 1, int size = 10}) async {
    print(baseUrl);
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobposting/list?page=$page&size=$size'));

      // 서버 응답이 UTF-8로 잘 디코딩되어 있지 않으면 수동으로 디코딩
      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes); // 응답을 UTF-8로 디코딩
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
        print("----");
        print(jsonResponse);
        final List<dynamic> data = jsonResponse['dtoList']; // PageResponseDTO의 content
        print("-----2");

        return data.map((item) => JobPosting.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load workplace list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching workplace list: $e');
    }
  }

  Future<List<JobPostingDetail>> getJobPostingsDetail(int jpno) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobposting/detail/$jpno'));

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);

        print(jsonResponse);
        final JobPostingDetail jobDetail = JobPostingDetail.fromJson(jsonResponse);

        return [jobDetail];
      } else {
        throw Exception('Failed to load job posting detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching job posting detail: $e');
      return []; // **오류 발생 시 빈 리스트 반환**
    }
  }

  Future<void> addApplicationPostings(JobPostingsApplication application) async {

    final url = Uri.parse('$baseUrl/jobpostingapplication/add');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // JSON 헤더 추가
      body: jsonEncode(application.toJson()), // 모델을 JSON으로 변환하여 body에 넣기
    );

  }


}