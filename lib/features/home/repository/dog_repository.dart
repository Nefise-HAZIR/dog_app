import 'package:dio/dio.dart';
import 'package:dog_app/features/home/model/dog_model.dart';

class DogRepository {
  Future<List<ImmutableDog>> getBreeds() async {
    final dio = Dio();
    List<ImmutableDog> list = [];
    final response = await dio.get('https://dog.ceo/api/breeds/list/all/');
    if ((response.statusCode ?? 500) >= 300) {
      throw Exception('network error');
    }

    final data = response.data;
    final breeds = data['message'].keys.toList() as List<String>;

    final images = await Future.wait(
      breeds.map((breed) async {
        final response =
            await dio.get('https://dog.ceo/api/breed/$breed/images/random');
        final data = response.data;
        return data['message'] as String;
      }),
    );

    for (var i = 0; i < breeds.length; i++) {
      list.add(ImmutableDog(name: breeds[i], imageUrl: images[i]));
    }
    return list;
  }
}
