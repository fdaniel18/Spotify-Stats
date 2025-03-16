import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MusicMoodChart extends StatelessWidget {
  MusicMoodChart({
    super.key,
    required this.valenceValues,
    required this.arousalValues,
    this.width = 1000,
    this.height = 400,
    this.backgroundColor = const Color.fromRGBO(36, 36, 36, 1),
    this.outerBackgroundColor = const Color.fromARGB(255, 65, 65, 65),
    Color? arousalColor1,
    Color? arousalColor2,
    Color? valenceColor1,
    Color? valenceColor2,
  })  : arousalColor1 = arousalColor1 ?? Colors.greenAccent.shade700,
        arousalColor2 = arousalColor2 ?? Colors.greenAccent.shade200,
        valenceColor1 = valenceColor1 ?? Colors.white,
        valenceColor2 = valenceColor2 ?? Colors.white70;

  final double width;
  final double? height;
  final Color arousalColor1;
  final Color arousalColor2;
  final Color valenceColor1;
  final Color valenceColor2;
  final Color backgroundColor;
  final Color outerBackgroundColor;
  final List<double> valenceValues;
  final List<double> arousalValues;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> arousalSpots = arousalValues.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    List<FlSpot> valenceSpots = valenceValues.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    double minY = (valenceValues + arousalValues)
        .reduce((value, element) => value < element ? value : element);
    double maxY = (valenceValues + arousalValues)
        .reduce((value, element) => value > element ? value : element);
    minY = minY - 0.1 < 0 ? 0 : minY - 0.1;
    maxY = maxY + 0.1 > 1 ? 1 : maxY + 0.1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight = height ?? constraints.maxHeight;

        return Container(
          width: width,
          height: chartHeight,
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
          decoration: BoxDecoration(
            color: outerBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      const TextSpan(text: 'The chart for valence and '),
                      TextSpan(
                        text: 'energy',
                        style: TextStyle(color: arousalColor1),
                      ),
                      const TextSpan(
                        text: ':',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: LineChart(
                  LineChartData(
                    backgroundColor: backgroundColor,
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 10,
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            final label = touchedSpot.barIndex == 0
                                ? 'Energy'
                                : 'Valence';
                            return LineTooltipItem(
                              '$label: ${touchedSpot.y.toStringAsFixed(2)}',
                              TextStyle(
                                color: touchedSpot.bar.gradient!.colors.first,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        gradient: LinearGradient(
                          colors: [arousalColor1, arousalColor2],
                        ),
                        spots: arousalSpots,
                        isCurved: false,
                        isStrokeCapRound: true,
                        barWidth: 10,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 12,
                              color: Color.lerp(
                                arousalColor1,
                                arousalColor2,
                                percent / 100,
                              )!,
                              strokeColor: Colors.white,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        dashArray: [5, 5],
                      ),
                      LineChartBarData(
                        gradient: LinearGradient(
                          colors: [valenceColor1, valenceColor2],
                        ),
                        spots: valenceSpots,
                        isCurved: false,
                        isStrokeCapRound: true,
                        barWidth: 10,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 12,
                              color: Color.lerp(
                                valenceColor1,
                                valenceColor2,
                                percent / 100,
                              )!,
                              strokeColor: Colors.white,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        dashArray: [5, 5],
                      ),
                    ],
                    minY: minY,
                    maxY: 1.0,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value <= 1.0 && value >= 0.0) {
                              return Text(
                                value.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                          interval: 0.2,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 0.2,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade600,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade600,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
