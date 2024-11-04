import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final int maxCharacters = 100;
  List<Message> messages = [
    Message(text: 'Me confirmas bien las direcciones porfa', type: MessageType.received),
    Message(text: 'Buenas tardes', type: MessageType.sent),
  ];

  void sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        messages.add(Message(text: _controller.text.trim(), type: MessageType.sent));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 600,
          height: 400,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xFFF3F5F9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Color(0xFF4B657D),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://via.placeholder.com/40'),
                          radius: 20,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Juan Rodrigo',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              '777-234-4325',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Align(
                      alignment: msg.type == MessageType.sent
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: msg.type == MessageType.sent
                              ? Color(0xFF4B657D)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.type == MessageType.sent
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F9FB),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Color(0xFFB0C4DE)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLength: maxCharacters,
                            decoration: InputDecoration(
                              hintText: 'Escribe tu mensaje',
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: sendMessage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFE0EAF5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xFFB0C4DE)),
                          ),
                          child: Icon(
                            Icons.send,
                            color: Color(0xFF4B7BEC),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        '${maxCharacters - _controller.text.length} caracteres restantes',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final MessageType type;

  Message({required this.text, required this.type});
}

enum MessageType { sent, received }
