import 'dart:convert';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_guard/Models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<Message> msgs = [];
  bool isTyping = false;
  void sendMsg() async {
    String text = controller.text;
    controller.clear();
    // String schema =
    // "### Instructions: Your task is to convert a question into a SQL query, given a Postgres database schema. Adhere to these rules: - *Deliberately go through the question and database schema word by word* to appropriately answer the question - *Use Table Aliases* to prevent ambiguity. For example, SELECT table1.col1, table2.col1 FROM table1 JOIN table2 ON table1.id = table2.id. - When creating a ratio, always cast the numerator as float - if the question cannot be answered given the database schema, return 'I do not know' ### Input: Generate a SQL query that answers the question $text. This query will run on a database whose schema is represented in this string: CREATE TABLE products ( product_id INTEGER PRIMARY KEY, -- Unique ID for each product name VARCHAR(50), -- Name of the product price DECIMAL(10,2), -- Price of each unit of the product quantity INTEGER -- Current quantity in stock ); CREATE TABLE customers ( customer_id INTEGER PRIMARY KEY, -- Unique ID for each customer name VARCHAR(50), -- Name of the customer address VARCHAR(100) -- Mailing address of the customer ); CREATE TABLE salespeople ( salesperson_id INTEGER PRIMARY KEY, -- Unique ID for each salesperson name VARCHAR(50), -- Name of the salesperson region VARCHAR(50) -- Geographic sales region ); CREATE TABLE sales ( sale_id INTEGER PRIMARY KEY, -- Unique ID for each sale product_id INTEGER, -- ID of product sold customer_id INTEGER, -- ID of customer who made purchase salesperson_id INTEGER, -- ID of salesperson who made the sale sale_date DATE, -- Date the sale occurred quantity INTEGER -- Quantity of product sold ); CREATE TABLE product_suppliers ( supplier_id INTEGER PRIMARY KEY, -- Unique ID for each supplier product_id INTEGER, -- Product ID supplied supply_price DECIMAL(10,2) -- Unit price charged by supplier ); -- sales.product_id can be joined with products.product_id -- sales.customer_id can be joined with customers.customer_id -- sales.salesperson_id can be joined with salespeople.salesperson_id -- product_suppliers.product_id can be joined with products.product_id ### Response: Based on your instructions, here is the SQL query I have generated to answer the question $text: sql";
    try {
      if (text.isNotEmpty) {
        setState(() {
          msgs.insert(0, Message(true, text));
          isTyping = true;
        });
        scrollController.animateTo(0.0,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);
        var res = await http.post(
            Uri.parse("https://cb81-183-82-97-138.ngrok-free.app/query"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode(
                // {"model": "mannix/defog-llama3-sqlcoder-8b", "prompt": schema, "stream": false}));
                {"query_text": text}));
        if (res.statusCode == 200) {
          var responseBody =
              jsonDecode(res.body); // Parse the JSON response body
          var responseText =
              responseBody['response']; // Extract the "response" value

          print(
              responseText); // For debugging, you can print the extracted response

          setState(() {
            isTyping = false;
            msgs.insert(
                0,
                Message(
                    false,
                    responseText
                        .toString())); // Use the extracted "response" value here
          });

          scrollController.animateTo(0.0,
              duration: const Duration(seconds: 1), curve: Curves.easeOut);
        }
      }
    } on Exception {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Some error occurred, please try again!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: msgs.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: isTyping && index == 0
                          ? Column(
                              children: [
                                BubbleNormal(
                                  text: msgs[0].msg,
                                  isSender: true,
                                  color: Colors.blue.shade100,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 16, top: 4),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Typing...")),
                                )
                              ],
                            )
                          : BubbleNormal(
                              text: msgs[index].msg,
                              isSender: msgs[index].isSender,
                              color: msgs[index].isSender
                                  ? Colors.blue.shade100
                                  : Colors.green.shade200,
                            ));
                }),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (value) {
                            sendMsg();
                          },
                          textInputAction: TextInputAction.send,
                          showCursor: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Enter text"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  sendMsg();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              )
            ],
          ),
        ],
      ),
    );
  }
}
