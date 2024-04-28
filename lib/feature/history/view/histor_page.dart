import 'package:animate_do/animate_do.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:virtual_assistant/feature/history/provider/chat_pair_provider.dart';
import 'package:virtual_assistant/feature/home/data/chat_model.dart';
import 'package:virtual_assistant/feature/home/provider/ai_provider.dart';
import 'package:virtual_assistant/feature/users/provider/auth_provider.dart';

import '../../../utils/pallet.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final flutterTts = FlutterTts();
  @override
  void initState() {
    super.initState();
    initTextToSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
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
  Widget build(BuildContext context) {
    var chatProvider = ref.watch(chatPairStreamProvider);
    var user = ref.watch(authProvider);
    return Column(
      children: [
        const Text('Chat History',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        const Divider(
          // 1
          height: 20,
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
        Expanded(
          child: chatProvider.when(data: (data) {
            if (data.isNotEmpty) {
              var group = groupBy(data, (p0) {
                var now = DateTime.fromMillisecondsSinceEpoch(p0.dateTime!);
                return DateFormat('yyyy-MM-dd').format(now);
              });
              return ListView.builder(
                  itemCount: group.keys.length,
                  itemBuilder: (context, index) {
                    var title = group.keys.toList()[index];
                    var list = group[title];
                    if (list != null) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        subtitle: Column(
                          children: list.map((e) {
                            List<ChatModel> items = [
                              ChatModel.fromMap(e.user!),
                              ChatModel.fromMap(e.ai!)
                            ];
                            return Column(
                              children: items.map((chat) {
                                return chat.type == 'text'
                                    ? FadeInRight(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2,
                                              vertical:
                                                  chat.name == 'User' ? 1 : 5,
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 25),
                                            decoration: BoxDecoration(
                                              color: chat.name == 'User'
                                                  ? Pallet.whiteColor
                                                  : Pallet
                                                      .thirdSuggestionBoxColor
                                                      .withOpacity(.5),
                                              border: chat.name == 'User'
                                                  ? null
                                                  : Border.all(
                                                      color: Pallet.borderColor,
                                                    ),
                                              borderRadius: chat.name == 'User'
                                                  ? null
                                                  : BorderRadius.circular(10)
                                                      .copyWith(
                                                      topLeft: Radius.zero,
                                                    ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          chat.name == 'User'
                                                              ? user.name!
                                                              : 'Virtual Assistant',
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Cera Pro',
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        if (chat.name != 'User')
                                                          //audio play button
                                                          if (ref.watch(
                                                              systemPlaying))
                                                            GestureDetector(
                                                              onTap: () async {
                                                                await stopSpeaking();
                                                              },
                                                              child: const Icon(
                                                                  Icons.stop),
                                                            )
                                                          else
                                                            GestureDetector(
                                                              onTap: () async {
                                                                await systemSpeak(
                                                                    chat.message!);
                                                              },
                                                              child: const Icon(
                                                                  Icons
                                                                      .volume_up),
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    chat.message!,
                                                    style: TextStyle(
                                                      fontFamily: 'Cera Pro',
                                                      color:
                                                          Pallet.mainFontColor,
                                                      fontSize:
                                                          chat.name == 'User'
                                                              ? 16
                                                              : 17,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        Dialog(
                                                      child: Image.network(
                                                          chat.message!),
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  });
            } else {
              return const Center(child: Text('No data found'));
            }
          }, error: (error, stack) {
            return const Center(child: Text('Error getting History'));
          }, loading: () {
            return const Center(
              child: SpinKitFadingCircle(
                color: Colors.black54,
                size: 45.0,
              ),
            );
          }),
        ),
      ],
    );
  }
}
