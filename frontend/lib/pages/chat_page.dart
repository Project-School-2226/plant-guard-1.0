// ignore_for_file: prefer_const_constructors
//hello
import 'dart:convert';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool isBotTyping = false;
  void sendMsg() async {
    String text = controller.text;
    controller.clear();
    try {
      if (text.isNotEmpty) {
        setState(() {
          msgs.insert(0, Message(true, text));
          isTyping = true;
          isBotTyping = true;
        });
        scrollController.animateTo(0.0,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);
        var res = await http.post(
            Uri.parse("https://cb81-183-82-97-138.ngrok-free.app/query"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({"query_text": text}));
        if (res.statusCode == 200) {
          var responseBody =
              jsonDecode(res.body); // Parse the JSON response body
          var responseText =
              responseBody['response']; // Extract the "response" value

          print(
              responseText); // For debugging, you can print the extracted response

          setState(() {
            isTyping = false;
            isBotTyping = false;
            msgs.insert(
                0,
                Message(
                    false,
                    responseText
                        .toString())); // Use the extracted "response" value here
          });

          scrollController.animateTo(0.0,
              duration: const Duration(seconds: 1), curve: Curves.easeOut);
        } else {
          setState(() {
            isTyping = false;
            isBotTyping = false; // Hide typing indicator
            msgs.insert(
              0,
              Message(
                  false, "Oops! Something went wrong. Please try again later."),
            );
          });
        }
      }
    } catch (e) {
      // Handle errors (e.g., no internet connection)
      setState(() {
        isTyping = false;
        isBotTyping = false; // Hide typing indicator
        msgs.insert(
          0,
          Message(false, "Oops! Something went wrong. Please try again later."),
        );
      });
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight:
                                40, // Minimum height for the TextField container
                            // You can also specify maxHeight if you want
                            maxHeight: MediaQuery.of(context).size.height *
                                0.2, // 40% of screen height
                          ),
                          child: TextField(
                            controller:
                                controller, // Define this controller in your widget state
                            keyboardType: TextInputType.multiline,
                            maxLines: null, // Allows for unlimited lines
                            minLines:
                                1, // Adjust this to change the initial size
                            decoration: InputDecoration(
                              border: InputBorder
                                  .none, // Removes underline from the TextField
                              hintText:
                                  "Enter text", // Optional: Adds a placeholder
                            ),
                            // No need to change other properties unless necessary
                          ),
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
