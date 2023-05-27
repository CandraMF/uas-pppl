import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/informations/widgets/grid_item.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/get_menu_rest_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/main_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/models/menu_rest_model.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_advanced_boilerplate/features/main/widgets/menu_costumizer_with_photo.dart';

class Menu {
  final String nama;
  final String foto;
  final int kode;

  Menu({required this.nama, required this.foto, required this.kode});
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Menu> promo = [
      Menu(
        nama: 'promo1',
        foto: 'promo1.jpg',
        kode: 2,
      ),
      Menu(
        nama: 'promo2',
        foto: 'promo2.png',
        kode: 1,
      ),
    ];

    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: CarouselSlider(
              options: CarouselOptions(height: 175),
              items: promo.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        child: Image.asset(
                          'assets/images/product/${i.foto}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            margin: const EdgeInsets.only(bottom: 24, top: 16),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border.fromBorderSide(
                  BorderSide(color: Colors.black12, width: 1.5),
                ),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        MdiIcons.ticketPercent,
                        color: Colors.orange,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: const Text(
                          'Promo Mu',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    MdiIcons.arrowRightBoldCircle,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: const Text(
              'Aneka Menu',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const MenuCustomizerWithPhoto(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: Image.network(
                    'https://hariansinggalang.co.id/wp-content/uploads/2021/08/gofoof.png',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(8),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Klik Disini',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
