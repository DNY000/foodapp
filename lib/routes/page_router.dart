import 'package:foodapp/models/food_model.dart';
import 'package:foodapp/models/restaurant_model.dart';
import 'package:foodapp/routes/name_router.dart';
import 'package:foodapp/view/authentication/screen/login_view.dart';
import 'package:foodapp/view/authentication/screen/signup_view.dart';
import 'package:foodapp/view/authentication/screen/forgot_password_view.dart';
import 'package:foodapp/view/cart/cart_view.dart';
import 'package:foodapp/view/farvorites/farvorite_view.dart';
import 'package:foodapp/view/home/home_view.dart';
import 'package:foodapp/view/main_tab/main_tab_view.dart';
import 'package:foodapp/view/on_boarding/on_boarding_view.dart';
import 'package:foodapp/view/order/order_view.dart';
import 'package:foodapp/view/profile/my_profile_view.dart';
import 'package:foodapp/view/restaurant/restaurant_detail_view.dart';
import 'package:foodapp/view/restaurant/single_food_detail.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
    //     redirect: (context, state) {
    // final authViewModel = Provider.of<LoginViewModel>(context, listen: false);
    // final loggedIn = authViewModel.isLoggedIn;
    // final isLogin = state.matchedLocation == '/login';

    // if (!loggedIn && !isLogin) return '/login';
    // if (loggedIn && isLogin) return '/';
    // return null;
    // },
    initialLocation: NameRouter.onboarding,
    routes: [
      // Màn hình onboarding
      GoRoute(
        path: NameRouter.onboarding,
        builder: (context, state) => const OnBoardingView(),
      ),

      // Màn hình login
      GoRoute(
        path: NameRouter.login,
        builder: (context, state) => const LoginView(),
      ),

      // Màn hình đăng ký
      GoRoute(
        path: NameRouter.register,
        builder: (context, state) => const SignUpView(),
      ),

      // Màn hình quên mật khẩu
      GoRoute(
        path: NameRouter.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),

      // Main Tab - điểm nhập chính cho ứng dụng sau khi đăng nhập
      GoRoute(
        path: NameRouter.mainTab,
        builder: (context, state) => const MainTabView(),
      ),

      // Home
      GoRoute(
        path: NameRouter.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: NameRouter.cart,
        builder: (context, state) => const CartView(),
      ),
      // Order
      GoRoute(
        path: NameRouter.order,
        builder: (context, state) => const OrderView(),
      ),

      // Favorites
      GoRoute(
        path: NameRouter.favorites,
        builder: (context, state) => const FavoritesView(),
      ),

      // Profile
      GoRoute(
        path: NameRouter.profile,
        builder: (context, state) => const MyProfileView(),
      ),

      // Single Food Detail với tham số truyền vào
      GoRoute(
        path: NameRouter.signleFood,
        builder: (context, state) {
          final food = state.extra as FoodModel;
          return SingleFoodDetail(food: food);
        },
      ),

      // Restaurant Detail với tham số truyền vào
      GoRoute(
        path: NameRouter.detailRestaurants,
        builder: (context, state) {
          final restaurant = state.extra as RestaurantModel;
          return RestaurantDetailView(restaurant: restaurant);
        },
      ),
    ]);
