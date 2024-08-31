// ignore_for_file: prefer_const_constructors
//hello updated
import 'dart:convert';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  bool hasStartedChatting = false; // Step 1: Add a boolean state variable
  bool isWaitingForResponse = false; // Step 1: State variable

  List<String> quickChatOptions = [
    "Ideal conditions for my plant?",
    "How often should I water my plant?",
    "What are the signs of overwatering?",
    "How to deal with pests on plants?",
    "Best fertilizer for indoor plants?",
    "How much sunlight does my plant need?",
    "When is the best time to repot?",
    "How to prune my plant correctly?",
    "What are common plant diseases?",
    "Tips for growing plants in low light?",
    "How to propagate my plant?",
    "How to identify plant problems?",
    "How to increase humidity for my plant?",
    "How to care for plants in low light?",
    "How to choose the right pot for my plant?",
    "How to prevent root rot?",
    "How to care for plants in winter?",
    "How to care for plants in summer?",
    "How to care for plants in spring?",
    "How to care for plants in fall?",
    "How to care for plants in autumn?",
    "How to care for plants in rainy season?",
    "How to care for plants in dry season?",
    "How to care for plants in monsoon?",
    "How to care for plants in hot weather?",
    "How to care for plants in cold weather?",
    "How to care for plants in humid weather?",
    "How to care for plants in dry weather?",
    "How to care for plants in windy weather?",
  ];
  List<String> selectedQuickChatOptions = [];
  @override
  void initState() {
    super.initState();
    quickChatOptions.shuffle();
    selectedQuickChatOptions = quickChatOptions.take(3).toList();
  }

  void sendQuickChatMessage(String message) async {
    setState(() {
      // Assuming you have a method to add a message to your chat
      msgs.insert(0, Message(true, message));
      isTyping = true;
      isBotTyping = true;
      isWaitingForResponse = true;
      // Optionally, clear quick chat options if you want them to disappear after sending a message
      hasStartedChatting = true;
      selectedQuickChatOptions.clear();
    });
    scrollController.animateTo(0.0,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
    try {
      var res = await http.post(
          Uri.parse(dotenv.env['NGROK_URL']!),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({"question": message}));
      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body); // Parse the JSON response body
        var responseText =
            responseBody['response']; // Extract the "response" value

        print(
            responseText); // For debugging, you can print the extracted response

        setState(() {
          isTyping = false;
          isWaitingForResponse = false;
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
          isWaitingForResponse = false;
          isBotTyping = false; // Hide typing indicator
          msgs.insert(
            0,
            Message(
                false, "Oops! Something went wrong. Please try again later."),
          );
        });
      }
    } catch (e) {
      setState(() {
        isTyping = false;
        isWaitingForResponse = false;
        isBotTyping = false; // Hide typing indicator
        msgs.insert(
          0,
          Message(false, "Oops! Something went wrong. Please try again later."),
        );
      });
    }

    // Add logic to send the message to the server or process it further as needed
  }

  void sendMsg() async {
    String text = controller.text;
    controller.clear();
    try {
      if (text.isNotEmpty) {
        setState(() {
          msgs.insert(0, Message(true, text));
          isTyping = true;
          isBotTyping = true;
          hasStartedChatting = true;
          isWaitingForResponse = true;
        });
        scrollController.animateTo(0.0,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);
        var res = await http.post(
            Uri.parse(dotenv.env['NGROK_URL']!),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({"question": text}));

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
            isWaitingForResponse = false;
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
            isWaitingForResponse = false;
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
        isWaitingForResponse = false;
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
          if (msgs.isEmpty &&
              !hasStartedChatting) // Step 2: Conditionally display the plant logo
            Expanded(
              child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (MediaQuery.of(context).viewInsets.bottom ==
                              0) // Checks if the keyboard is closed
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Quick Chat",
                                  style: const TextStyle(fontSize: 28),
                                )),
                          const SizedBox(
                            height: 8,
                          ),
                          ...selectedQuickChatOptions.map((option) {
                            return ElevatedButton(
                                onPressed: () => sendQuickChatMessage(option),
                                child: Text(option,
                                    style: const TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade300,
                                    foregroundColor: Colors.grey.shade800));
                          }).toList(),
                        ],
                      ))),
            ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: msgs.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  if (!hasStartedChatting) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hasStartedChatting = true;
                        });
                      },
                      child: Text(selectedQuickChatOptions[index]),
                    );
                  } else {
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
                                      child: Text("Generating Response...")),
                                )
                              ],
                            )
                          : BubbleNormal(
                              text: msgs[index].msg,
                              isSender: msgs[index].isSender,
                              color: msgs[index].isSender
                                  ? Colors.blue.shade100
                                  : Colors.green.shade200,
                            ),
                    );
                  }
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
                onTap: isWaitingForResponse ? null :() {
                  sendMsg();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                       color: isWaitingForResponse ? Colors.grey : Colors.green,
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
