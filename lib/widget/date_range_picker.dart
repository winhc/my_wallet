import 'package:fl_responsive_ui/fl_responsive_ui.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:my_wallet/util/AppStateNotifier.dart';
import 'package:my_wallet/util/DateTools.dart';
import 'package:provider/provider.dart';

class DateRangePickerWidget extends StatefulWidget {
  const DateRangePickerWidget({Key key}) : super(key: key);

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.cyan),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Consumer<AppStateNotifier>(builder: (context, appState, child) {
          return InkWell(
            onTap: () async {
              final List<DateTime> pickedDateRange =
                  await DateRangePicker.showDatePicker(
                      context: context,
                      initialFirstDate:
                          DateTime.parse(appState.activeStartDate),
                      initialLastDate: DateTime.parse(appState.activeEndDate),
                      firstDate: new DateTime(DateTime.now().year - 2),
                      lastDate: new DateTime(DateTime.now().year + 2),
                      selectableDayPredicate: (date) {
                        if (date.month ==
                            DateTime.parse(appState.activeStartDate).month) {
                          return true;
                        } else {
                          return false;
                        }
                      });
              if (pickedDateRange != null && pickedDateRange.length == 2) {
                debugPrint('pickedDate=>$pickedDateRange');
                appState.updateDateRange(dateTime: pickedDateRange);
                appState.getActualCost(
                    startDate: strDateToMilliseconds(appState.activeStartDate),
                    endDate: strDateToMilliseconds(appState.activeEndDate));
                appState.getEstimateCost();
                appState.getAllExpenseItems(
                    startDate: strDateToMilliseconds(appState.activeStartDate),
                    endDate: strDateToMilliseconds(appState.activeEndDate));
              }
            },
            child: Row(
              children: [
                Text(
                  dayMonthFormatted(
                      date: DateTime.parse(appState.activeStartDate)),
                  style: FlResponsiveUI()
                      .getTextStyleRegular(fontSize: 14, color: Colors.white),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.yellow[600],
                  size: FlResponsiveUI().getProportionalWidth(width: 15),
                ),
                Text(
                  dayMonthFormatted(
                      date: DateTime.parse(appState.activeEndDate)),
                  style: FlResponsiveUI()
                      .getTextStyleRegular(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          );
        }));
  }
}
