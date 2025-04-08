import 'package:foodapp/common/appbar/t_appbar.dart';
import 'package:foodapp/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/routes/name_router.dart';
import 'package:go_router/go_router.dart';

class HeaderHomeView extends StatelessWidget {
  const HeaderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ha Noi",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: TColor.text, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Your location",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: TColor.gray, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      // showBackArrow: isSelectCity,

      action: [
        // IconButton(
        //   icon: Icon(
        //     FontAwesomeIcons.bell,
        //     size: 20,
        //     color: TColor.text,
        //   ),
        //   onPressed: () {},
        // ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.cartShopping,
            size: 20,
            color: TColor.text,
          ),
          onPressed: () {
            context.push(NameRouter.cart);
          },
        ),
      ],
    );
  }
}
