import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dog_app/widgets/dog_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String appName = "DogApp";
  List<dynamic>? images = [];
  dynamic dogName;
  @override
  void initState() {
    super.initState();
    getDogs();
  }

  void getDogs() async {
    final data = await fetchDogs();
    setState(() {
      images = data.values.toList();
    });
  }

  Future<Map<String, dynamic>> fetchDogs() async {
    final dio = Dio();
    final response = await dio.get('https://dog.ceo/api/breeds/list/all/');
    if (response.statusCode == 200) {
      final data = jsonDecode(jsonEncode(response.data));

      final breeds = data['message'].keys.toList();
      dogName = breeds;
      final images = await Future.wait(
        breeds.map<Future<dynamic>>((breeds) async {
          final response =
              await dio.get("https://dog.ceo/api/breed/$breeds/images/random");
          final data = jsonDecode(jsonEncode(response.data));
          return data['message'];
        }),
      );
      return Map.fromIterables(breeds, images);
    } else {
      throw Exception('Failed to fetch dog breeds');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            appName,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
          itemCount: images?.length,
          itemBuilder: (context, index) {
            if (index % 2 == 0) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DogSection(
                    images: images,
                    index: index,
                    bred: dogName[index],
                  ),
                  DogSection(
                    images: images,
                    index: index + 1,
                    bred: dogName[index + 1],
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
