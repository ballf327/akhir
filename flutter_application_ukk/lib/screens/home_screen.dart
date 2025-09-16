import 'package:flutter/material.dart';
import '../api_service.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'change_password_screen.dart'; // import halaman ganti password

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nama = "";

  @override
  void initState() {
    super.initState();
    loadNama();
  }

  Future<void> loadNama() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "";
    });
  }

  void logout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  void showAccountMenu(BuildContext context) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width, // kanan
        kToolbarHeight, // tinggi appbar
        0,
        0,
      ),
      items: const [
        PopupMenuItem(value: 'change_password', child: Text('Ganti Password')),
        PopupMenuItem(value: 'logout', child: Text('Logout')),
      ],
    );

    if (result == 'logout') {
      logout(context);
    } else if (result == 'change_password') {
      // 👉 langsung arahkan ke halaman ganti password
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String initial = nama.isNotEmpty ? nama[0].toUpperCase() : "?";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => showAccountMenu(context),
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  initial,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Selamat datang, $nama!",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}