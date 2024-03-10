//
//  AppDelegate.swift
//  ControllerControl
//
//  Created by Acane on 2024/3/10.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MenuBar Icon
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    // Menu
    @IBOutlet weak var main_menu: NSMenu!
    // Menu -> No Connected Controller
    //         It will show controller name if connected
    @IBOutlet weak var main_menuitem_connect_status: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let menubar_button = statusItem.button {
            menubar_button.image = NSImage(named: "StatusIcon")
            // 点击事件
            menubar_button.action = #selector(mouseClickHandler)
            menubar_button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        // 修复按钮单击事件无效问题
        main_menu.delegate = self
        
        // 注册接收名为 "UpdateUI" 的通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI(_:)), name: NSNotification.Name("UpdateUI"), object: nil)
        
        // 启动后台服务，创建一个后台线程
        let backgroundThread = Thread {
            // 设置 RunLoop
            let runLoop = RunLoop.current
            let mode = RunLoop.Mode.default
            
            // 在 RunLoop 中执行一些任务
            workerRunLoop()
            
            runLoop.run(mode: mode, before: Date.distantFuture)
        }

        // 启动后台线程
        backgroundThread.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        // 移除通知监听器
        NotificationCenter.default.removeObserver(self)
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @objc func mouseClickHandler() {
        statusItem.menu = main_menu
        statusItem.button?.performClick(nil)
    }
    @IBAction func menuItemQuitClick(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @objc func updateUI(_ notification: Notification) {
        // 从通知的 userInfo 中获取传递的字符串
        if let message = notification.userInfo?["message"] as? String {
            // 在这里将字符串应用于 UI 元素
            main_menuitem_connect_status.title = message
        }
    }
}


extension AppDelegate: NSMenuDelegate {
    // 为了保证按钮的单击事件设置有效，menu要去除
    func menuDidClose(_ menu: NSMenu) {
        self.statusItem.menu = nil
    }
}

