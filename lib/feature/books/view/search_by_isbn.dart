import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:virtual_assistant/feature/books/data/book_model.dart';
import 'package:virtual_assistant/feature/books/view/components/book_item.dart';
import 'package:virtual_assistant/generated/assets.dart';
import 'package:virtual_assistant/utils/pallet.dart';

import '../provider/book_provider.dart';

class SearchByISBN extends ConsumerStatefulWidget {
  const SearchByISBN({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchByISBNState();
}

class _SearchByISBNState extends ConsumerState<SearchByISBN> {
  @override
  Widget build(BuildContext context) {
    var books = ref.watch(isbnStreamProvider);
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Assets.imagesPALogo, height: 50),
          ),
          backgroundColor: Pallet.whiteColor,
          elevation: 0,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                //text to diplay isbn code
                Text(
                  'Results for ISBN: ${ref.watch(isbnProvider)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: books.when(
                    data: (book) {
                      var remainingBooks =
                          book.items.isNotEmpty && book.items.length > 1
                              ? book.items.sublist(1)
                              : [];
                      if (book.items.isEmpty) {
                        return const Center(
                          child: Text('No book found'),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildBookItem(book.items[0], context),
                          if (remainingBooks.isNotEmpty)
                            const Text(
                              'Related Books',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          if (remainingBooks.isNotEmpty)
                            Expanded(
                              child: GridView.builder(
                                itemCount: remainingBooks.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 15.0,
                                        crossAxisSpacing: 15.0),
                                itemBuilder: (context, index) {
                                  Item item = remainingBooks[index];
                                  return buildBookItem(item, context);
                                },
                              ),
                            ),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: SpinKitFadingCircle(
                        color: Pallet.accentColor,
                        size: 50.0,
                      ),
                    ),
                    error: (error, stackTrace) => Center(
                      child: Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
