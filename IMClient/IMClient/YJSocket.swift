//
//  YJSocket.swift
//  IMClient
//
//  Created by ddn on 2017/4/27.
//  Copyright © 2017年 张永俊. All rights reserved.
//

import UIKit

class YJSocket {
	fileprivate var tcpClient: TCPClient
	
	init(address: String, port: Int) {
		tcpClient = TCPClient(addr: address, port: port)
	}
}

extension YJSocket {
	func connectServer() -> Bool {
		return tcpClient.connect(timeout: 5).0
	}
	
	func disconnectServer() -> Bool {
		return tcpClient.close().0
	}
	
    func sendMsg(_ msg: String) {
        
        var length = msg.characters.count
        let lengthData = Data(bytes: &length, count: 4)
        
        guard let data = msg.data(using: .utf8) else {return}
        
        _ = tcpClient.send(data: lengthData + data)
	}
	
	func readMsg(_ msg: Data) -> String? {
		
		//根据具体文件数据结构读取
		//通过消息头读取实际消息的字节数
		let databytes = tcpClient.read(4)!
		let lengthData = Data(bytes: databytes, count: 4)
		var length : Int = 0
		(lengthData as NSData).getBytes(&length, length: 4)
		//读取实际消息
		let data = tcpClient.read(length)
		let result = String(bytes: data!, encoding: .utf8)
		return result
	}
}
