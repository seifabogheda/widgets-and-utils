
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';



class SingleChatView extends StatefulWidget {
  final int chatId;
  final String chatName;
  final String image;
  const SingleChatView({Key? key, required this.chatId, required this.chatName, required this.image}) : super(key: key);

  @override
  State<SingleChatView> createState() => _SingleChatViewState();
}

class _SingleChatViewState extends State<SingleChatView> {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  @override
  void initState() {
    initPusher();
    super.initState();
  }
  initPusher() async {
    // في اول دخول للشات هيظهر معاك ايرور لان مفيش رسالة بتتضاف لكن كمل عادي هتلاقيه شغال كويس جدا
    // مع الاتفاق مع الباك لما يعمل ال pusher يكون مع سيرفس ال SEND يبعت ف ال PUSHER

    try {
      await pusher.init(apiKey: 'الكي اللي الباك هيبعتهولك', cluster: 'eu',onEvent: onEvent);
      // await pusher.init(apiKey: '87df506b6a9513c80d03', cluster: 'eu',onEvent: onEvent);
      log("done");
      // دا ال subscribe بتاع كل شات عشان يشتغل ال pusher و غالبا الباك هيقولك دا هيبقى الشات id او ع حسب اتفاقك معاه
      await pusher.subscribe(
          channelName: "chat.${widget.chatId}");
      await pusher.connect();
    } on PlatformException catch (e) {
      log("$e");
    }
  }

  onEvent(PusherEvent event) {
    log("event is : ${json.decode(event.data.toString())["message"]}");

    try{
      // لما يحصل الايفينت يعمل ابديت للرسايل اللي بتجيلك يتحسن تضبطها ع حسب الاستيت مانجمينت بتاعتك
      setState(() {
        // controller.messages.insert(0, ConversationMessage.fromMap(json.decode(event.data.toString())["message"]));
      });
    }catch(e,s){
      log("error is : $e, stack is $s");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:Text(
          widget.chatName,
        ),

        actions: [
          GestureDetector(
            onTap:()=> Navigator.of(context).pop(),
            child: Icon(Icons.adaptive.arrow_back),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: InkWell(
                          onTap: () {
                            // send message
                            // controller.sendMessage();
                          },
                          child: const Icon(Icons.send)
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                    child: TextField(
                      // don't forget you text edit controller
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                        hintText: "نص الرسالة",
                        // suffixIcon: SvgPicture.asset(AppAssets.FilterIcon),
                        prefixText: "   ",
                        suffixIconConstraints: BoxConstraints(
                          maxHeight: 30,
                        ),
                        contentPadding: EdgeInsets.only(
                          top: 0.0,
                          bottom: 10.0,
                          right: 20,
                          left: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // متنساش ال dispose هتودينا ف داهية
  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }

  // مفيش اي اضافة في الاندرويد او ال  ios في ال IOS بس خليه يبدا من 13
}

