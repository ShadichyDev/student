import 'package:flutter/material.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/section_label.dart';

class TimetableWidget extends StatefulWidget {
  final TimetableData timetableData;
  const TimetableWidget(this.timetableData, {super.key});

  @override
  State<TimetableWidget> createState() => _TimetableWidgetState();
}

class _TimetableWidgetState extends State<TimetableWidget> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SectionLabel(
          "Thời khoá biểu",
          Option(Icons.arrow_forward, "", () {}),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: colorScheme.onTertiaryContainer,
        ),
        Card(
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.zero,
              backgroundColor: colorScheme.background,
              shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.zero,
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.primary.withAlpha(20),
                  width: 1,
                ),
              ),
            ),
            child: Column(children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(20),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      "${1}",
                      style: TextStyle(
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ),
                  Text(""),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(20),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconOption(
                          Option(
                            Icons.keyboard_arrow_left,
                            "",
                            () {},
                          ),
                          iconSize: 28,
                          padding: const EdgeInsets.all(4),
                          backgroundColor: colorScheme.tertiaryContainer,
                          iconColor: colorScheme.onTertiaryContainer,
                        ),
                        Expanded(
                          child: Text(
                            "${1} classes left",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: colorScheme.onTertiaryContainer),
                          ),
                        ),
                        IconOption(
                          Option(
                            Icons.keyboard_arrow_right,
                            "",
                            () {},
                          ),
                          iconSize: 28,
                          padding: const EdgeInsets.all(4),
                          backgroundColor: colorScheme.tertiaryContainer,
                          iconColor: colorScheme.onTertiaryContainer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: Text(" lmao"),
              )
            ]),
          ),
        ),
      ],
    );
  }
}
