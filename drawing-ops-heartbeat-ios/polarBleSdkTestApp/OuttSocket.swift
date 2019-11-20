//Sending End...
import Foundation
import CocoaAsyncSocket

class OutSocket: NSObject, GCDAsyncUdpSocketDelegate {
    
   let IP = "233.255.255.255"
       let PORT:UInt16 = 20005

   
    var socket:GCDAsyncUdpSocket!
    override init(){
        super.init()
        
    }
    func setupConnection(success:(()->())){
        
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue:DispatchQueue.global(qos: .background))
        do { try socket.bind(toPort: PORT)} catch { print("wtf cannot bind")}
        do { try socket.connect(toHost:IP, onPort: PORT)} catch { print("joinMulticastGroup not procceed")}
        do { try socket.beginReceiving()} catch { print("beginReceiving not procceed")}
        success()
        
    }
    func send(signal:Signal){
        let signalData = Signal.archive(w: signal)
        socket.send(signalData, withTimeout: 2, tag: 0)
    }
    func sendMessage(message:String){
        let data = message.data(using: String.Encoding.utf8)
        socket.send(data!, withTimeout: 2, tag: 0)
    }
    func sendDouble(doubleMessage:Float64){
        let data =  withUnsafeBytes(of: doubleMessage) { Data($0) }
        socket.send(data, withTimeout: 2, tag: 0)
    }
    
    //MARK:- GCDAsyncUdpSocketDelegate
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("didConnectToAddress");
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        if let _error = error {
            print("didNotConnect \(_error )")
        }
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("didNotSendDataWithTag")
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("didSendDataWithTag")
    }
}
