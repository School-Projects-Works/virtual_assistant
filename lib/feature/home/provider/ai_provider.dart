import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_assistant/feature/home/data/chat_model.dart';
import 'package:virtual_assistant/feature/home/services/opne_ai_services.dart';

final userInputProvider = StateProvider<String>((ref) => '');

final chatProvider = StateNotifierProvider<ChatProvider, List<ChatModel>>(
    (ref) => ChatProvider());

class ChatProvider extends StateNotifier<List<ChatModel>> {
  ChatProvider() : super([]);

  void addChat(ChatModel chat) {
    state = [...state, chat];
  }

  void removeChat(ChatModel chat) {
    state = state.where((element) => element.id != chat.id).toList();
  }

  void updateChat(ChatModel chat) {
    state = state.map((e) => e.id == chat.id ? chat : e).toList();
  }

  void sendRequest(
      {required WidgetRef ref, required BuildContext context,
     }) async {
    ref.read(loagingProvider.notifier).state = true;
    var input = ref.watch(userInputProvider);
    var chat = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: input,
      name: 'User',
      type: 'text',
      time: DateTime.now().millisecondsSinceEpoch,
    );
    addChat(chat);
    final OpenAIService openAIService = OpenAIService();
    var response =
        await openAIService.isArtPromptAPI(ref.read(userInputProvider));
    if (response.contains('https')) {
      var chat = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: response,
        name: 'AI',
        type: 'image',
        time: DateTime.now().millisecondsSinceEpoch,
      );
      addChat(chat);
    } else {
      var chat = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: response,
        name: 'AI',
        type: 'text',
        time: DateTime.now().millisecondsSinceEpoch,
      );
      addChat(chat);
    }
    ref.read(loagingProvider.notifier).state = false;
    ref.read(userInputProvider.notifier).state = '';
  }
}

final loagingProvider = StateProvider<bool>((ref) => false);
final systemPlaying = StateProvider<bool>((ref) => false);
