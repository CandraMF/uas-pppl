import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/main_cubit.dart';
import 'package:flutter_advanced_boilerplate/modules/dependency_injection/di.dart';

final PageController pageController = PageController();

class Menu {
  final String nama;
  final String foto;
  final int kode;

  Menu({required this.nama, required this.foto, required this.kode});
}

class TypeCostumizer extends StatelessWidget {
  const TypeCostumizer({super.key});

  @override
  Widget build(BuildContext context) {
    List<Menu> menu = [
      Menu(
        nama: 'paket',
        foto: 'paket.jpg',
        kode: 2,
      ),
      Menu(
        nama: 'makanan',
        foto: 'makanan.webp',
        kode: 1,
      ),
      Menu(
        nama: 'minuman',
        foto: 'minuman.jpg',
        kode: 3,
      ),
      Menu(
        nama: 'snack',
        foto: 'snack.jpeg',
        kode: 4,
      ),
    ];

    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: menu.map(
        (i) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => {
                  getIt<MainCubit>().changeMenuId(index: i.kode),
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    elevation: 0,
                    color: Colors.black12,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        i.nama,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }
}
