import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:virtual_assistant/core/functions/greetings.dart';
import 'package:virtual_assistant/feature/home/provider/ai_provider.dart';
import 'package:virtual_assistant/feature/home/view/components/featured_box.dart';
import 'package:virtual_assistant/feature/users/provider/auth_provider.dart';
import 'package:virtual_assistant/generated/assets.dart';
import 'package:virtual_assistant/utils/pallet.dart';

import '../services/opne_ai_services.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }
    Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    ref.read(userInputProvider.notifier).state = result.recognizedWords;
    // setState(() {
    //   lastWords = result.recognizedWords;
    // });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
    ref.read(systemPlaying.notifier).state = true;
  }
   Future<void> stopSpeaking() async {
    await flutterTts.stop();
    ref.read(systemPlaying.notifier).state = false;
   }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = ref.watch(authProvider);
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            // virtual assistant picture
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ZoomIn(
                child: CircleAvatar(
                  backgroundColor: Pallet.assistantCircleColor,
                  radius: 35,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(Assets.imagesPAIcon),
                  ),
                ),
              ),
            ),
            if (ref.watch(chatProvider).isNotEmpty)
              Expanded(
                child: ListView.builder(
                    itemCount: ref.watch(chatProvider).length,
                    itemBuilder: (context, index) {
                      var chat = ref.watch(chatProvider)[index];
                      return chat.type == 'text'
                          ? FadeInRight(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: chat.name == 'User' ? 1 : 5,
                                  ),
                                  margin: const EdgeInsets.only(right: 25),
                                  decoration: BoxDecoration(
                                    color: chat.name == 'User'
                                        ? Pallet.whiteColor
                                        : Pallet.thirdSuggestionBoxColor
                                            .withOpacity(.5),
                                    border: chat.name == 'User'
                                        ? null
                                        : Border.all(
                                            color: Pallet.borderColor,
                                          ),
                                    borderRadius: chat.name == 'User'
                                        ? null
                                        : BorderRadius.circular(10).copyWith(
                                            topLeft: Radius.zero,
                                          ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                chat.name == 'User'
                                                    ? user.name!
                                                    : 'Virtual Assistant',
                                                style: const TextStyle(
                                                  fontFamily: 'Cera Pro',
                                                  color: Colors.black54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              if (chat.name != 'User')
                                                //audio play button
                                                if (ref.watch(systemPlaying))
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await stopSpeaking();
                                                    },
                                                    child:
                                                        const Icon(Icons.stop),
                                                  )
                                                else
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await systemSpeak(
                                                          chat.message!);
                                                    },
                                                    child: const Icon(
                                                        Icons.volume_up),
                                                  ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          chat.message!,
                                          style: TextStyle(
                                            fontFamily: 'Cera Pro',
                                            color: Pallet.mainFontColor,
                                            fontSize:
                                                chat.name == 'User' ? 16 : 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : FadeInLeft(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Image.network(chat.message!),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          chat.message!,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    }),
              ),
            if (ref.watch(chatProvider).isEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // chat bubble
                      FadeInRight(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 40)
                              .copyWith(
                            top: 20,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Pallet.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(20).copyWith(
                              topLeft: Radius.zero,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              '${greetings()},${user.name!.split(' ')[0]}, what task can I do for you?',
                              style: const TextStyle(
                                fontFamily: 'Cera Pro',
                                color: Pallet.mainFontColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SlideInLeft(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 10, left: 22),
                          child: const Text(
                            'Here are a few features',
                            style: TextStyle(
                              fontFamily: 'Cera Pro',
                              color: Pallet.mainFontColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // features list
                      Column(
                        children: [
                          SlideInLeft(
                            delay: Duration(milliseconds: start),
                            child: const FeatureBox(
                              color: Pallet.firstSuggestionBoxColor,
                              headerText: 'ChatGPT',
                              descriptionText:
                                  'A smarter way to stay organized and informed with ChatGPT',
                            ),
                          ),
                          SlideInLeft(
                            delay: Duration(milliseconds: start + delay),
                            child: const FeatureBox(
                              color: Pallet.secondSuggestionBoxColor,
                              headerText: 'Dall-E',
                              descriptionText:
                                  'Get inspired and stay creative with your personal assistant powered by Dall-E',
                            ),
                          ),
                          SlideInLeft(
                            delay: Duration(milliseconds: start + 2 * delay),
                            child: const FeatureBox(
                              color: Pallet.thirdSuggestionBoxColor,
                              headerText: 'Smart Voice Assistant',
                              descriptionText:
                                  'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

            if (ref.watch(loagingProvider))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ZoomIn(
                    delay: Duration(milliseconds: start + 3 * delay),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      height: 40,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Pallet.mainFontColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Pallet.whiteColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              color: Pallet.whiteColor,
                              fontFamily: 'Cera Pro',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),

            if (!ref.watch(loagingProvider))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ZoomIn(
                  delay: Duration(milliseconds: start + 3 * delay),
                  child: TextFormField(
                    onChanged: (value) {
                      ref.read(userInputProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                        hintText: 'Ask me anything',
                        border: const OutlineInputBorder(),
                        suffixIcon: ref.watch(userInputProvider).isEmpty
                            ? IconButton(
                                onPressed: () async {
                                  if (await speechToText.hasPermission &&
                                      speechToText.isNotListening) {
                                    await startListening();
                                  } else if (speechToText.isListening) {
                                    ref.read(chatProvider.notifier).sendRequest(
                                        ref: ref,
                                        context: context,
                                        );
                                    await stopListening();
                                  } else {
                                    initSpeechToText();
                                  }
                                },
                                icon: Icon(
                                  speechToText.isListening
                                      ? Icons.stop
                                      : Icons.mic,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  ref
                                      .read(chatProvider.notifier)
                                      .sendRequest(ref: ref, context: context,);
                                },
                                icon: const Icon(Icons.send))),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
 
}
