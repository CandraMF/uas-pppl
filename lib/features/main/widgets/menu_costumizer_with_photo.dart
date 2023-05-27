import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/get_menu_rest_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/main_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/models/menu_rest_model.dart';
import 'package:flutter_advanced_boilerplate/modules/dependency_injection/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:slang/builder/utils/string_extensions.dart';

class MenuCustomizerWithPhoto extends StatefulWidget {
  const MenuCustomizerWithPhoto({
    super.key,
  });

  @override
  State<MenuCustomizerWithPhoto> createState() =>
      _MenuCustomizerWithPhotoState();
}

class _MenuCustomizerWithPhotoState extends State<MenuCustomizerWithPhoto> {
  final PagingController<int, MenuRestModel> _pagingController =
      PagingController(firstPageKey: 1);

  final GetMenuRestCubit _cubit = getIt<GetMenuRestCubit>();

  @override
  void initState() {
    _pagingController.addPageRequestListener(_cubit.getMenu);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetMenuRestCubit, GetMenuRestState>(
      bloc: _cubit,
      listener: (_, state) {
        state.mapOrNull(
          failed: (st) => _pagingController.error = st.alert,
          refresh: (_) => _pagingController.refresh(),
          success: (st) {
            if (st.menus.total > st.menus.size * st.menus.currentPage) {
              _pagingController.appendPage(
                st.menus.items,
                st.menus.currentPage + 1,
              );
            } else {
              _pagingController.appendLastPage(st.menus.items);
            }
          },
        );
      },
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: 24),
        child: PagedListView<int, MenuRestModel>(
          scrollDirection: Axis.horizontal,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<MenuRestModel>(
            itemBuilder: (context, item, index) {
              return GestureDetector(
                onTap: () {
                  getIt<MainCubit>().changeMenuId(index: item.id);
                  getIt<AppCubit>().changePageIndex(index: 2);
                },
                child: Container(
                  width: 120,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            'http://10.0.2.2:8000/storage/menu/${item.foto}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        item.nama.capitalize(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
