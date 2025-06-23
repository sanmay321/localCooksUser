import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:localcooks_app/app/global_widgets/card_container.dart';
import 'package:localcooks_app/app/modules/shops/controllers/reviews_controller.dart';
import 'package:localcooks_app/common/constants.dart';
import 'package:localcooks_app/common/event_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReviewsScreen extends StatelessWidget {

  ReviewsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(controller.shop.value.sname ?? ""),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MdiIcons.starCircleOutline, size: 30,color: Theme.of(context).primaryColor),
                      Text("${controller.shop.value.avgRating}", style: titleLargeBold.copyWith(color: Theme.of(context).primaryColor, fontSize: 30, height: 1.2),)
                    ],
                  ),
                  Text("Overall Rating", style: titleLargeBold.copyWith(height: 1.2),),
                  const SizedBox(height: 5,),
                  Text("(${controller.shop.value.totalReviews} Reviews)", style: title.copyWith(height: 1.2, color: Colors.grey.shade600),),
                  const SizedBox(height: 5,),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: Obx((){
                if(controller.event.value == EventAction.LOADING){
                  return Center(child: CircularProgressIndicator(),);
                }else if(controller.event.value == EventAction.FETCH){
                  return ListView.builder(
                    itemCount: controller.reviewList.length,
                    itemBuilder: (context, index){
                      var reviewDate = controller.reviewList[index].createdAt!;
                      var formattedDate = DateFormat("yyyy-MM-dd").parse(reviewDate);
                      var finalDate = DateFormat("MMMM dd, yyyy").format(formattedDate);
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.reviewList[index].username ?? "", style: titleBold,),
                                  Text("Reviewed on $finalDate", style: titleMedium.copyWith(color: Colors.grey.shade600),),
                                  const SizedBox(height: 5,),
                                  Text(controller.reviewList[index].description ?? "", style: titleNormal,),
                                ],
                              )),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.all(3),
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(MdiIcons.starOutline, color: Colors.white, size: 18,),
                                    Text(controller.reviewList[index].rating ?? "", style: titleNormal.copyWith(color: Colors.white),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }else{
                  return Center(child: Text("No reviews found for this shop"),);
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
