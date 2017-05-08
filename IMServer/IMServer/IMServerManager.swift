//
//  IMServerManager.swift
//  IMServer
//
//  Created by ddn on 2017/4/27.
//  Copyright © 2017年 张永俊. All rights reserved.
//

import Cocoa

class IMServerManager: NSObject {
	fileprivate lazy var serverSocket: TCPServer = TCPServer(addr: "0.0.0.0", port: 7878)
	fileprivate var isRunning: Bool = false
	fileprivate lazy var clients = [TCPClient]()
}

extension IMServerManager {
	func startServer() {
		if isRunning {return}
		//开始监听
		guard serverSocket.listen().0 else {
			print("启动失败")
			return
		}
		
		isRunning = true
		
		DispatchQueue.global().async {
			while self.isRunning {
				//开始接受客户端连接，可以保留多个客户端
				guard let client = self.serverSocket.accept() else {continue}
				self.clients.append(client)
				//读取长度
				while true {
					//根据具体文件数据结构读取
					//通过消息头读取实际消息的字节数
					let databytes = client.read(4)!
					let lengthData = Data(bytes: databytes, count: 4)
					var length : Int = 0
					(lengthData as NSData).getBytes(&length, length: 4)
					//读取实际消息
					let data = client.read(length)
					let result = String(bytes: data!, encoding: .utf8)
					
					print(result ?? "")
					
					//转发消息
					self.clients.filter{$0 !== client}.forEach{_ = $0.send(data: lengthData + data!)}
				}
			}
		}
	}
	
	func stopServer() {
		if !isRunning {return}
	}
}
