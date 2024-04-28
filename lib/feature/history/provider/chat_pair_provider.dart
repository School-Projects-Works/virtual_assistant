import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_assistant/feature/home/data/chat_pair.dart';
import 'package:virtual_assistant/feature/home/services/opne_ai_services.dart';

final chatPairStreamProvider =
    StreamProvider.autoDispose<List<ChatPair>>((ref) async* {
  final chatPairProvider = await OpenAIService.getChatPair();
  //hroup the chat pairs by date
  yield chatPairProvider;
});
