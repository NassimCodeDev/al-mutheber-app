import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.withOpacity(.1)),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.text,
                    cursorHeight: 20,
                    cursorColor: Colors.deepPurpleAccent,
                    cursorRadius: Radius.circular(4),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'search',
                        hintStyle: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.withOpacity(.4),
                            fontStyle: FontStyle.italic)),
                  )),
                  Icon(Icons.search_rounded, color: Colors.grey.withOpacity(.6))
                ],
              ),
            ),
            Expanded(
                child: Center(
                    child: Text(
              'Nothing',
              style:
                  TextStyle(fontSize: 12.0, color: Colors.grey.withOpacity(.6)),
            ))),
          ],
        ),
      ),
    );
  }
}
