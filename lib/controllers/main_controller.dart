
// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MainController extends GetxController {

  var receivedMessage = '0';
  double? temperature, tds;
  bool isChangingWater = false, isPumpingIn = false, isPumpingOut = false;
  String? lasttimeString;

  String getLastTime() {
    DateTime now = DateTime.now();
    String lastTime =
        "${DateFormat.yMMMEd().format(now)} ${DateFormat.jm().format(DateTime.now())}";
    print(lastTime);
    return lastTime;
  }

  /// MQTT EMQX Credentials
  final client =
      MqttServerClient.withPort('broker.emqx.io', 'wastebinapp_client1', 1883);
  var pongCount = 0, connStatus = 0;
  final builder = MqttClientPayloadBuilder();
  String pubTopic = 'peesam/ayomega/app/pond';
  String subTopic = 'peesam/ayomega/pond/app';
  // bool snoozeNotification = false, shouldSnooze = false;
  // DateTime snoozeTime = DateTime.now();

  /// Functions
  Future<void> mqttConnect() async {
    Completer<MqttServerClient> completer = Completer();

    client.logging(on: true);
    client.autoReconnect = true; //FOR AUTORECONNECT
    client.onAutoReconnect = onAutoReconnect;
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onAutoReconnected = onAutoReconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage().withWillQos(MqttQos.atMostOnce);
    print('EMQX client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print(' client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print(' socket exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      connStatus = 1;
      print('EMQX client connected');
      completer.complete(client);
    } else {
      /// Use status here rather than state if you also want the broker return code.
      connStatus = 0;
      print(
          'EMQX client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }

    /// Ok, lets try a subscription
    print('Subscribing to $subTopic topic');
    client.subscribe(subTopic, MqttQos.atMostOnce);
    String valCheck = "!";

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          final recMess = c![0].payload as MqttPublishMessage;

          receivedMessage =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          lasttimeString = getLastTime();

          print(
              'Topic is <${c[0].topic}>, payload is => $receivedMessage => $valCheck');

          List<String> receivedData = receivedMessage.split(',');
          isPumpingIn = receivedData[0] == "1" ? true : false;
          isPumpingOut = receivedData[1] == "1" ? true : false;
          temperature = double.parse(receivedData[2]);
          tds = double.parse(receivedData[3]);
          print(
            " >>>>>>> isPumpingIn: $isPumpingIn, isPumpingOut: $isPumpingOut, temperature: $temperature, tds: $tds ",
          );

          if (temperature != null && temperature! > 82.0) {
            print("Overtemperature");
            
            update();
            print('Full: temperature $temperature is greater than 82F');
          } else {
            print('temperature is less than 82');
          }

          if (tds != null && tds! > 450.0) {
            print("TDS is now toxic");
            
            update();
            print('Full: tds $tds is greater than 450 ppm');
          } else {
            print('tds is less than 450');
          }

          update();
        }) ??
        client.published?.listen((MqttPublishMessage message) {
          print(
              'Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
        }) ??
        1;
    return;
  }

//------------------------------------------------------------------------------

  void mqttSubscribe() {
    // Subscribe to GsmClientTest/ledStatus
    print('Subscribing to the $subTopic topic');
    client.subscribe(subTopic, MqttQos.atMostOnce);
  }

  void mqttPublish(String msg) {
    builder.clear();
    builder.addString(msg);

    // Publish it
    print('Publishing message: $msg');
    client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);
  }

  void mqttUnsubscribe() {
    client.unsubscribe(subTopic);
  }

  void mqttDisconnect() {
    client.disconnect();
  }

//******************************************************************************/

  void onConnected() {
    print('Connected');
  }

// unconnected
  void onDisconnected() {
    print('Disconnected');
  }

// subscribe to topic succeeded
  void onSubscribed(String subTopic) {
    print('Subscribed topic: $subTopic');
  }

// subscribe to topic failed
  void onSubscribeFail(String subTopic) {
    print('Failed to subscribe $subTopic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String subTopic) {
    print('Unsubscribed topic: $subTopic');
  }

// PING response received
  void pong() {
    print('Ping response client callback invoked');
  }

  /// The pre auto re connect callback
  void onAutoReconnect() {
    print(
        ' onAutoReconnect client callback - Client auto reconnection sequence will start');
  }

  /// The post auto re connect callback
  void onAutoReconnected() {
    print(
        ' onAutoReconnected client callback - Client auto reconnection sequence has completed');
  }
}
