//
//  IMClientManager.swift
//  IMServer
//
//  Created by 张永俊 on 2017/9/16.
//  Copyright © 2017年 张永俊. All rights reserved.
//

import Cocoa

class IMClientManager: NSObject {
    var tcpClient: TCPClient
    
    var isReadMsg: Bool = false
    
    var headerLength = 4
    
    init(tcpClient: TCPClient) {
        self.tcpClient = tcpClient
    }
}

extension IMClientManager {
    func startReadMsg() {
        isReadMsg = true
        while isReadMsg {
            if let databytes = tcpClient.read(headerLength) {
                let lengthData = Data(bytes: databytes, count: headerLength)
                var length : Int = 0
                (lengthData as NSData).getBytes(&length, length: headerLength)
                //读取实际消息
                let data = tcpClient.read(length)
                let result = String(bytes: data!, encoding: .utf8)
                
                //处理result
            } else {
                print("客户端断开连接")
            }
            
        }
    }
}
