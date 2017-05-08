//
//  ViewController.swift
//  IMServer
//
//  Created by ddn on 2017/4/27.
//  Copyright © 2017年 张永俊. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	@IBOutlet weak var label: NSTextField!
	
	private lazy var serverSocket = IMServerManager()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func start(_ sender: NSButton) {
		serverSocket.startServer()
		label.stringValue = "server is started"
	}
	@IBAction func stop(_ sender: NSButton) {
		serverSocket.stopServer()
		label.stringValue = "server is stoped"
	}
}

