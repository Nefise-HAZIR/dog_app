import 'package:dog_app/features/home/bloc/home_cubit.dart';
import 'package:dog_app/features/home/bloc/home_state.dart';
import 'package:dog_app/features/home/model/dog_model.dart';
import 'package:dog_app/widgets/dog_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final String appName = "DogApp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _AppBar(appName: appName),
        body: BlocProvider(
          create: (context) => HomeCubit()..getBreeds(),
          child:const _HomeContent()
        ),);
  }
}
class _HomeContent extends StatelessWidget {
  const _HomeContent(); //değiştirilemez olduğu için boş parametre de almıyor

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeState>(
      builder: (context,state){
        if (state.status==HomeStatus.error) {
          return Center(
            child: Text('Hata:${state.errorMessage}'),
          );
        }

        if (state.status==HomeStatus.loading) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if (state.dogs?.isEmpty??true) {
          return const Center(
            child: Text('Listede Köpek Bulunamadı'),
          );
        }
        return _DataState(state.dogs ?? []);
      }
    );
  }
}
class _DataState extends StatelessWidget {
  const _DataState(this.dogs);
  final List<ImmutableDog> dogs;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: dogs.length,
            itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DogSection(
                      images: dogs[index].imageUrl,
                      index: index,
                      bred: dogs[index].name,
                    ),
                  ],
                );
            },
          );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.appName,
  });

  final String appName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        appName,
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
  
  @override
  Size get preferredSize =>const Size.fromHeight(56);
}
