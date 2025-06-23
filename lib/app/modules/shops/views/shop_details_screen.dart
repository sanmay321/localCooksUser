import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/global_widgets/card_container.dart';
import 'package:localcooks_app/app/modules/shops/controllers/shop_details_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';
import 'package:localcooks_app/common/constants.dart';
import 'package:localcooks_app/common/event_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ShopDetailsScreen extends StatelessWidget {

  ShopDetailController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            //backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            expandedHeight: 250,
            //floating: true,
            pinned: true,
            //snap: true  ,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 40, bottom: 5, right: 10),
              centerTitle: false,
              title: LayoutBuilder(
                builder: (context, constraints){
                  return Row(
                    children: [
                      const SizedBox(width: 10,),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CachedNetworkImage(
                          errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
                          placeholder: (context, s) => Center(child: const CircularProgressIndicator()),
                          imageUrl: imageBaseURL + controller.shop.value.chefs_image!,
                          imageBuilder: (context, imageProvider){
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: imageProvider
                                  )
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(controller.shop.value.sname ?? "", style: titleBold.copyWith(color: constraints.maxHeight > 100 ? Colors.white : Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis,),
                          Text("By ${controller.shop.value.sowner}", style: titleNormalBold.copyWith(color: constraints.maxHeight > 100 ? Colors.white : Colors.black, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        ],
                      )),
                      Obx(() => Badge(
                        label: Text("${controller.totalCardCount.value}", style: TextStyle(color: constraints.maxHeight > 100 ? Colors.black : Colors.white, fontSize: 10),),
                        backgroundColor: constraints.maxHeight > 100 ? Colors.white : Colors.red,
                        offset: const Offset(-4, 4),
                        isLabelVisible: controller.totalCardCount.value > 0,
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart, color: constraints.maxHeight > 100 ? Colors.white : Colors.black,),
                          onPressed: () {
                            Get.toNamed(Routes.CART);
                          },
                        ),
                      )),
                    ],
                  );
                },
              ),
              background: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  // Add the background image
                  SizedBox(
                    height: Get.height/2.5,
                    child: Image.network(
                      imageBaseURL + controller.shop.value.simage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.black.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([
            /*Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 70,
                  width: 70,
                  child: CachedNetworkImage(
                    errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
                    placeholder: (context, s) => Center(child: const CircularProgressIndicator()),
                    imageUrl: imageBaseURL + controller.shop.value.chefs_image!,
                    imageBuilder: (context, imageProvider){
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider
                            )
                        ),
                      );
                    },
                  ),
                ),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text(controller.shop.value.sname ?? "", style: titleBold,),
                    //const SizedBox(height: 5,),
                    Text("By ${controller.shop.value.sowner}"),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 17,),
                        Text("${controller.shop.value.avgRating}", style: titleNormalBold,),
                        Text(" (${controller.shop.value.totalReviews})", style: TextStyle(color: Colors.grey.shade500),),
                      ],
                    )
                  ],
                ))
              ],
            ),*/
            const SizedBox(height: 10,),
            RatingBar.readOnly(
              isHalfAllowed: false,
              alignment: Alignment.center,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              initialRating: controller.shop.value.avgRating.toDouble(),
              maxRating: 5,
              filledColor: Colors.amber,
              emptyColor: Colors.amber,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 17,),
                Text("${controller.shop.value.avgRating}", style: titleNormalBold,),
                Text(" (${controller.shop.value.totalReviews})", style: TextStyle(color: Colors.grey.shade500),),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.REVIEWS, arguments: controller.shop.value);
                  },
                  child: RichText(text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "See Reviews", style: TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.dotted)),
                    ]
                  )),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("By ${controller.shop.value.description}")
            ),
            controller.shop.value.accept_preorders == 1 ? const SizedBox(height: 10,) : const SizedBox.shrink(),
            controller.shop.value.accept_preorders == 1 ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CardContainer(
                sideColor: Colors.orange,
                child: Column(
                  children: [
                    Text("Pre-Order Available!", style: titleNormalBold,),
                    controller.shop.value.status == "0" ? RichText(
                      textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "The chef is currently ",),
                            TextSpan(text: "closed", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey.shade500)),
                            TextSpan(text: " but ",),
                            TextSpan(text: "accept pre-orders", style: TextStyle(fontWeight: FontWeight.w800, fontStyle: FontStyle.italic, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.dotted)),
                            TextSpan(text: " for upcoming days.",),
                          ],
                        )) : RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "The chef is currently open and also ",),
                            TextSpan(text: "accept pre-orders.", style: TextStyle(fontWeight: FontWeight.w800, fontStyle: FontStyle.italic, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.dotted)),
                            TextSpan(text: " Order for now or schedule for later.",),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ) : const SizedBox.shrink(),
            const SizedBox(height: 10,),
            Obx((){
              if(controller.eventSchedule.value == EventAction.FETCH){
                return Column(
                  children: [
                    Text("Availability", style: titleBold,),
                    GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 2 items per row
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 2
                      ),
                      itemCount: controller.daysList.length,
                      itemBuilder: (context, index) {
                        final day = controller.daysList[index];
                        final data = day.value as Map<String, dynamic>;
                        final isClosed = data['is_closed'] == 1;
                        final today = controller.isToday(day.key);

                        return Card(
                          elevation: 4,
                          color: isClosed ? Colors.grey[300] : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                today ? Text(
                                  "${day.key} (Today)",
                                  style: titleNormalBold.copyWith(color: Theme.of(context).primaryColor,),
                                ) : Text(
                                  day.key,
                                  style: titleNormalBold.copyWith(color: Theme.of(context).primaryColor,),
                                ),
                                isClosed
                                    ? Text(
                                  'Closed',
                                  style: titleSmall,
                                )
                                    :
                                Text(
                                  "${controller.formatTime(data['open_time'])} - ${controller.formatTime(data['close_time'])}",
                                  style: titleSmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }else if(controller.eventSchedule.value == EventAction.FETCH){
                return SizedBox(
                  height: 50,
                  width: Get.width,
                  child: Center(child: CircularProgressIndicator(),),
                );
              }else{
                return const SizedBox.shrink();
              }
            }),
            Obx((){
              if(controller.event.value == EventAction.FETCH){
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    itemCount: controller.productCategoriesList.length,
                    itemBuilder: (context, index){
                      var categories = controller.productCategoriesList[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).primaryColor,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(categories.cname ?? "", style: titleBold.copyWith(color: Theme.of(context).primaryColor),),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).primaryColor,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            primary: false,
                            separatorBuilder: (c, i){
                              return Divider();
                            },
                            itemCount: categories.products!.length,
                            itemBuilder: (ctx, idx){
                              var product = categories.products![idx];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CachedNetworkImage(
                                    errorWidget: (context, s, o) => Center(child: Icon(Icons.error, color: Colors.red,)),
                                    placeholder: (context, s) => Center(child: CupertinoActivityIndicator()),
                                    imageUrl: imageBaseURL + product.pimage!,
                                    imageBuilder: (context, imageProvider){
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider
                                            )
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.pname ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    //const SizedBox(height: 5,),
                                    Text("\$${product.price}", style: titleNormalBold.copyWith(color: Theme.of(context).primaryColor),),
                                    product.status == 0 ? Container(
                                      width: 100,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade400, width: 1),
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.grey.shade200
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(MdiIcons.closeCircle, size: 12,),
                                          const SizedBox(width: 2,),
                                          Text("Out of Stock", style: titleSmall,)
                                        ],
                                      ),
                                    ) : const SizedBox.shrink(),
                                  ],
                                ),
                                trailing: IconButton(onPressed: (){
                                  if(product.status == 0) return;
                                  Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product);
                                }, icon: Icon(MdiIcons.plusCircle, color: product.status == 0 ? Colors.grey : Theme.of(ctx).primaryColor, size: 35,)),
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                );
              }else if(controller.event.value == EventAction.LOADING){
                return SizedBox(height: 100, child: Center(child: CircularProgressIndicator(),),);
              }else{
                return const SizedBox.shrink();
              }
            }),
          ]))
        ],
      ),
    );
  }
}
