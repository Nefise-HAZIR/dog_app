import 'package:dog_app/features/home/bloc/home_cubit.dart';
import 'package:dog_app/features/home/bloc/home_state.dart';
import 'package:dog_app/features/home/model/dog_model.dart';
import 'package:dog_app/features/settings/screen/setting_screen.dart';
import 'package:dog_app/widgets/dog_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String route = '/';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String appName = "DogApp";

  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: _AppBar(appName: appName),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
              //isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Positioned(
                  left: 20.w,
                  bottom: 10.w,
                  width: 320.w,
                  height: 50.h,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          expands: true,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      body:_currentIndex==1?const SettingScreen():BlocProvider(
          create: (context) => HomeCubit()..getBreeds(),
          child: const _HomeContent()),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent(); //değiştirilemez olduğu için boş parametre de almıyor

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state.status == HomeStatus.error) {
        return Center(
          child: Text('Hata:${state.errorMessage}'),
        );
      }

      if (state.status == HomeStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.dogs?.isEmpty ?? true) {
        return const Center(
          child: Text('Listede Köpek Bulunamadı'),
        );
      }
      return _DataState(state.dogs ?? []);
    });
  }
}

class _DataState extends StatelessWidget {
  const _DataState(this.dogs);
  final List<ImmutableDog> dogs;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
      systemOverlayStyle: SystemUiOverlayStyle.light,
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
  Size get preferredSize => const Size.fromHeight(56);
}
