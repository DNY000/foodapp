import 'package:flutter/material.dart';
import 'package:foodapp/common/color_extension.dart';
import 'package:foodapp/view/home/widgets/header_home_view.dart';
import 'package:foodapp/view/home/widgets/list_banner.dart';
import 'package:foodapp/view/home/widgets/list_best_seller_food.dart';
import 'package:foodapp/view/home/widgets/list_category.dart';
import 'package:foodapp/view/home/widgets/list_restaurant_new.dart';
import 'package:foodapp/view/home/widgets/restaurant_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:foodapp/viewmodels/food_viewmodel.dart';
import '../../common_widget/line_textfield.dart';
import '../../common_widget/selection_text_view.dart';
import '../../viewmodels/category_viewmodel.dart';
import 'package:foodapp/viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: const _HomeViewContent(),
    );
  }
}

class _HomeViewContent extends StatefulWidget {
  const _HomeViewContent({Key? key}) : super(key: key);

  @override
  State<_HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<_HomeViewContent>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController trong HomeViewModel
    context.read<HomeViewModel>().initTabController(this);

    // Khởi tạo data khi widget được build lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodViewModel>().fetchFoodsYouMaybeLike();
      context.read<CategoryViewModel>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: TColor.bg,
        body: DefaultTabController(
          length: 3,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HeaderHomeView(),
              ),
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                pinned: false,
                floating: true,
                primary: false,
                // không hiển thị back button
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: RoundTextField(
                    controller: viewModel.searchController,
                    hitText: "Tìm kiếm ",
                    leftIcon: Icon(Icons.search, color: TColor.gray),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: ListBanner(),
              ),
              const SliverToBoxAdapter(
                child: ListCategory(),
              ),
              const SliverToBoxAdapter(
                child: ListFoodYouMaybeLike(),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SelectionTextView(
                      title: "Khám phá quán mới",
                      onSeeAllTap: () {},
                    ),
                    const ListRestaurantNew(),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.6, // 60% chiều cao màn hình
                  child: const RestaurantTabView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
