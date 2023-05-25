import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/features/app/widgets/utils/skeleton_loader.dart';
import 'package:flutter_advanced_boilerplate/features/profile/blocs/get_users_rest_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/profile/models/user_rest_model.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/modules/dependency_injection/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:keframe/keframe.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PagingController<int, UserRestModel> _pagingController =
      PagingController(firstPageKey: 1);
  final GetUsersRestCubit _cubit = getIt<GetUsersRestCubit>();

  @override
  void initState() {
    _pagingController.addPageRequestListener(_cubit.getUsers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetUsersRestCubit, GetUsersRestState>(
      bloc: _cubit,
      listener: (_, state) {
        state.mapOrNull(
          failed: (st) => _pagingController.error = st.alert,
          refresh: (_) => _pagingController.refresh(),
          success: (st) {
            if (st.users.total > st.users.size * st.users.currentPage) {
              _pagingController.appendPage(
                st.users.items,
                st.users.currentPage + 1,
              );
            } else {
              _pagingController.appendLastPage(st.users.items);
            }
          },
        );
      },
      child: PagedListView<int, UserRestModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<UserRestModel>(
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Text(
              context.t.core.errors.others.something_went_wrong,
            ),
          ),
          noItemsFoundIndicatorBuilder: (_) => Center(
            child: Text(
              context.t.core.errors.others.no_item_found,
            ),
          ),
          firstPageProgressIndicatorBuilder: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          itemBuilder: (_, user, index) => FrameSeparateWidget(
            index: index,
            placeHolder: _buildTileSkeleton(),
            child: ListTile(
              leading: Text(user.id.toString()),
              title: Text(user.email),
              subtitle: Text(user.name),
            ),
          ),
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
