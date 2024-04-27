import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_assistant/feature/books/data/book_model.dart';
import 'package:virtual_assistant/feature/books/services/book_services.dart';

final queryProvider = StateProvider<String>((ref) => 'Research Methods');
final isbnProvider = StateProvider<String>((ref) => '');
final bookStreamProvider = StreamProvider<BookModel>((ref) async* {
  final query = ref.watch(queryProvider);
  final isbn = ref.watch(isbnProvider);


    final bookService = await BookService.getBooksBySearch(
        query.isEmpty ? 'Research Methods' : query);

    yield bookService;
});


 final isbnStreamProvider = StreamProvider<BookModel>((ref) async* {
  final isbn = ref.watch(isbnProvider);
  if (isbn.isNotEmpty) {
    final bookService = await BookService.getBookByISBN(isbn);
    yield bookService;
  }
});