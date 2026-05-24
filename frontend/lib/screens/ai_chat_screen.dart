import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIChatScreen extends StatefulWidget {
  @override
  State<AIChatScreen> createState() =>
      _AIChatScreenState();
}

class _AIChatScreenState
    extends State<AIChatScreen> {

  TextEditingController controller =
      TextEditingController();

  ScrollController scrollController =
      ScrollController();

  List<String> messages = [];

  double currentCpu = 0;
  double currentRam = 0;
  double currentDisk = 0;

  @override
  void initState(){

   super.initState();

   loadMetrics();

  }

  Future<void> loadMetrics() async {

  try {

    var response = await http.get(

      Uri.parse(
      "http://127.0.0.1:8000/metrics"
      ),

    );

    var data =
        jsonDecode(response.body);

    setState(() {

      currentCpu =
      (data['cpu'] as num)
          .toDouble();

      currentRam =
      (data['ram'] as num)
          .toDouble();

      currentDisk =
      (data['disk'] as num)
          .toDouble();

    });

  } catch(e){

    print(e);

  }

}

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("AI Ops Assistant"),
      ),

      body: Column(

        children: [

          Padding(

padding: EdgeInsets.all(10),

child: SizedBox(

width: double.infinity,

child: ElevatedButton.icon(

icon: Icon(Icons.analytics),

label: Text(
"Analyze Current System"
),

onPressed: () async {

await loadMetrics();

try{

setState((){

messages.add(
"You: Analyze my current machine\n${TimeOfDay.now().format(context)}"
);

});

var response =
await http.post(

Uri.parse(
"http://127.0.0.1:8000/ask"
),

headers:{
"Content-Type":
"application/json"
},

body: jsonEncode({

"message":
"Analyze my current machine",

"cpu":currentCpu,

"ram":currentRam,

"disk":currentDisk

})

);

var data =
jsonDecode(
response.body
);

setState((){

messages.add(
"AI: ${data['answer']}\n${TimeOfDay.now().format(context)}"
);

});

}catch(e){

setState((){

messages.add(
"ERROR: $e"
);

});

}

},

),

),

),

          Expanded(

            child: ListView.builder(

  controller: scrollController,

  padding: EdgeInsets.only(
    top:20,
    left:10,
    right:10,
    bottom:20,
  ),

  itemCount: messages.length,

  itemBuilder:(c,i){

  bool isUser =
      messages[i]
      .startsWith("You:");

  return Align(

    alignment:

    isUser
    ? Alignment.centerRight
    : Alignment.centerLeft,

    child: Container(

      margin: EdgeInsets.symmetric(
        horizontal:10,
        vertical:6,
      ),

      padding: EdgeInsets.all(12),

      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.of(context)
            .size
            .width * .55,
        ),

      decoration:
      BoxDecoration(

        color:

        isUser
        ? Colors.blue
        : Colors.grey[850],

        borderRadius:
        BorderRadius.circular(16),

      ),

      child: Text(
        messages[i],
      ),

    ),

  );

},
            ),
          ),

          Row(

            children:[

              Expanded(

                child: TextField(
                  controller: controller,
                  decoration:
                  InputDecoration(
                    hintText:
                    "Ask AI...",
                  ),
                ),
              ),

              IconButton(

                icon:
                Icon(Icons.send),

                onPressed: () async {

                  try {

                    await loadMetrics();

                    String msg =
                    controller.text;

                    if(msg.isEmpty) return;

                    setState(() {

                      messages.add(
                        "You: $msg\n${TimeOfDay.now().format(context)}"
                      );

                    });

                    controller.clear();

                    var response =
                    await http.post(

                      Uri.parse(
                      "http://127.0.0.1:8000/ask"
                      ),

                      headers: {
                        "Content-Type":
                        "application/json"
                      },

                      body: jsonEncode({

                         "message": msg,

                         "cpu": currentCpu,

                         "ram": currentRam,

                         "disk": currentDisk

                        })
                    );

                    var data =
                    jsonDecode(
                    response.body);

                    setState(() {

                      messages.add(
                      "AI: ${data['answer']}\n${TimeOfDay.now().format(context)}"
                      );

                    });

                    Future.delayed(

                      Duration(
                      milliseconds:100),

                      () {

                      scrollController.animateTo(

                      scrollController
                      .position
                      .maxScrollExtent,

                      duration:
                      Duration(
                      milliseconds:300),

                      curve:
                      Curves.easeOut,

                      );

                    });

                  } catch(e){

                    setState(() {

                      messages.add(
                      "ERROR: $e\n${TimeOfDay.now().format(context)}"
                      );

                    });

                  }

                },

              )

            ],

          )

        ],

      ),

    );

  }
}