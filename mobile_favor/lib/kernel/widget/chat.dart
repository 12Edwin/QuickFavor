import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String no_user;
  final String name;
  final String? image;

  const ChatScreen({super.key, required this.chatId, required this.no_user, required this.name, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: image != null ? NetworkImage(image!) : const AssetImage('assets/profile.png'),
            ),
            const SizedBox(width: 8),
            Text(name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(chatId: chatId, no_user: no_user),
          ),
          NewMessageInput(chatId: chatId, no_user: no_user),
        ],
      ),
    );
  }
}

class ChatMessages extends StatelessWidget {
  final String chatId;
  final String no_user;

  const ChatMessages({super.key, required this.chatId, required this.no_user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshot.hasData || !chatSnapshot.data!.exists) {
          return const Center(child: Text('Chat no encontrado'));
        }

        final chatData = chatSnapshot.data!.data() as Map<String, dynamic>;
        final messages = chatData['messages'] as List? ?? [];

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (ctx, index) {
            final message = messages[messages.length - 1 - index];

            return ChatBubble(
              message: message['msg'],
              sender: message['sender'],
              timestamp: message['createdAt'],
              no_user: no_user,
            );
          },
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String sender;
  final String timestamp;
  final String no_user;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.no_user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = sender == no_user;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(maxWidth: 250),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(DateTime.parse(timestamp)),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewMessageInput extends StatefulWidget {
  final String chatId;
  final String no_user;

  const NewMessageInput({super.key, required this.chatId, required this.no_user});

  @override
  _NewMessageInputState createState() => _NewMessageInputState();
}

class _NewMessageInputState extends State<NewMessageInput> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    if (_enteredMessage.trim().isEmpty) return;

    try {
      final chatRef = FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

      await chatRef.update({
        'messages': FieldValue.arrayUnion([{
          'msg': _enteredMessage,
          'sender': widget.no_user,
          'createdAt': DateTime.now().toString(),
        }])
      });

      _controller.clear();
      setState(() {
        _enteredMessage = '';
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al enviar el mensaje')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enviar mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}