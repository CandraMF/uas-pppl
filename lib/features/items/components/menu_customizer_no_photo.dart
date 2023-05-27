import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/get_menu_rest_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/blocs/main_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/main/models/menu_rest_model.dart';
import 'package:flutter_advanced_boilerplate/modules/dependency_injection/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:slang/builder/utils/string_extensions.dart';

class MenuCustomizerNoPhoto extends StatefulWidget {
  const MenuCustomizerNoPhoto({
    super.key,
  });

  @override
  State<MenuCustomizerNoPhoto> createState() => _MenuCustomizerWithPNoState();
}

class _MenuCustomizerWithPNoState extends State<MenuCustomizerNoPhoto> {
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
      child: Center(
        // height: 160,
        // margin: const EdgeInsets.only(bottom: 24),
        child: PagedListView<int, MenuRestModel>(
          scrollDirection: Axis.horizontal,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<MenuRestModel>(
            itemBuilder: (context, item, index) {
              return GestureDetector(
                onTap: () {
                  getIt<MainCubit>().changeMenuId(index: item.id);
                },
                child: Center(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            item.nama.capitalize(),
                          ),
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
