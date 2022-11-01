import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YaoJob {
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  const YaoJob(
    this.title,
    this.description,
    this.latitude,
    this.longitude,
  );

  toJson() {
    return {
      "title": title,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}

List<YaoJob> _JobListFromJson(String body) {
  final jsonData = jsonDecode(body);
  List<YaoJob> jobs = [];
  if (!jsonData.containsKey('result')) {
    return jobs;
  }
  for (final item in jsonData['result']) {
    jobs.add(YaoJob(item['title'], item['description'], item['latitude'],
        item['longitude']));
  }
  return jobs;
}

Future<List<YaoJob>> fetchYaoJobs() async {
  final response =
      await http.get(Uri.parse('http://ouroborothon.com:8000/yao_job/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return _JobListFromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load jobs');
  }
}

Future<void> createYaoJobs(YaoJob yaoJob) async {
  final response = await http.post(
    Uri.parse('http://ouroborothon.com:8000/yao_job/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(yaoJob.toJson()),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load jobs');
  }
}
