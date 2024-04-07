import 'package:flutter/material.dart';

class SubsDataScreen extends StatelessWidget {
  const SubsDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ListView(
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 16,
                ),
              ),
              title: Text(
                'Khadija Barhou',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer Flutter',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'DeadLine Time: 12/09/2024',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 16,
                ),
              ),
              title: Text(
                'Khadija Barhou',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer Flutter',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'DeadLine Time: 12/09/2024',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 16,
                ),
              ),
              title: Text(
                'Khadija Barhou',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer Flutter',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'DeadLine Time: 12/09/2024',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 16,
                ),
              ),
              title: Text(
                'Khadija Barhou',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer Flutter',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'DeadLine Time: 12/09/2024',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 16,
                ),
              ),
              title: Text(
                'Khadija Barhou',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer Flutter',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'DeadLine Time: 12/09/2024',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 16,
                ),
              ),
              title: Text(
                'Khadija Barhou',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer Flutter',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'DeadLine Time: 12/09/2024',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
