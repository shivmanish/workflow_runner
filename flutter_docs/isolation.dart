class IsolationExample{
  Future createIsolate() async {
    /// this recieve port created to recieve other Thread sendPort
    ReceivePort mainThreadReceivePort = ReceivePort();

    /// Spawn an isolate, passing my receivePort sendPort
    Isolate.spawn<SendPort>(
        heavyComputationTask, mainThreadReceivePort.sendPort);

    /// Here , will get other thread send port via 'mainThreadReceivePort' to
    /// send data otherThread from mainThread
    SendPort otherThreadSendPort = await mainThreadReceivePort.first;

    /// Here , another reciever port are created to listen the response from
    /// otherThread.
    ReceivePort otherThreadResponseReceivePort = ReceivePort();

    /// Here send Main Thred  message using otherThreadSendPort. MainThread send
    /// a list to other thread, which includes MainThread data, and finally
    /// a sendPort from otherThreadResponseReceivePort that enables otherThread
    /// to send a message back to mainThread.
    for (var i = 0; i < 10; i++) {
      otherThreadSendPort.send([
        "Mike, I'm taking an Espresso coffee $i",
        "Espresso $i",
        otherThreadResponseReceivePort.sendPort
      ]);
    }

    otherThreadResponseReceivePort.listen((message) {
      print("MIKE'S RESPONSE: ==== $message");
    });

    /// I get Mike's response by listening to mikeResponseReceivePort
    // final otherThreadResponse = await otherThreadResponseReceivePort.first;
    // print("MIKE'S RESPONSE: ==== $otherThreadResponse");
    return "otherThreadResponse";
  }

  static void heavyComputationTask(SendPort mySendPort) async {
    /// Set up a receiver port for nonMainThread
    ReceivePort nonMainThreadRecivePort = ReceivePort();

    /// Send nonMainThread receivePort sendPort via mainThreadSendPort
    mySendPort.send(nonMainThreadRecivePort.sendPort);

    /// Listen to messages sent by MainThread to nonMainThread
    await for (var message in nonMainThreadRecivePort) {
      if (message is List) {
        final myMessage = message[0];
        final coffeeType = message[1];
        print("myMessage is $myMessage");

        /// Get nonMainThread sendPort to send NonMainThread Response
        final SendPort nonMainThreadResponseSendPort = message[2];

        /// Send nonMainThread's response via nonMainThreadResponseSendPort
        nonMainThreadResponseSendPort
            .send("You're taking $coffeeType, and I'm taking Latte");
      }
    }
    Isolate.exit();
  }
}
