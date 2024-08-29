// ignore_for_file: prefer_const_constructors
//hello updated updared
import 'dart:convert';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_guard/Models/message.dart';
import 'package:plant_guard/services/chat_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ChatServices _chatService = ChatServices();

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
    "How much sunlight does my plant need?",
    "When is the best time to repot?",
    "How to prune my plant correctly?",
    "How to prevent yellow leaves?",
    "What are common plant diseases?",
    "Tips for growing plants in low light?",
    "How to propagate my plant?",
    "How to identify plant problems?",
    "How to increase humidity for my plant?",
    "How to care for plants in low light?",
    "How to choose the right pot for my plant?",
    "How to prevent root rot?",
    "How to take care of my plants in summer?",
    "How to take care of my plants in spring?",
    "How to take care of my plants in winter?",
    "How to take care of my plants in fall?",
    "How to take care of my plants in autumn?",
    "How to take care of my plants in rainy season?",
    "How to take care of my plants in dry season?",
    "How to take care of my plants in monsoon?",
    "How to take care of my plants in hot weather?",
    "How to take care of my plants in cold weather?",
    "How to take care of my plants in humid weather?",
    "How to take care of my plants in dry weather?",
    "How to take care of my plants in windy weather?",
  ];

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage(isSender, message) async {
    // final message = _messageController.text;
    if (message.isNotEmpty) {
      await _chatService.sendMessage(isSender, message);
      _messageController.clear();
    }
    scrollDown();
  }

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
      msgs.insert(
          0,
          Message(
              isSender: true, message: message, timestamp: Timestamp.now()));

      sendMessage(true, message);
      isTyping = true;
      isBotTyping = true;

      // Optionally, clear quick chat options if you want them to disappear after sending a message
      hasStartedChatting = true;
      selectedQuickChatOptions.clear();
    });
    scrollController.animateTo(0.0,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
    try {
      var res = await http.post(
          Uri.parse(
              "https://79b5-2406-b400-d5-f637-e800-11c5-4bb2-27e3.ngrok-free.app/query"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({"question": message}));
      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body); // Parse the JSON response body
        var responseText =
            responseBody['response'].toString(); // Extract the "response" value

        print(
            responseText); // For debugging, you can print the extracted response

        setState(() {
          isTyping = false;
          isBotTyping = false;
          msgs.insert(
              0,
              Message(
                  isSender: false,
                  message: responseText,
                  timestamp: Timestamp
                      .now())); // Use the extracted "response" value here
        });
        sendMessage(false, responseText);
        scrollController.animateTo(0.0,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);
      } else {
        setState(() {
          isTyping = false;
          isBotTyping = false; // Hide typing indicator
          msgs.insert(
            0,
            Message(
                isSender: false,
                message: "Oops! Something went wrong. Please try again later.",
                timestamp: Timestamp.now()),
          );
          sendMessage(
              false, "Oops! Something went wrong. Please try again later.");
        });
      }
    } catch (e) {
      setState(() {
        isTyping = false;
        isBotTyping = false; // Hide typing indicator
        msgs.insert(
          0,
          Message(
              isSender: false,
              message: "Oops! Something went wrong. Please try again later.",
              timestamp: Timestamp.now()),
        );
        sendMessage(
            false, "Oops! Something went wrong. Please try again later.");
      });
    }

    // Add logic to send the message to the server or process it further as needed
  }

  void sendMsg() async {
    String text = _messageController.text;
    _messageController.clear();
    try {
      if (text.isNotEmpty) {
        setState(() {
          msgs.insert(
              0,
              Message(
                  isSender: true, message: text, timestamp: Timestamp.now()));
          isTyping = true;
          isBotTyping = true;
          hasStartedChatting = true;
        });
        sendMessage(true, text);
        scrollController.animateTo(0.0,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);
        var res = await http.post(
            Uri.parse(
                "https://79b5-2406-b400-d5-f637-e800-11c5-4bb2-27e3.ngrok-free.app/query"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({"question": text}));

        if (res.statusCode == 200) {
          var responseBody =
              jsonDecode(res.body); // Parse the JSON response body
          var responseText = responseBody['response']
              .toString(); // Extract the "response" value

          print(
              responseText); // For debugging, you can print the extracted response

          setState(() {
            isTyping = false;
            isBotTyping = false;
            isWaitingForResponse = false;
            msgs.insert(
                0,
                Message(
                    isSender: false,
                    message: responseText,
                    timestamp: Timestamp
                        .now())); // Use the extracted "response" value here
          });
          sendMessage(false, responseText);

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
                  isSender: false,
                  message:
                      "Oops! Something went wrong. Please try again later.",
                  timestamp: Timestamp.now()),
            );
            sendMessage(
                false, "Oops! Something went wrong. Please try again later.");
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
          Message(
              isSender: false,
              message: "Oops! Something went wrong. Please try again later.",
              timestamp: Timestamp.now()),
        );
        sendMessage(
            false, "Oops! Something went wrong. Please try again later.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: BackButton(
          color: Colors.green.shade400,
        ),
        title: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('lib/images/Maali_AI.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8), // spacing between the image and the text
            const Text("Maali AI"),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          if (msgs.isEmpty && !hasStartedChatting)
            /*Expanded(
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
                            return Padding(
                              padding: const EdgeInsets.all(
                                  6.0), // Adjust the padding as needed
                              child: ElevatedButton(
                                  onPressed: () {
                                    sendQuickChatMessage(option);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade300,
                                      foregroundColor: Colors.grey.shade800),
                                  child: Text(option,
                                      style: const TextStyle(fontSize: 16))),
                            );
                          }).toList(),
                        ],
                      ))),
            ),*/
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(color: Colors.yellow,),
                      ),
                    );
                  default:
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: snapshot.data?.length ?? 0,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        // if (!hasStartedChatting) {
                          // return ElevatedButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       hasStartedChatting = true;
                          //     });
                          //   },
                            // child: index < selectedQuickChatOptions.length
                            //     ? Text(selectedQuickChatOptions[index])
                            //     : null,
                          // );
                        // } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: isTyping && index == 0
                                ? Column(
                                    children: [
                                      BubbleNormal(
                                        text: snapshot.data?[0].message ?? '',
                                        isSender: true,
                                        color: Colors.blue.shade100,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 16, top: 4),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                                Text("Generating Response...")),
                                      )
                                    ],
                                  )
                                : BubbleNormal(
                                    text: snapshot.data?[index].message ?? '',
                                    isSender:
                                        snapshot.data?[index].isSender ?? false,
                                    color:
                                        snapshot.data?[index].isSender ?? false
                                            ? Colors.blue.shade100
                                            : Colors.green.shade200,
                                  ),
                          );
                        // }
                      },
                    );
                }
              },
            ),
          ),
          /*Expanded(
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
                                  text: msgs[0].message,
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
                              text: msgs[index].message,
                              isSender: msgs[index].isSender,
                              color: msgs[index].isSender
                                  ? Colors.blue.shade100
                                  : Colors.green.shade200,
                            ),
                    );
                  }
                }),
          ),*/
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
                                40, 
                            maxHeight: MediaQuery.of(context).size.height *
                                0.2,
                          ),
                          child: TextField(
                            controller:
                                _messageController, // Define this controller in your widget state
                            keyboardType: TextInputType.multiline,
                            maxLines: null, // Allows for unlimited lines
                            minLines:
                                1, // Adjust this to change the initial size
                            decoration: InputDecoration(
                              border: InputBorder
                                  .none, // Removes underline from the TextField
                              hintText:
                                  "Enter query ...", // Optional: Adds a placeholder
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
