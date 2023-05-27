import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/env_model.dart';
import 'package:flutter_advanced_boilerplate/features/items/blocs/get_items_rest_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/main_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/items/components/menu_customizer_no_photo.dart';
import 'package:flutter_advanced_boilerplate/features/items/models/item_rest_model.dart';
import 'package:flutter_advanced_boilerplate/modules/dependency_injection/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:keframe/keframe.dart';
import 'package:flutter_advanced_boilerplate/features/app/widgets/utils/skeleton_loader.dart';
import 'package:flutter_advanced_boilerplate/features/main/models/menu_rest_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final PagingController<int, ItemRestModel> _pagingController =
      PagingController(firstPageKey: 1);

  final GetItemsRestCubit _cubit = getIt<GetItemsRestCubit>();
  final MainCubit _maincubit = getIt<MainCubit>();
  int? menuId;

  @override
  void initState() {
    _pagingController.addPageRequestListener(_cubit.getItems);
    menuId = _maincubit.getMenuId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2 - 50;
    final double itemWidth = size.width / 2;
    var rupiahFormater = NumberFormat('#,###,000');

    return MultiBlocListener(
      listeners: [
        BlocListener<GetItemsRestCubit, GetItemsRestState>(
          bloc: _cubit,
          listener: (_, state) {
            state.mapOrNull(
              failed: (st) => _pagingController.error = st.alert,
              refresh: (_) => _pagingController.refresh(),
              success: (st) {
                if (st.items.total > st.items.size * st.items.currentPage) {
                  _pagingController.appendPage(
                    st.items.items,
                    st.items.currentPage + 1,
                  );
                } else {
                  _pagingController.appendLastPage(st.items.items);
                }
              },
            );
          },
        ),
        BlocListener<MainCubit, MainState>(
          bloc: _maincubit,
          listener: (_, state) {
            _pagingController.refresh();
            setState(() {
              menuId = state.menuId;
            });
          },
        ),
      ],
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 180,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(menuId.toString()),
                background: Image.network(
                  'https://cdn.mos.cms.futurecdn.net/JGvpycbmvWUNraKhPzeQET-1024-80.jpg.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(
                    height: 75,
                    child: MenuCustomizerNoPhoto(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Menu',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(
                              color: Color.fromARGB(255, 218, 218, 218),
                              thickness: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: PagedGridView<int, ItemRestModel>(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          pagingController: _pagingController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: itemWidth / itemHeight,
                          ),
                          builderDelegate:
                              PagedChildBuilderDelegate<ItemRestModel>(
                            itemBuilder: (
                              BuildContext context,
                              ItemRestModel item,
                              int index,
                            ) {
                              return FrameSeparateWidget(
                                index: index,
                                placeHolder: _buildTileSkeleton(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return ModalBottomContent(
                                              size: size,
                                              rupiahFormater: rupiahFormater,
                                              item: item,
                                            );
                                          },
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 170,
                                            width: itemWidth,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              child: Image.network(
                                                'http://10.0.2.2:8000/storage/produk/${item.foto}',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            item.nama,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      rupiahFormater.format(item.harga),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.orange,
                                        minimumSize: const Size.fromHeight(30),
                                        side: const BorderSide(
                                          width: 2,
                                          color: Colors.orange,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                      child: const Text('Tambah'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTileSkeleton() {
    return SkeletonLoader(
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20,
              width: 20,
              constraints: const BoxConstraints(minHeight: 20, maxHeight: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ],
        ),
        title: Container(
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
    );
  }
}

class ModalBottomContent extends StatelessWidget {
  const ModalBottomContent({
    super.key,
    required this.size,
    required this.rupiahFormater,
    required this.item,
  });

  final Size size;
  final NumberFormat rupiahFormater;
  final ItemRestModel item;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.width - 50,
                  width: size.width - 50,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        10,
                      ),
                    ),
                    child: Image.network(
                      'http://34.101.226.172/public/storage/produk/${item.foto}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  item.deskripsi,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  rupiahFormater.format(
                    item.harga,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                    minimumSize: const Size.fromHeight(30),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.orange,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
