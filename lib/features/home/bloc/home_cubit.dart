import 'package:dog_app/features/home/bloc/home_state.dart';
import 'package:dog_app/features/home/repository/dog_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(status: HomeStatus.initial));

  final DogRepository _dogRepository = DogRepository();
  Future<void> getBreeds() async {
    emit(
      const HomeState(status: HomeStatus.loading),
    );
    try {
      final breeds = await _dogRepository.getBreeds();
      emit(
        HomeState(status: HomeStatus.done, dogs: breeds),
      );
    } catch (e) {
      emit(
        HomeState(
          status: HomeStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
