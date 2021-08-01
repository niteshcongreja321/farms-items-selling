import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/live-chat/chat.dart';
import 'package:project_farm_shop/widgets/message.dart';
import 'package:provider/provider.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({Key? key}) : super(key: key);

  @override
  _LiveChatState createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  final user = FirebaseAuth.instance.currentUser;
  final _ctrlMessage = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _ctrlMessage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var db = context.watch<DatabaseService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Chat', style: GoogleFonts.lato(color: Themes.brown)),
        backgroundColor: Colors.white,
        elevation: 8,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
                child: StreamProvider<List<Chat>>.value(
                    initialData: [],
                    value: db.streamChat(user?.uid),
                    catchError: (context, error) => [],
                    child: ChatList())),
            Container(
              height: 60,
              child: TextFormField(
                controller: _ctrlMessage,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Themes.brownLight2,
                    hintText: 'Say something…',
                    hintStyle: TextStyle(color: Themes.brownLight),
                    suffix: FloatingActionButton(
                        mini: true,
                        backgroundColor: Themes.green,
                        elevation: 0,
                        onPressed: () => sendMessage(context),
                        child: Icon(Icons.arrow_forward_rounded))),
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(context) async {
    Chat chat = Chat(uid: user?.uid, message: _ctrlMessage.text);

    print(chat.toJson());

    Provider.of<DatabaseService>(context, listen: false).sendChat(chat);

    _ctrlMessage.clear();
  }
}

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chats = context.watch<List<Chat>>();
    print(chats.length);
    return Container(
      child: ListView(
          shrinkWrap: true,
          children: chats.map((m) => MessageWidget(chat: m)).toList()),
    );
  }
}
