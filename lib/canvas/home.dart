import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:transl8/canvas/components/config_card.dart';
import 'package:transl8/canvas/components/flexible_progress_indicator.dart';
import 'package:transl8/canvas/components/input_card.dart';
import 'package:transl8/canvas/components/output_card.dart';

class HomeCanvas extends StatefulWidget {
  const HomeCanvas({super.key});

  @override
  State<HomeCanvas> createState() => _HomeCanvasState();
}

class _HomeCanvasState extends State<HomeCanvas> {
  final history = <OpenAIChatCompletionChoiceMessageModel>[];

  var validConfig = false;
  var isLoadingConfig = false;

  Map<String, String>? currentResponse;
  var isLoadingResponse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.lerp(Colors.deepPurple, Colors.black, 0.7),
      body: Center(
        child: SizedBox(
          width: 600.0,
          child: Column(children: [
            Flexible(
              flex: 2,
              child: ConfigCard(
                isValid: validConfig,
                isLoading: isLoadingConfig,
                onConfigChanged: setupAssistant,
              ),
            ),
            if (validConfig)
              Flexible(
                child: InputCard(
                  onTranslate: getTranslation,
                  isLoading: isLoadingResponse,
                ),
              ),
            if (isLoadingConfig) const FlexibleProgressIndicator(),
            if (currentResponse != null)
              Flexible(flex: 2, child: OutputCard(results: currentResponse!)),
            if (isLoadingResponse) const FlexibleProgressIndicator(flex: 2),
          ]),
        ),
      ),
    );
  }

  void getTranslation(String input) async {
    setState(() {
      isLoadingResponse = true;
      currentResponse = null;
    });

    final msg = OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.user,
      content: input,
    );

    final response = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [...history, msg],
    );

    final answer = response.choices.last.message;

    history.add(msg);
    history.add(answer);

    setState(() {
      isLoadingResponse = false;
      currentResponse =
          (jsonDecode(answer.content) as Map).cast<String, String>();
    });
  }

  void setupAssistant(
    String originLanguage,
    List<String> targetLanguages,
  ) async {
    setState(() {
      validConfig = false;
      isLoadingConfig = true;
    });

    final initialPrompt = '''
      Você é um tradutor universal. Depois desta mensagem, toda mensagem que eu enviar será um texto para tradução com idioma originário em $originLanguage.
      Você deve responder apenas em formato JSON, no qual as chaves sejam os idiomas de destino ${targetLanguages.join(', ')} e os valores serão o resultado da tradução obtida.
      Caso um dos idiomas de destino informados acima não exista, retorne como valor para sua chave a mensagem "O idioma de destino selecionado não está disponível" no idioma originário selecionado acima.
      Suas respostas não devem conter nada além do JSON estipulado. Caso tenha entendido todas as instruções responda apenas com "OK".
    ''';

    final msg = OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.user,
      content: initialPrompt,
    );

    final response = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [msg],
    );

    final answer = response.choices.first.message;
    if (answer.content.contains('OK')) {
      history.add(msg);
      history.add(answer);

      setState(() {
        validConfig = true;
        isLoadingConfig = false;
      });
    } else {
      setState(() {
        validConfig = false;
        isLoadingConfig = false;
      });
    }
  }
}
