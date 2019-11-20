//
//  InSocket.swift
//  SyncedPlayer
//
//  Created by IGAL NASSIMA on 5/22/19.
//  Copyright © 2019 Superbright. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

//Reciving End...
class InSocket: NSObject, GCDAsyncUdpSocketDelegate {
    //let IP = "192.168.1.113"
    let IP = "233.255.255.255"
    let PORT:UInt16 = 20005
    var socket:GCDAsyncUdpSocket!
    
    var onMessage: ((_ result: Float64)->())?
    
    override init(){
        super.init()
       // setupConnection()
    }
    func setupConnection(){
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue:DispatchQueue.global(qos: .background))
        do { try socket.bind(toPort: PORT)} catch { print("")}
       // do { try socket.enableBroadcast(true)} catch { print("not able to brad cast")}
        
//        if SocketIOManager._sharedInstance._isMaster {
//             do { try socket.connect(toHost:IP, onPort: PORT)} catch { print("joinMulticastGroup not procceed")}
//        } else {
//            do { try socket.joinMulticastGroup(IP)} catch { print("joinMulticastGroup not procceed")}
//        }
            do { try socket.connect(toHost:IP, onPort: PORT)} catch { print("joinMulticastGroup not procceed")}
      //  do {
      //      try socket.beginReceiving()} catch { print("beginReceiving not procceed")}
    }
    
    func checkConnection() {
        print(socket.isConnected())
        
        if(!socket.isConnected()) {
            setupConnection()
        }
    }
    //MARK:-GCDAsyncUdpSocketDelegate
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
      //  print("incoming message: \(data)");
//        let value = data.withUnsafeBytes {
//            $0.load(as: Double.self)
//        }
//        print(value) // 42.13
     //   self.onMessage?(value)
        
//        let signal:Signal = Signal.unarchive(d: data)
//        print("signal information : \n first \(signal.firstSignal) , second \(signal.secondSignal) \n third \(signal.thirdSignal) , fourth \(signal.fourthSignal)")
        
    }
    
    func sendDouble(doubleMessage:UInt8){
        //print("send double")
        let data =  withUnsafeBytes(of: doubleMessage) { Data($0) }
        socket.send(data, withTimeout: 1, tag: 0)
    }
    func sendString(doubleMessage:UInt8){
          //print("send double")
         // let data =  withUnsafeBytes(of: doubleMessage) { Data($0) }
        let string = "h:\(doubleMessage)"
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        socket.send(data, withTimeout: 1, tag: 0)
      }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("didConnectToAddress");
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        if let _error = error {
            print("didNotConnect \(_error )")
        }
    }
    
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("didNotSendDataWithTag")
        print(error)
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
       // print("didSendDataWithTag")
    }
}
