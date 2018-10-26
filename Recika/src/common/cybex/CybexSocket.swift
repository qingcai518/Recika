//
//  CybexSocket.swift
//  Recika
//
//  Created by liqc on 2018/10/26.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Starscream

let wsURL = "wss://hangzhou.51nebula.com/"

let loginParams: [String: Any] = [
    "method": "call",
    "params": [1, "login", ["", ""]],
    "id": 1
]

let broadcastParams: [String: Any] = [
    "method": "call",
    "params": [1, "network_broadcast", []],
    "id": 2
]

class CybexSocket {
    static var shared = CybexSocket()
    private var socket: WebSocket?
    
    private init() {}
    
    func connect() {
        if let socket = socket, socket.isConnected {return}
        if let url = URL(string: wsURL) {
            socket = WebSocket(url: url)
        }
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect(forceTimeout: 10, closeCode: CloseCode.normal.rawValue)
    }
    
    func transfer(transaction: [String: Any], onSuccess: @escaping () -> Void, onFail: @escaping (String) -> Void) {
        send(loginParams, onSuccess: { [weak self] in
//            self?.send(broadcastParams, onSuccess: {
//                let param: [String: Any] = [
//                    "method": "call",
//                    "params": [2, "broadcast_transaction", [transaction]],
//                    "id": 3
//                ]
//
//                self?.send(param, onSuccess: {
//                    onSuccess()
//                }, onFail: { msg in
//                    onFail(msg)
//                })
//            }, onFail: { msg in
//                onFail(msg)
//            })
        }) { msg in
            onFail(msg)
        }
    }
    
    private func send(_ value: Any, onSuccess: @escaping () -> Void, onFail: @escaping (String) -> Void) {
        guard JSONSerialization.isValidJSONObject(value) else {
            return onFail("not a json object")
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            socket?.write(data: data) {
                onSuccess()
            }
        } catch let error {
            return onFail(error.localizedDescription)
        }
    }
}

extension CybexSocket: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected")
        print("reconnecting...")
        self.socket?.connect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocket received message : \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocket received data")
    }
}
