import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/models/jobpostings/jobpostings_model.dart';
import 'package:gooinpro_parttimer/services/api/jobpostingsapi/jobpostings_api.dart';
import 'package:gooinpro_parttimer/utils/navermap_util.dart';  // navermap_util 임포트

class JobPostingsPage extends StatefulWidget {
  @override
  _JobPostingsState createState() => _JobPostingsState();
}

class _JobPostingsState extends State<JobPostingsPage> {
  bool _isLoading = true; // 로딩 상태
  List<JobPosting> jobPlaceList = [];

  @override
  void initState() {
    super.initState();
    navermap_util.initializeNaverMap(); // NaverMap 초기화
    print("초기화");
    _fetchJobPosting(); // 직업 공고 가져오기
  }

  // 직업 공고 데이터를 가져오는 함수
  Future<void> _fetchJobPosting() async {
    List<JobPosting> jobList = await jobpostings_api().getJobPostingsList();
    if (mounted) {
      setState(() {
        jobPlaceList = jobList;
        _isLoading = false; // 로딩 완료
        jobList.forEach((job) {
          double? wlati = job.wlati;
          double? wlong = job.wlong;
          String? jpname = job.jpname;

          // wlati와 wlong이 null이 아닌 경우에만 addMarker 호출
          if (wlati != null && wlong != null) {
            navermap_util.addMarker(wlati, wlong, jpname ?? '직업 공고');
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Postings')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // 로딩 표시
            : Column(
          children: [
            // 지도 크기 설정
            Container(
              height: 400, // 원하는 높이 설정
              width: MediaQuery.of(context).size.width, // 화면 너비 맞추기
              child: navermap_util.buildNaverMap(), // NaverMapWidget 사용
            ),
            SizedBox(height: 20),
            // 직업 공고 목록
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 20.0,
                  columns: const [
                    DataColumn(label: Text('공고명', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('주소', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('시급', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: jobPlaceList.map((job) {
                    TextStyle fontsize = TextStyle(fontSize: 12);

                    void navigateToDetail() {
                      context.go('/jobposting/${job.jpno}');
                    }

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(job.jpname, style: fontsize),
                          onTap: navigateToDetail,
                        ),
                        DataCell(
                          Text(job.wroadAddress ?? '주소 없음', style: fontsize),
                          onTap: navigateToDetail,
                        ),
                        DataCell(
                          Text("${job.jphourlyRate}원", style: fontsize),
                          onTap: navigateToDetail,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}