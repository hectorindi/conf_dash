import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/models/daily_info_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    Key? key,
    required this.colors,
    required this.spotsData,
  }) : super(key: key);

  final List<Color>? colors;
  final List<FlSpot>? spotsData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spotsData ?? [],
            isCurved: true,
            gradient: LinearGradient(colors: colors ?? [Colors.blue]),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: (colors ?? [Colors.blue])
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(enabled: false),
        maxY: 4,
        minY: 0,
      ),
    );
  }
}

class MiniInformationWidget extends StatefulWidget {
  const MiniInformationWidget({
    Key? key,
    required this.dailyData,
  }) : super(key: key);
  final TotalRegistrationInfoModel dailyData;

  @override
  _MiniInformationWidgetState createState() => _MiniInformationWidgetState();
}

// ...existing code...

class _MiniInformationWidgetState extends State<MiniInformationWidget> {
  String _selectedValue = "Daily";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    
    return Container(
      constraints: BoxConstraints(
        minHeight: 150,
        maxHeight: isDesktop ? double.infinity : 180, // Add max height for mobile
      ),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.5), // Reduced padding
                height: 35, // Reduced height
                width: 35,  // Reduced width
                decoration: BoxDecoration(
                  color: widget.dailyData.color!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.dailyData.icon,
                  color: widget.dailyData.color,
                  size: 18, // Reduced icon size
                ),
              ),
              DropdownButton<String>(
                value: _selectedValue,
                isDense: true, // Makes the dropdown more compact
                underline: SizedBox(),
                items: ["Daily", "Weekly", "Monthly"]
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 12)), // Smaller text
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedValue = newValue);
                  }
                },
              ),
            ],
          ),
          Spacer(flex: 1),
          // Title and chart row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  widget.dailyData.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall, // Changed to titleSmall
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 25, // Reduced height
                  width: 60, // Reduced width
                  child: LineChartWidget(
                    colors: widget.dailyData.colors,
                    spotsData: widget.dailyData.spots,
                  ),
                ),
              ),
            ],
          ),
          Spacer(flex: 1),
          // Progress line
          ProgressLine(
            color: widget.dailyData.color!,
            percentage: widget.dailyData.percentage!,
          ),
          Spacer(flex: 1),
          // Bottom stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "${widget.dailyData.volumeData}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith( // Changed to bodySmall
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  widget.dailyData.totalStorage!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith( // Changed to bodySmall
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}