import 'package:get/get.dart';
import 'package:localcooks_app/app/modules/shops/controllers/shop_details_controller.dart';
import 'package:localcooks_app/app/routes/app_routes.dart';

class CheckoutController extends GetxController{

  var openDays = <Map<String, dynamic>>[].obs;
  Map<String, List<String>> hourlySlots = {};
  RxString selectedDay = "".obs;
  RxString selectedHour = "".obs;
  var selectedDayHours = <String>[].obs;
  Map<String, String> dayDateMap = {};
  ShopDetailController shopDetailController = Get.find();
  RxBool isOnlyPreOrder = false.obs;

  @override
  void onInit() {
    if(shopDetailController.homeController.shopDetail.value.status != null
        && shopDetailController.homeController.shopDetail.value.status == "0"
        && shopDetailController.homeController.shopDetail.value.accept_preorders == 1){
      isOnlyPreOrder.value = true;
    }

    processOpenHours();

    super.onInit();
  }

  //shopDetailController.scheduleData.value.toJson()
  void processOpenHours() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1=Monday to 7=Sunday
    final dayOrder = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Get all open days in order starting from today
    final entries = shopDetailController.scheduleData.value.toJson().entries.toList();
    entries.sort((a, b) => dayOrder.indexOf(a.key).compareTo(dayOrder.indexOf(b.key)));

    // Find open days starting from today
    List<Map<String, dynamic>> tempOpenDays = [];

    for (int i = 0; i < 7; i++) {
      final dayIndex = (currentWeekday - 1 + i) % 7; // Convert to 0-6 index
      final dayAbbr = dayOrder[dayIndex];
      final dayData = shopDetailController.scheduleData.value.toJson()[dayAbbr]!;

      if (dayData['is_closed'] != 1 && dayData['open_time'] != null) {
        // Calculate the date for this day (today + i days)
        final date = now.add(Duration(days: i));
        final formattedDate = _formatDate(date);

        final isToday = i == 0;
        tempOpenDays.add({
          'day': dayAbbr,
          'date': date,
          'formatted_date': formattedDate,
          'open_time': dayData['open_time'],
          'close_time': dayData['close_time'],
          'is_today': isToday,
        });

        // Generate hourly slots
        hourlySlots[dayAbbr] = generateHourlySlots(
          dayData['open_time']!,
          dayData['close_time']!,
        );

        // Store date mapping
        dayDateMap[dayAbbr] = formattedDate;

        // Auto-select today if it's open
        if (isToday && selectedDay == null) {
          selectedDay.value = dayAbbr;
          selectedDayHours.value = hourlySlots[dayAbbr]!;
        }
      }
    }

    // If today isn't open, select first available day
    if (tempOpenDays.isNotEmpty) {
      selectedDay.value = tempOpenDays.first['day'];
      selectedDayHours.value = hourlySlots[selectedDay]!;
    }

    openDays.value = tempOpenDays;
  }

  String _formatDate(DateTime date) {
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  List<String> generateHourlySlots(String openTime, String closeTime) {
    List<String> slots = [];

    final openParts = openTime.split(':');
    final closeParts = closeTime.split(':');

    int openHour = int.parse(openParts[0]);
    int openMinute = int.parse(openParts[1]);
    int closeHour = int.parse(closeParts[0]);
    int closeMinute = int.parse(closeParts[1]);

    DateTime current = DateTime(2023, 1, 1, openHour, openMinute);
    DateTime end = DateTime(2023, 1, 1, closeHour, closeMinute);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      slots.add("${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')}");
      current = current.add(Duration(hours: 1));
    }

    return slots;
  }

  void selectDay(String day) {
    selectedDay.value = day;
    selectedDayHours.value = hourlySlots[day]!;
    selectedHour.value = "";
  }

  void selectHour(String hour) {
    selectedHour.value = hour;
  }

}