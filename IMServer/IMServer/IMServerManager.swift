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
	fileprivate lazy var clients = [IMClientManager]()
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
                let clientMgr = IMClientManager(tcpClient: client)
				self.clients.append(clientMgr)
                clientMgr.startReadMsg()
			}
		}
	}
	
	func stopServer() {
		if !isRunning {return}
	}
}
