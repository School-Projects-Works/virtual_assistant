import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:virtual_assistant/feature/books/view/components/book_item.dart';
import 'package:virtual_assistant/feature/books/view/components/web_view_page.dart';
import 'package:virtual_assistant/utils/pallet.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({
    super.key,
    this.authors,
    this.title,
    this.image,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.averageRating,
    this.description,
    this.previewLink,
  });

  final String? authors;
  final String? title;
  final String? image;
  final String? publisher;
  final String? publishedDate;
  final int? pageCount;
  final num? averageRating;
  final String? description;
  final String? previewLink;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Pallet.accentColor,
          title: const Text('Book Detail'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 45),
                    child: CachedNetworkImage(
                      imageUrl: image!,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                        color: Pallet.accentColor,
                      )),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Pallet.accentColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Author : ',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                  text: authors,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Publisher : ',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                  text: publisher,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Published Date: ',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                  text: publishedDate,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Number of Pages : ',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                  text: pageCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Average Rating : ',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                  text: averageRating.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Description',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Pallet.accentColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Pallet.backgroundColor,
                    border: Border.all(width: 1, color: Pallet.accentColor),
                  ),
                  child: Text(
                    description ?? 'Description Not Available',
                    textAlign: TextAlign.justify,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Pallet.accentColor, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(0),
                  child: buildDefaultButton(
                      backgroundColor: Pallet.secondaryColor,
                      shadowColor: Pallet.secondaryColor,
                      textColor: Colors.white,
                      function: () {
                        navigateTo(context, WebViewScreen(url: previewLink));
                        return null;
                      },
                      text: 'Preview')),
            ],
          ),
        ));
  }
}
