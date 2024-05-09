import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  final String label;
  final String title;
  final List<Widget> children;
  const EventPage({
    super.key,
    required this.label,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.only(
              top: 64,
              bottom: 32,
              left: 16,
              right: 16,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...children,
        ]),
      ),
    );
  }
}