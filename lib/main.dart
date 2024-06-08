import 'package:flutter/material.dart';
import 'package:flutter2/models/items.dart';
import 'package:flutter2/pages/cart_page.dart';
import 'package:flutter2/pages/drawer.dart';
import 'dart:convert';
import 'package:flutter2/pages/product_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _welcomeOpacity = 0;
  double _loginOpacity = 0;
  bool showLoginPref = false;

  @override
  void initState() {
    super.initState();

    checkLogin();

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _welcomeOpacity = 1;
      });
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _loginOpacity = 1;
      });
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      if(showLoginPref){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      }
    });
  }

  Future<void> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showLoginPref = prefs.containsKey('Name');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: _welcomeOpacity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      'Welcome to Flutter 2',
                      style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'cursive',
                          color: Colors.deepPurple.shade600),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
                child: Image.asset(
                  'assets/images/welcome_image.png',
                  fit: BoxFit.fill,
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              if(showLoginPref == false)
                AnimatedOpacity(
                  duration: const Duration(seconds: 3),
                  opacity: _loginOpacity,
                  child: const LoginPage(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  String email = '';
  String mobile = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text(
            'Enter Login details',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'posh'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Name',
                suffixIcon: Icon(
                  Icons.home,
                  color: Colors.deepPurple.shade600,
                ),
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                name = value;
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
                suffixIcon: Icon(
                  Icons.email,
                  color: Colors.deepPurple.shade600,
                ),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                labelText: 'Contact',
                suffixIcon: Icon(
                  Icons.call,
                  color: Colors.deepPurple.shade600,
                ),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                mobile = value;
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade600,
              foregroundColor: Colors.white,
              elevation: 10.0,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async{
              if(name == '' || email == '' || mobile == ''){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter all details'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }else{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('Name', name);
                prefs.setString('Email', email);
                prefs.setString('Mobile num', mobile);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ),
                );
              }
            },
            child: const Text('Login'),
          ),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items = [];
  List<Item> cartItems = [];
  List<dynamic> itemsData = [];
  var dataUrl = Uri.parse(
      'https://drive.google.com/uc?export=download&id=1FrfXJMVj9CPq4VlfcKvp3kla7z5Xe0pE');

  Future<List<dynamic>> loadItemsData() async {
    List<dynamic> itemsData = [];
    http.Response httpResponse = await http.get(dataUrl);
    if (httpResponse.statusCode == 200) {
      Map<String, dynamic> jsonData = await json.decode(httpResponse.body);
      for (var item in jsonData['items']) {
        itemsData.add(item);
      }
      // print(itemsData[7]);
    } else {
      // print('Failed to load data: ${httpResponse.statusCode}');
    }
    return itemsData;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1), () async {
      itemsData = await loadItemsData();
      reload();
    });
  }

  void reload() {
    items = itemsData.map<Item>((item) => Item.listFromJsonMap(item)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Flutter 2 Shop',
            style: TextStyle(
              fontFamily: 'posh',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Hero(
              tag: items[index].id,
              child: Card(
                  child: ListTile(
                      leading: Image.network(
                        items[index].imageUrl,
                        filterQuality: FilterQuality.high,
                        width: 60,
                        fit: BoxFit.fitHeight,
                      ),
                      title: Text(items[index].name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'cursive',
                              wordSpacing: 2)),
                      subtitle: Text(items[index].description,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'normal',
                              color: Colors.grey.shade600)),
                      trailing: Text('\$${items[index].price}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'normal',
                              color: Colors.deepPurple)),
                      contentPadding: const EdgeInsets.all(8),
                      horizontalTitleGap: 10.0,
                      titleAlignment: ListTileTitleAlignment.center,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                      item: items[index],
                                      cartItems: cartItems,
                                    )));
                      })),
            );
          },
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        ),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyCartPage(
                          cartItems: cartItems,
                        )));
          },
          backgroundColor: Colors.blue.shade300,
          elevation: 15.0,
          splashColor: Colors.transparent,
          tooltip: 'Items in Cart',
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enableFeedback: true,
          child: const Icon(Icons.shopping_cart),
        ),
      );
    }
  }
}
