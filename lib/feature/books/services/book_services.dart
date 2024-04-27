import 'package:http/http.dart' as http;
import 'package:virtual_assistant/feature/books/data/book_model.dart';

class BookService {
  static Future<BookModel> getBooks() async {
    var url =
        'https://www.googleapis.com/books/v1/volumes?q=Research+Methods&maxResults=30&orderBy=newest';
    final res = await http.get(Uri.parse(url));
    final responseBody = res.body;
    //remove duplicate

    BookModel bookModel = bookModelFromJson(responseBody);
    return bookModel;
  }

  static Future<BookModel> getBooksBySearch(
      String book) async {
    var url =
        'https://www.googleapis.com/books/v1/volumes?q="$book"&maxResults=40&orderBy=newest';
    final res = await http.get(Uri.parse(url));
    final resposeBody = res.body;
    BookModel bookModel = bookModelFromJson(resposeBody);
    return bookModel;
  }

  static Future<BookModel> getBookByISBN(String isbn) async {
    var url =
        'https://www.googleapis.com/books/v1/volumes?q=$isbn&orderBy=relevance';
    final res = await http.get(Uri.parse(url));
    final responseBody = res.body;
    BookModel bookModel = bookModelFromJson(responseBody);
    return bookModel;
  }
}
