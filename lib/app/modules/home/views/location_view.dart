import 'package:artools/artools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localcooks_app/app/global_widgets/card_container.dart';
import 'package:localcooks_app/app/global_widgets/custom_button.dart';
import 'package:localcooks_app/app/modules/home/controllers/home_controller.dart';
import 'package:localcooks_app/common/ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/constants.dart';
import '../../../global_widgets/input_field_with_shadow.dart';
import '../../../global_widgets/loading_indicator.dart';

class LocationView extends StatelessWidget {

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                CardContainer(
                  sideColor: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Theme.of(context).primaryColor,),
                          const SizedBox(width: 5,),
                          Text("Current Address", style: titleBold),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text(homeController.loginController.profile.value.useraddress ?? ""),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Icon(Icons.search, color: Theme.of(context).primaryColor,),
                    const SizedBox(width: 5,),
                    Text("Find your address", style: titleBold),
                  ],
                ),
                const SizedBox(height: 10,),
                InputFieldWithShadow(
                  textController: homeController.locationTextController.value,
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: homeController.googleApikey,
                      mode: Mode.fullscreen,
                      strictbounds: false,
                      radius: 100000,
                      cursorColor: Theme.of(context).primaryColor,
                      //location: Location(lat: 53.4808, lng: -2.2426),
                      //origin: Location(lat: 53.4808, lng: -2.2426),
                      language: 'en',
                      components: [Component(Component.country, 'ca')],
                      types: [],
                      onError: (err){
                        print('============> $err');
                      },
                    );

                    if(place != null){
                      final plist = GoogleMapsPlaces(apiKey: homeController.googleApikey,
                        apiHeaders: await const GoogleApiHeaders().getHeaders(),
                      );
                      String placeId = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeId);
                      var fullAddress = '${detail.result.name}, ${detail.result.formattedAddress}';
                      homeController.locationTextController.value.text = fullAddress;
                      homeController.locationTextController.refresh();
                      final geometry = detail.result.geometry!;
                      homeController.selectedLatitude = geometry.location.lat;
                      homeController.selectedLongitude = geometry.location.lng;
                      //TODO
                      /*var newLatLng = LatLng(lat, lang);
                  Marker marker = Marker(markerId: MarkerId("1"), position: newLatLng, icon: BitmapDescriptor.defaultMarker,);
                  List<Placemark> listPlaceMarkers = await placemarkFromCoordinates(marker.position.latitude, marker.position.longitude);*/
                    }else{
                      debugPrint("place = null");
                    }
                  },
                  hintLabel: "Enter your street address",
                  prefixIcon: Icons.location_on_outlined,
                  isReadOnly: true,
                ),
                const SizedBox(height: 20,),
                CardContainer(
                  sideColor: Colors.orange,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange,),
                          const SizedBox(width: 5,),
                          Text("Delivery Information", style: titleBold),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text("We currently deliver to St. John's and some surrounding areas. You can select address only within our delivery zone."),
                    ],
                  ),
                ),
                const SizedBox(height: 40,),
                Obx((){
                  return CustomButton(
                    buttonTitle: "Update Delivery Address",
                    backgroundColor: homeController.locationTextController.value.text.isNotEmpty ? Theme.of(context).primaryColor : Colors.grey.shade400,
                    onPressed: () async{
                      if(homeController.locationTextController.value.text.toLowerCase().contains("st. john's")){
                        await homeController.loginController.updateLocation(homeController.selectedLatitude, homeController.selectedLongitude, homeController.locationTextController.value.text);
                        homeController.locationTextController.value.clear();
                      }else{
                        Ui.ErrorSnackBar(message: "We currently deliver to St. John's and some surrounding areas. You can select address only within our delivery zone.").show();
                      }
                    },
                    icon: MdiIcons.checkboxMarkedCircleOutline,
                  );
                }),
                const SizedBox(height: 20,),
                CustomButton(
                  buttonTitle: "Use My Current Location",
                  onPressed: (){
                    homeController.fetchLocation();
                  },
                  backgroundColor: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                  icon: MdiIcons.navigationVariantOutline,
                ),
              ],
            ),
          ).isAbsorbing(homeController.loginController.isLoading.value),
          homeController.loginController.isLoading.value
              ? LoadingIndicator(
              isVisible: homeController.loginController.isLoading.value,
              loadingText: 'Updating'.tr)
              : const SizedBox.shrink(),
        ],
      )),
    );
  }
}
