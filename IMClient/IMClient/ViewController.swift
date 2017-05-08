//
//  ViewController.swift
//  IMClient
//
//  Created by ddn on 2017/4/27.
//  Copyright © 2017年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var connectBtn: UIButton!
	@IBOutlet weak var disconnectBtn: UIButton!

	@IBOutlet weak var textField: UITextField!
	fileprivate var client: YJSocket = YJSocket(address: "192.168.4.227", port: 7878)
	fileprivate var connected: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let userbuilder = UserInfo.Builder()
		userbuilder.name = "www"
		userbuilder.icon = "qq.png"
		userbuilder.level = 1
		
		//序列化
		guard let userinfo = try? userbuilder.build() else {return}
		let userdata = userinfo.data()
		
		//反序列化
//		guard let userinfo = try? UserInfo.parseFrom(data: userdata) else {return}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		connectBtn.isEnabled = !connected
		disconnectBtn.isEnabled = connected
	}

	@IBAction func connect(_ sender: UIButton) {
		if client.connectServer() {
			sender.isEnabled = false
			disconnectBtn.isEnabled = true
		}
	}
	
	@IBAction func disconnect(_ sender: UIButton) {
		if client.disconnectServer() {
			sender.isEnabled = false
			connectBtn.isEnabled = true
		}
	}
	@IBAction func sendMsg(_ sender: UIButton) {
		guard let text = textField.text else {
			return
		}
		var length = text.characters.count
		let lengthData = Data(bytes: &length, count: 4)
		
		guard let data = text.data(using: .utf8) else {return}
		client.sendMsg(lengthData + data)
	}
	
	private func readMsg(_ data: Data) {
		DispatchQueue.global().async {
			while self.connected {
				let result = self.client.readMsg(data)
				print(result ?? "")
			}
		}
	}
}

