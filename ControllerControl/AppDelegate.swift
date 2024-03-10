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
    
    @IBOutlet weak var main_menu: NSMenu!
    

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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @objc func mouseClickHandler() {
        statusItem.menu = main_menu
        statusItem.button?.performClick(nil)
    }
}


extension AppDelegate: NSMenuDelegate {
    // 为了保证按钮的单击事件设置有效，menu要去除
    func menuDidClose(_ menu: NSMenu) {
        self.statusItem.menu = nil
    }
}

