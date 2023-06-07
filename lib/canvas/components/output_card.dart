import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OutputCard extends HookWidget {
  final Map<String, String> results;

  const OutputCard({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 40.0),
      shadowColor: Colors.lightBlueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: ListView.separated(
        itemBuilder: (context, index) {
          final data = results.entries.elementAt(index);
          return ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Center(child: Text(data.key)),
            subtitle: Center(child: Text(data.value)),
            onTap: () => Clipboard.setData(ClipboardData(text: data.value)),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          endIndent: 100.0,
          indent: 100.0,
        ),
        itemCount: results.length,
      ),
    );
  }
}
