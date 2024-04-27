//build book item
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_assistant/feature/books/data/book_model.dart';
import 'package:virtual_assistant/feature/books/view/book_details_page.dart';
import 'package:virtual_assistant/utils/pallet.dart';

Widget buildBookItem(Item item, BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: (() {
      navigateTo(
        context,
        BookDetailScreen(
          description: item.volumeInfo.description,
          authors: item.volumeInfo.authors.toString(),
          image: item.volumeInfo.imageLinks?.thumbnail,
          title: item.volumeInfo.title,
          publisher: item.volumeInfo.publisher,
          publishedDate: item.volumeInfo.publishedDate,
          pageCount: item.volumeInfo.pageCount,
          averageRating: item.volumeInfo.averageRating,
          previewLink: item.volumeInfo.previewLink,
        ),
      );
    }),
    child: GridTile(
        child: CachedNetworkImage(
      imageUrl: item.volumeInfo.imageLinks!.thumbnail.toString(),
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: Pallet.accentColor,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    )),
  );
}

//build carousel image items
Widget buildCarouselImageItems(String carouselImage, int index) {
  return Container(
      width: 360,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: Colors.grey,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: carouselImage,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: Pallet.accentColor,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ));
}

//default button
Widget buildDefaultButton({
  double height = 50.0,
  double padding = 16.0,
  required Color backgroundColor,
  required Color shadowColor,
  required Color textColor,
  double radius = 15.0,
  required String? Function() function,
  required String text,
}) {
  return ElevatedButton(
    onPressed: function,
    style: ElevatedButton.styleFrom(
      //onPrimary: textColor,
      backgroundColor: backgroundColor,
      padding: EdgeInsets.all(padding),
      shadowColor: shadowColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    ),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

//Navigate to a screen
void navigateTo(context, widget) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
}

//Navigate and remove previous screen
void navigateAndRemove(context, widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}
