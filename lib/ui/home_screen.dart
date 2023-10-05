import 'package:flutter/material.dart';
import 'package:sqlite_database/model/user_model.dart';
import 'package:sqlite_database/utils/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper db = DatabaseHelper();
  List<UserModel> userData = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite database"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {
          UserModel user = userData[index];
          return ListTile(
            leading: CircleAvatar(child: Text("${user.id}")),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: IconButton(
              onPressed: () async {
                int res = await db.delete(user.id ?? 0);
                getData();
                debugPrint("Record deleted $res");
              },
              icon: const Icon(Icons.delete),
            ),
            onLongPress: () async {
              UserModel users = UserModel(
                  id: user.id,
                  name: "Rajni",
                  email: "jadavrajni0599@gmail.com");

              int res = await db.update(users);
              getData();
              debugPrint("Record updated $res");
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          UserModel user =
              UserModel(name: "Pradip", email: "jadavpradip2002@gmail.com");
          int res = await db.insert(user);
          debugPrint("Record inserted $res");
          getData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getData() async {
    List<UserModel> users = await db.getUser();

    // Update the state with the retrieved user data
    setState(() {
      userData = users;
    });
  }
}
