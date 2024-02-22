import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student/ui/components/navigator/nextup_class_preview.dart';
import 'package:student/ui/components/navigator/nextup_class.dart';

class HomeNextupClassCard extends StatefulWidget {
  final NextupClassView nextupClass;
  const HomeNextupClassCard(this.nextupClass, {super.key});

  @override
  State<HomeNextupClassCard> createState() => _HomeNextupClassCardState();
}

class _HomeNextupClassCardState extends State<HomeNextupClassCard> {
  String timeLeft(DateTime startTime, DateTime endTime) {
    Duration diffEnd = endTime.difference(DateTime.now());
    if (diffEnd.inMinutes < 0) return "ended";
    Duration diffStart = startTime.difference(DateTime.now());
    String hour = "";
    if (diffStart.inHours > 0) hour += "${diffStart.inHours}h";
    if (diffStart.inMinutes < 0) return "now";
    return "$hour${diffStart.inMinutes}m";
  }

  String hmFormat(DateTime time) => DateFormat("HH:mm").format(time);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Text textTile(
      String text, {
      double? fontSize,
      FontWeight? fontWeight,
      TextOverflow? overflow,
    }) {
      return Text(
        text,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize,
          color: colorScheme.onSecondaryContainer,
          fontWeight: fontWeight,
        ),
      );
    }

    return SizedBox(
      width: 280,
      child: Card.filled(
        elevation: 0,
        // color: colorScheme.primaryContainer,
        color: Colors.transparent,
        margin: const EdgeInsets.only(left: 16),
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.zero,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ElevatedButton(
          onPressed: () {
            showBottomSheet(
              context: context,
              builder: ((BuildContext context) {
                return NextupClassSheet(widget.nextupClass);
              }),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            backgroundColor: colorScheme.secondaryContainer,
            shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.zero,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  textTile(
                    "${widget.nextupClass.room} - ",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  Icon(
                    Icons.alarm,
                    color: colorScheme.onSecondaryContainer,
                    size: 18,
                  ),
                  textTile(
                    timeLeft(
                      widget.nextupClass.startTime,
                      widget.nextupClass.endTime,
                    ),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              textTile(
                widget.nextupClass.classId,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
              textTile(
                widget.nextupClass.classDesc,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textTile(
                "Time: ${hmFormat(widget.nextupClass.startTime)} - ${hmFormat(widget.nextupClass.endTime)}",
                fontSize: 14,
              ),
              textTile(
                "Teacher: ${widget.nextupClass.teacher}",
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
