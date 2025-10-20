import 'package:chat_interface/chat_interface.dart';
import 'package:flutter/material.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({super.key});

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  late final PagingController<int, ChatMessage> pagingController;
  late final ChatController controller;
  final currentUser = ChatUser(id: 'u1', name: 'You');

  @override
  void initState() {
    super.initState();
    pagingController = PagingController<int, ChatMessage>(
      getNextPageKey: (state) => null, // Implement your paging logic
      fetchPage: (pageKey) async => [], // Implement your message fetch logic
    );

    controller = ChatController(
      scrollController: ScrollController(),
      otherUsers: const [],
      currentUser: currentUser,
      pagingController: pagingController,
      focusNode: FocusNode(),
    );

    // Simulate adding messages like in your screenshot
    _addSampleMessages();
  }

  void _addSampleMessages() async {
    await controller.addMessage(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Hello my name is Miko. Tell me how can I help you',
        type: ChatMessageType.chat,
        senderId: 'bot',
        roomId: 'room-1',
        chatStatus: ChatMessageStatus.sent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    await controller.addMessage(
      ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        message: 'I want to customize my cover letter with more enhanced color and fonttype',
        type: ChatMessageType.chat,
        senderId: currentUser.id,
        roomId: 'room-1',
        chatStatus: ChatMessageStatus.sent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    await controller.addMessage(
      ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        message: 'Ok. Provide me your resume, so that my agents can do the necessary correction',
        type: ChatMessageType.chat,
        senderId: 'bot',
        roomId: 'room-1',
        chatStatus: ChatMessageStatus.sent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    await controller.addMessage(
      ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        message: 'Okk I am upload it right now',
        type: ChatMessageType.chat,
        senderId: currentUser.id,
        roomId: 'room-1',
        chatStatus: ChatMessageStatus.sent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    // Simulate attachment
    await controller.sendAttachmentMessage(
      ChatAttachment(
        fileName: 'Resume.docx',
        fileSize: 5 * 1024 * 1024, // 5 MB
        type: ChatAttachmentType.document,
      ),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automatic job applier'),
        backgroundColor: Colors.purple,
      ),
      body: ChatInterface(
        controller: controller,
        config: ChatUiConfig(
          theme: ChatTheme.dark().copyWith(
            sentMessageBackgroundColor: Colors.purple,
            receivedMessageBackgroundColor: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}