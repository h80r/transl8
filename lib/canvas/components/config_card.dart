import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConfigCard extends HookWidget {
  final void Function(String originLanguage, List<String> destinationLanguages)
      onConfigChanged;
  final bool isValid;
  final bool isLoading;

  const ConfigCard({
    super.key,
    required this.onConfigChanged,
    required this.isValid,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final originInput = useTextEditingController(text: 'Português');
    final destinations = useState(['Inglês', 'Espanhol']);

    return Card(
      elevation: 8.0,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 40.0),
      shadowColor: Colors.lightBlueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 100.0,
                color: isValid ? Colors.green : Colors.red,
              ),
              onPressed: isLoading
                  ? null
                  : () => onConfigChanged(
                        originInput.text,
                        destinations.value,
                      ),
            ),
            const VerticalDivider(width: 24.0),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: originInput,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Idioma de origem',
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      children: List.generate(
                        destinations.value.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: destinations.value[index],
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Idioma de destino ${index + 1}',
                            ),
                            onChanged: (value) {
                              destinations.value[index] = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      (
                        () => destinations.value = [
                              ...destinations.value,
                              'Novo idioma'
                            ],
                        Icons.add,
                      ),
                      (
                        () => destinations.value = [
                              ...destinations.value..removeLast()
                            ],
                        Icons.close
                      )
                    ]
                        .map(
                          (value) => Expanded(
                            child: IconButton(
                              onPressed: value.$1,
                              icon: Icon(value.$2),
                            ),
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
