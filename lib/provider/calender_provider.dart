import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderProvider extends ChangeNotifier {
  DateTime currentDate = DateTime.now();
  late DateTime startTime;
  late DateTime endTime;
  late LinkedHashMap<DateTime, List<BookingModel>> groupedBookings;
  List<BookingModel> selectedDayBookings = [];
  DateTime selectedDate = DateTime.now();
  // CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

  List<DateTime> bookedTime = [];

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  onStart(List<BookingModel> bookingList) async {
    print("============on start calender page=========");
    /* store bookings of same day together like this <DateTime, List<BookingModel>>*/
    await groupBookingsOfSameDay(bookingList);
    selectedDate = DateTime.now();
    selectDay(selectedDate);
    notifyListeners();
  }

  void selectDay(DateTime selectedDay) {
    selectedDate = selectedDay;
    /* store booking of selected day i.e current day for init  in List variable of Bookings ======> selectedDayBookings*/
    selectedDayBookings = groupedBookings[selectedDate] ?? [];
    /* selecting start and end time of selected DAY */
    startTime = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 8, 0, 0);
    endTime = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 17, 0, 0);
    /* make time slots according to start and end time of selected DAY */
    timeSlotsFunction();
    /* pass selected day bookings and find occupied timings*/
    getBookedTimings(selectedDayBookings);
    selectDateTmeSlot = null;

    notifyListeners();
  }

  groupBookingsOfSameDay(List<BookingModel> bookings) {
    groupedBookings = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);

    for (var event in bookings) {
      DateTime? bookingDate = event.bookingDate?.toDate();
      DateTime date = DateTime.utc(
          bookingDate!.year, bookingDate.month, bookingDate.day, 12);

      if (groupedBookings[date] == null) groupedBookings[date] = [];
      groupedBookings[date]?.add(event);
    }
  }

  List<dynamic> getEventsForDay(DateTime date) {
    return groupedBookings[date] ?? [];
  }

  // late DateTime bookingTime;
  Duration step = const Duration(minutes: 60);

  List<DateTime> timeSlots = [];
  List<DateTime> bookedSlots = [];

  void timeSlotsFunction() {
    timeSlots = [];
    while (startTime.isBefore(endTime)) {
      DateTime timeIncrement = startTime.add(step);
      timeSlots.add(timeIncrement);
      startTime = timeIncrement;
    }
  }

  String formattedDate(DateTime date) {
    String dateString = DateFormat.jm().format(date);
    return dateString;
  }

  getBookedTimings(List<BookingModel> bookings) {
    bookedSlots=[];
    for (int i = 0; i < bookings.length; i++) {
      DateTime dateTime = bookings[i].bookingDate!.toDate();
      DateTime temp = DateTime(dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute, 0);

      bookedSlots.add(temp);
    }
    print("bookedSlots  length ${bookedSlots.length}");
    bookedTime = [];
    timeSlots.forEach((time) {
      isCurrentDateAvailable(time);
    });

    bookedTime.forEach((element) {
      print(element);
    });
    print("length of already booked timing are ${bookedTime.length}");
  }

  void isCurrentDateAvailable(DateTime slotTime) {
    for (int i = 0; i < bookedSlots.length; i++) {

      if ((slotTime.compareTo(bookedSlots[i]) == 0)) {
        bookedTime.add(DateTime(bookedSlots[i].year, bookedSlots[i].month,
            bookedSlots[i].day, bookedSlots[i].hour, bookedSlots[i].minute, 0));
      }
    }
  }

  DateTime? selectDateTmeSlot;

  void selectDateFromTimeSlot(DateTime date) {
    selectDateTmeSlot = date;
    print(selectDateTmeSlot);
    notifyListeners();
  }
}
