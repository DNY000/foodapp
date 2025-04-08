import 'package:flutter/material.dart';
import 'package:foodapp/common/appbar/t_appbar.dart';
import 'package:foodapp/common_widget/user_review_row.dart';

class ReviewUser extends StatelessWidget {
  const ReviewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        showBackArrow: false,
        title: Text("Review"),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: UserReviewRow(),
      ),
    );
  }
}
