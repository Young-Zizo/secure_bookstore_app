import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  runApp(SecureBookstoreApp());
}

class SecureBookstoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secure Bookstore',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: BookstoreScreen(),
    );
  }
}

class BookstoreScreen extends StatefulWidget {
  @override
  _BookstoreScreenState createState() => _BookstoreScreenState();
}

class _BookstoreScreenState extends State<BookstoreScreen> {
  final itemController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  String originalHash = "";
  String resultText = "اختر كتاباً ثم قم بتأمين الطلب";
  Color resultColor = Colors.grey.shade300;
  Color resultTextColor = Colors.black87;

  final String secretKey = "my_super_secret_key";

  final List<Map<String, dynamic>> books = [
    {
      "title": "Cybersecurity 101",
      "price": "120",
      "icon": Icons.security,
      "color": Colors.redAccent
    },
    {
      "title": "Flutter UI Mastery",
      "price": "85",
      "icon": Icons.phone_android,
      "color": Colors.blueAccent
    },
    {
      "title": "Clean Code Basics",
      "price": "95",
      "icon": Icons.code,
      "color": Colors.green
    },
  ];

  void selectBook(String title, String price) {
    setState(() {
      itemController.text = title;
      priceController.text = price;
      quantityController.text = "1";

      originalHash = "";

      resultText =
          "تم اختيار '$title'\nيرجى الضغط على Generate Hash لتأمين الطلب";

      resultColor = Colors.indigo.shade50;
      resultTextColor = Colors.indigo.shade900;
    });
  }

  String generateHash(String data) {
    var key = utf8.encode(secretKey);
    var bytes = utf8.encode(data);

    var hmacSha256 = Hmac(sha256, key);

    return hmacSha256.convert(bytes).toString();
  }

  void createHash() {
    if (itemController.text.isEmpty ||
        priceController.text.isEmpty ||
        quantityController.text.isEmpty) {
      setState(() {
        resultText = "⚠️ الرجاء اختيار كتاب أولاً";
        resultColor = Colors.orange.shade100;
        resultTextColor = Colors.orange.shade900;
      });
      return;
    }

    String order =
        "${itemController.text}-${priceController.text}-${quantityController.text}";

    originalHash = generateHash(order);

    setState(() {
      resultText = "🔒 Hash Generated:\n$originalHash";

      resultColor = Colors.blue.shade100;
      resultTextColor = Colors.blue.shade900;
    });
  }

  void verifyOrder() {
    if (originalHash.isEmpty) {
      setState(() {
        resultText = "⚠️ الرجاء إنشاء Hash أولاً";
        resultColor = Colors.orange.shade100;
        resultTextColor = Colors.orange.shade900;
      });
      return;
    }

    String currentOrder =
        "${itemController.text}-${priceController.text}-${quantityController.text}";

    String currentHash = generateHash(currentOrder);

    setState(() {
      if (currentHash == originalHash) {
        resultText =
            "✅ Order Verified\nالطلب آمن ولم يتم التلاعب ببيانات الكتاب";

        resultColor = Colors.green.shade100;
        resultTextColor = Colors.green.shade900;
      } else {
        resultText =
            "❌ Integrity Check Failed\nتحذير: تم التلاعب في سعر الكتاب أو تفاصيله!";

        resultColor = Colors.red.shade100;
        resultTextColor = Colors.red.shade900;
      }
    });
  }

  void modifyPrice() {
    if (itemController.text.isEmpty) return;

    setState(() {
      priceController.text = "9999";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "📚 Secure Electronic Bookstore",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.indigo.shade50,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available Books",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            leading: CircleAvatar(
                              backgroundColor: books[index]['color'],
                              child: Icon(
                                books[index]['icon'],
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              books[index]['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              "\$${books[index]['price']}",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => selectBook(
                                books[index]['title'],
                                books[index]['price'],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              child: Text(
                                "Select",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Order Details & Security",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            controller: itemController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Book Title",
                              prefixIcon: Icon(
                                Icons.menu_book,
                                color: Colors.indigo,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: priceController,
                            decoration: InputDecoration(
                              labelText: "Price (\$)",
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.indigo,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              prefixIcon: Icon(
                                Icons.production_quantity_limits,
                                color: Colors.indigo,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: createHash,
                    icon: Icon(Icons.lock_outline,
                        color: Colors.white),
                    label: Text(
                      "1. Generate Order Hash (Secure Data)",
                      style: TextStyle(
                          fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding:
                          EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: verifyOrder,
                    icon: Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      "2. Verify Integrity",
                      style: TextStyle(
                          fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding:
                          EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: modifyPrice,
                    icon: Icon(
                      Icons.bug_report_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      "3. Simulate Hacker Attack",
                      style: TextStyle(
                          fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      padding:
                          EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: resultColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color:
                            resultTextColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      resultText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: resultTextColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}