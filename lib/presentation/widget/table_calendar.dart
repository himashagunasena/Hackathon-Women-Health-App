import 'package:flutter/material.dart';
import '../../utils/appcolor.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomCalendar({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDate;
  late DateTime _displayedDate;
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<int> _years = [];
  int _selectedMonthIndex = 0;
  int _selectedYearIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedDate = _selectedDate;
    _years = List.generate(10, (index) => DateTime.now().year - index)
        .reversed
        .toList();
    _selectedMonthIndex = _selectedDate.month - 1;
    _selectedYearIndex = _years.indexOf(_selectedDate.year);
  }

  void _selectDate(DateTime newDate) {
    if (newDate.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      setState(() {
        _selectedDate = newDate;
        widget.onDateSelected(newDate);

        // Update month and year based on the new date
        _selectedMonthIndex = newDate.month - 1;
        _selectedYearIndex = _years.indexOf(newDate.year);
        _displayedDate = newDate;
      });
    }
  }

  void _updateMonth(int monthIndex) {
    setState(() {
      _selectedMonthIndex = monthIndex;
      // Only update the displayed date's month without resetting the week
      _displayedDate = DateTime(
        _displayedDate.year,
        monthIndex + 1,
        _displayedDate.day,
      );
    });
  }

  void _updateYear(int yearIndex) {
    setState(() {
      _selectedYearIndex = yearIndex;
      _displayedDate = DateTime(
        _years[yearIndex],
        _selectedMonthIndex + 1,
        _displayedDate.day,
      );
    });
  }

  void _changeWeek(int weekOffset) {
    setState(() {
      _displayedDate = _displayedDate.add(Duration(days: weekOffset * 7));
      _selectedMonthIndex = _displayedDate.month - 1;
      _selectedYearIndex = _years.indexOf(_displayedDate.year);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.enableButton.withOpacity(0.3),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _changeWeek(-1),
                ),
                DropdownButton<String>(
                  underline: const SizedBox.shrink(),
                  value: _months[_selectedMonthIndex],
                  items: _months.map((month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _updateMonth(_months.indexOf(value!));
                  },
                ),
                DropdownButton<int>(
                  underline: const SizedBox.shrink(),
                  value: _years[_selectedYearIndex],
                  items: _years.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _updateYear(_years.indexOf(value!));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _changeWeek(1),
                ),
              ],
            ),
          ),
          WeeklyCalendarGrid(
            selectedDate: _selectedDate,
            displayedDate: _displayedDate,
            onSelectDate: _selectDate,
            onSwipeWeek: _changeWeek,
          ),
        ],
      ),
    );
  }
}


class WeeklyCalendarGrid extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime displayedDate;
  final Function(DateTime) onSelectDate;
  final Function(int) onSwipeWeek;

  const WeeklyCalendarGrid({
    super.key,
    required this.selectedDate,
    required this.displayedDate,
    required this.onSelectDate,
    required this.onSwipeWeek,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfWeek = DateTime(
      displayedDate.year,
      displayedDate.month,
      displayedDate.day - displayedDate.weekday + 1,
    );

    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    int weeksInMonth = 0;
    for (int day = 1;
        day <= DateTime(displayedDate.year, displayedDate.month + 1, 0).day;
        day++) {
      final date = DateTime(displayedDate.year, displayedDate.month, day);
      if (date.weekday == DateTime.monday) {
        weeksInMonth++;
      }
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 80,
            child: PageView.builder(
              itemCount: weeksInMonth,
              controller: PageController(initialPage: 0),
              onPageChanged: (index) {
                final weekOffset = index;
                onSwipeWeek(weekOffset);
              },
              itemBuilder: (context, pageIndex) {
                final displayedStartDate =
                    firstDayOfWeek.add(Duration(days: pageIndex * 7));
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final date = displayedStartDate.add(Duration(days: index));
                    final isSelected = date.day == selectedDate.day &&
                        date.month == selectedDate.month &&
                        date.year == selectedDate.year;

                    final isFutureDate = date.isAfter(DateTime.now());

                    return GestureDetector(
                      onTap: () {
                        if (!isFutureDate) {
                          onSelectDate(date);
                        }
                      },
                      child: Container(
                        width: 45,
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dayLabels[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: isSelected
                                    ? AppColors.lightTextColor
                                    : AppColors.textColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: isSelected
                                      ? AppColors.lightTextColor
                                      : (isFutureDate
                                          ? Colors.grey
                                          : AppColors.textColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
