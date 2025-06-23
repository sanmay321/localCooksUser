import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../common/event_actions.dart';
import '../providers/dio_client.dart';
import 'home/controllers/home_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {

  final controller = Get.put(PrivacyPolicyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Local Cooks", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: 'Lobster', color: Theme.of(context).primaryColor),),
        leading: IconButton(
          onPressed: controller.homeController.handleMenuButtonPressed,
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: controller.homeController.advancedDrawerController,
            builder: (_, value, __) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Icons.clear : Icons.menu,
                  color: Theme.of(context).primaryColor,
                  key: ValueKey<bool>(value.visible),
                ),
              );
            },
          ),
        ),
      ),
      body: Obx((){
        if(controller.event.value == EventAction.FETCH){
          return SingleChildScrollView(
            child: Html(data: controller.htmlStr.value),
          );
        }else if(controller.event.value == EventAction.LOADING){
          return Center(child: CircularProgressIndicator(),);
        }else{
          return Center(child: Text("No data found"),);
        }
      }),
    );
  }
}

class PrivacyPolicyController extends GetxController{

  var event = EventAction.LOADING.obs;
  final DioClient _httpClient = DioClient();
  var htmlStr = "".obs;
  HomeController homeController = Get.find();

  @override
  void onInit() {
    getTerms();
    super.onInit();
  }

  Future<void> getTerms() async{
    try {
      event.value = EventAction.LOADING;
      var response = await _httpClient.get(
          'controllers/privacy_api.php',
      );

      int status = response["status"];
      if(status == 200){
        var data = response["data"];
        htmlStr.value = data["html"];
        htmlStr.refresh();
        event.value = EventAction.FETCH;
      }else{
        event.value = EventAction.NO_RECORD;
      }

    } on DioException catch (_) {
      event.value = EventAction.NO_RECORD;
    }
  }

}
