import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:virtual_assistant/core/views/custom_dialog.dart';
import 'package:virtual_assistant/feature/books/data/book_model.dart';
import 'package:virtual_assistant/feature/books/provider/book_provider.dart';
import 'package:virtual_assistant/feature/books/view/components/book_item.dart';
import 'package:virtual_assistant/feature/books/view/search_by_isbn.dart';
import 'package:virtual_assistant/utils/pallet.dart';

class BooksListScreen extends ConsumerStatefulWidget {
  const BooksListScreen({super.key});

  @override
  ConsumerState<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends ConsumerState<BooksListScreen> {
  final _searchController = TextEditingController(text: 'Research Methods');
  final _isbnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var books = ref.watch(bookStreamProvider);
    return Scaffold(
        floatingActionButton: PopupMenuButton(
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'Scan',
                child: Row(
                  children: [
                    Icon(Icons.barcode_reader),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Scarn Barcode'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'type',
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Enter ISBN'),
                  ],
                ),
              ),
            ];
          },
          onSelected: (value) async {
            //Todo here i will find book by ISBN number
            if (value.toLowerCase() == 'scan') {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));
              ref.read(isbnProvider.notifier).state = res;
              if (mounted) {
                navigateTo(context, const SearchByISBN());
              }
            } else {
              CustomDialog.showCustom(
                  width: MediaQuery.of(context).size.width * 0.8,
                  autoDismiss: true,
                  height: 200,
                  ui: Card(
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text('Enter ISBN number'),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _isbnController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: BeveledRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        backgroundColor: Pallet.mainFontColor,
                                        foregroundColor: Colors.white),
                                    onPressed: () {
                                      ref.read(isbnProvider.notifier).state =
                                          _isbnController.text;
                                      if (mounted &&
                                          _isbnController.text.isNotEmpty) {
                                        navigateTo(
                                            context, const SearchByISBN());
                                        CustomDialog.dismiss();
                                      }
                                    },
                                    child: const Text('Find Book')),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
            }
          },
          child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: const Icon(Icons.qr_code)),
        ),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 5),
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          onTap: () {
                            ref.read(queryProvider.notifier).state =
                                _searchController.text;
                          },
                          child: const Icon(Icons.search)),
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                  onFieldSubmitted: (value) {
                    // context.read(bookProvider.notifier).getBooksBySearch(value);
                  },
                ),
                const SizedBox(height: 5),
                books.when(data: (data) {
                  return Expanded(
                      child: GridView.builder(
                    itemCount: data.items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 15.0),
                    itemBuilder: (context, index) {
                      Item item = data.items[index];
                      return buildBookItem(item, context);
                    },
                  ));
                }, error: (error, stack) {
                  return Center(child: Text(error.toString()));
                }, loading: () {
                  return const Expanded(
                    child: Center(
                      child: SpinKitFadingCircle(
                        color: Colors.black54,
                        size: 45.0,
                      ),
                    ),
                  );
                })
              ],
            )));
  }
}
