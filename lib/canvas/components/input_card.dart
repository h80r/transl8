import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InputCard extends HookWidget {
  final void Function(String input) onTranslate;
  final bool isLoading;

  const InputCard({
    super.key,
    required this.onTranslate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8.0,
        margin: const EdgeInsets.all(0.0),
        shadowColor: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: TextFormField(
          initialValue:
              'Se você deseja saber mais sobre como utilizamos cookies, clique aqui.',
          maxLines: null,
          textAlign: TextAlign.center,
          onFieldSubmitted: isLoading ? null : onTranslate,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.center,
            label: Center(child: Text('Frase para traduzir')),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
