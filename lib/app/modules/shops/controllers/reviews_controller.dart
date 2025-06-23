import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/models/shops/cart.dart';
import 'package:localcooks_app/app/models/shops/reviews.dart';
import 'package:localcooks_app/app/models/shops/shops.dart';

import '../../../../common/event_actions.dart';
import '../../../providers/dio_client.dart';

class ReviewsController extends GetxController{

  final DioClient _httpClient = DioClient();
  var event = EventAction.NO_RECORD.obs;
  var reviewList = <ReviewsData>[].obs;
  var shop = Shops().obs;

  @override
  void onInit() {
    shop.value = Get.arguments;
    getReviews();
    super.onInit();
  }

  Future<void> getReviews() async{
    try {
      event.value = EventAction.LOADING;
      var response = await _httpClient.get(
          'controllers/shop_review_api.php',
          queryParameters: {
            "sid" : shop.value.sid,
          },
      );
      event.value = EventAction.FETCH;
      var reviewData = Reviews.fromJson(response);
      if(reviewData != null && reviewData.data != null && reviewData.data!.isNotEmpty){
        reviewList.addAll(reviewData.data ?? []);
      }else{
        event.value = EventAction.NO_RECORD;
      }
    } on DioException catch (_) {
      event.value = EventAction.NO_RECORD;
    }
  }

}