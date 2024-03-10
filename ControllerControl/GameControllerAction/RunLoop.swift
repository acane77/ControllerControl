//
//  RunLoop.swift
//  ControllerControl
//
//  Created by Acane on 2024/3/10.
//

import Foundation
import GameController


func workerRunLoop() {
    NSLog("Background service configuation")
    
    func _closure(note: Notification) {
        guard let controller = note.object as? GCController else { return }
        GCController.shouldMonitorBackgroundEvents = true
        print("Controller connected: \(controller)")
        let notification = Notification(name: NSNotification.Name("UpdateUI"), object: nil, userInfo: ["message": "Connected: \(String(describing: controller.vendorName!))" ])
        NotificationCenter.default.post(notification)


        
        var isLongPressing = false
        var dPadXValue :Float = 0.0
        var dPadYValue :Float = 0.0
        var moveSpeedScale :Int = 1
        var dPadClickCount = 0
        // 设置定时器来检测长按状态
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if isLongPressing {
                // 长按逻辑，可以在这里执行长按时的操作
                print("D-pad moved: x=\(dPadXValue), y=\(dPadYValue)")
                let mouse_loc = getCurrentMouseLocation()
                print("Mouse location: (\(mouse_loc.x), \(mouse_loc.y))")
                var i = 0
                while i < moveSpeedScale {
                    performMouseAction(x: Float(mouse_loc.x) + Float(dPadXValue) * 0.2 * Float(moveSpeedScale),
                                       y: Float(mouse_loc.y) - Float(dPadYValue) * 0.2 * Float(moveSpeedScale),
                                       event_type: .mouseMoved)
                    i += 1
                }
                if dPadClickCount % 4 == 1 {
                    moveSpeedScale *= 3
                    if moveSpeedScale > 48 {
                        moveSpeedScale = 48
                    }
                }
                dPadClickCount += 1
            }
        }
        
        func mouse_action_here(event_type: CGEventType) {
            let mouse_loc = getCurrentMouseLocation()
            print("Mouse location: (\(mouse_loc.x), \(mouse_loc.y))")
            performMouseAction(x: Float(mouse_loc.x), y: Float(mouse_loc.y), event_type: event_type)
        }
        
        controller.extendedGamepad?.buttonA.valueChangedHandler = { button, value, pressed in
            print("A button state: \(pressed)")
            if pressed {
                mouse_action_here(event_type: .leftMouseDown)
            }
            else {
                mouse_action_here(event_type: .leftMouseUp)
            }
        }
        
        
        controller.extendedGamepad?.leftShoulder.valueChangedHandler = { button, value, pressed in
            print("leftTrigger state: \(pressed)")
            if pressed {
                mouse_action_here(event_type: .leftMouseDown)
            }
            else {
                mouse_action_here(event_type: .leftMouseUp)
            }
        }
        
        controller.extendedGamepad?.leftThumbstickButton?.valueChangedHandler = { button, value, pressed in
            print("leftTrigger state: \(pressed)")
            if pressed {
                mouse_action_here(event_type: .leftMouseDown)
            }
            else {
                mouse_action_here(event_type: .leftMouseUp)
            }
        }
        
        controller.extendedGamepad?.buttonB.valueChangedHandler = { button, value, pressed in
            print("rightTrigger state: \(pressed)")
            if pressed {
                mouse_action_here(event_type: .rightMouseDown)
            }
            else {
                mouse_action_here(event_type: .rightMouseUp)
            }
        }
        
        controller.extendedGamepad?.rightShoulder.valueChangedHandler = { button, value, pressed in
            print("rightTrigger state: \(pressed)")
            if pressed {
                mouse_action_here(event_type: .rightMouseDown)
            }
            else {
                mouse_action_here(event_type: .rightMouseUp)
            }
        }
        
        controller.extendedGamepad?.rightThumbstickButton?.valueChangedHandler = { button, value, pressed in
            print("rightTrigger state: \(pressed)")
            if pressed {
                mouse_action_here(event_type: .rightMouseDown)
            }
            else {
                mouse_action_here(event_type: .rightMouseUp)
            }
        }
        
        func set_mouse_move_state(xValue :Float, yValue :Float) {
            if abs(xValue) < 1e-5 && abs(yValue) < 1e-5 {
                isLongPressing = false
                dPadXValue = 0
                dPadYValue = 0
                moveSpeedScale = 1
                dPadClickCount = 0
                return
            }
            dPadXValue = xValue
            dPadYValue = yValue
            isLongPressing = true
        }
        
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler =  { rt, xValue, yValue in
            set_mouse_move_state(xValue: xValue, yValue: yValue)
        }
        
        // 处理上下左右滚动
        var isHoldScroll = false
        var scrollY :Float = 0
        // 设置定时器来检测长按状态
        let timer_hold = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if isHoldScroll {
                let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: .pixel,
                                          wheelCount: 1, wheel1: Int32(scrollY) * 1, wheel2: 0, wheel3: 0)

                scrollEvent?.post(tap: .cghidEventTap)
                scrollEvent?.post(tap: .cghidEventTap)
            }
        }
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler =  { rt, xValue, yValue in
            if abs(xValue) < 1e-5 && abs(yValue) < 1e-5 {
                isHoldScroll = false
            }
            else {
                isHoldScroll = true
                scrollY = yValue * 10
            }
        }
        
        func simulateArrowKey(key: UInt16, keyDown: Bool) {
            let keyEvent = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: keyDown)
            keyEvent?.post(tap: .cghidEventTap)
        }
        
        // 处理方向键的移动，移动鼠标
        var dPadPressed = false
        var dPad_X: Float = 0
        var dPad_Y: Float = 0
        var dPad_count :Int = 0
        var control_key_pressed = false
        let timer_dpad_hold = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if dPadPressed {
                var i = 0
                if dPad_X < -1e-5 {
                    simulateArrowKey(key: 123, keyDown: true)
                    simulateArrowKey(key: 123, keyDown: false)
                }
                else if dPad_X > 1e-5 {
                    simulateArrowKey(key: 124, keyDown: true)
                    simulateArrowKey(key: 124, keyDown: false)
                }
                if dPad_Y > 1e-5 {
                    simulateArrowKey(key: 126, keyDown: true)
                    simulateArrowKey(key: 126, keyDown: false)
                }
                else if dPad_Y < -1e-5 {
                    simulateArrowKey(key: 125, keyDown: true)
                    simulateArrowKey(key: 125, keyDown: false)
                }
                i += 1
                if control_key_pressed {
                    dPadPressed = false
                }
            }
        }
        controller.extendedGamepad?.dpad.valueChangedHandler = { dpad, xValue, yValue in
            print(xValue, yValue)
            if abs(xValue) < 1e-5 && abs(yValue) < 1e-5 {
                dPadPressed = false
                dPad_count = 0
            }
            else {
                dPadPressed = true
                dPad_X = xValue
                dPad_Y = yValue
                dPad_count += 1
            }
        }
        controller.extendedGamepad?.buttonY.valueChangedHandler = { button, value, pressed in
            print("buttonY state: \(pressed)")
            if pressed {
                // 模拟按下和释放Control键
                simulateArrowKey(key: 59, keyDown: true)
                control_key_pressed = true
            }
            else {
                simulateArrowKey(key: 59, keyDown: false)
                control_key_pressed = false
            }
        }
        
        let dual_sense_controller = controller.extendedGamepad as? GCDualSenseGamepad
        if dual_sense_controller != nil {
            print("is dual sense controller")
            
            var primary_last_pos_x :Float = 0.0
            var primary_last_pos_y :Float = 0.0
            var mouse_start_loc_x :Float = 0.0
            var mouse_start_loc_y :Float = 0.0
            
            dual_sense_controller?.touchpadPrimary.valueChangedHandler = { button, value, pressed in
                var xv = button.xAxis.value
                var yv = button.yAxis.value
                if xv == 0 && yv == 0 {
                    primary_last_pos_x = 0.0
                    primary_last_pos_y = 0.0
                    return
                }
                if primary_last_pos_x == 0 && primary_last_pos_y == 0 {
                    primary_last_pos_x = xv
                    primary_last_pos_y = yv
                    let mouse_pos = getCurrentMouseLocation()
                    mouse_start_loc_x = Float(mouse_pos.x)
                    mouse_start_loc_y = Float(mouse_pos.y)
                    return
                }
                
                let mainScreen = NSScreen.main
                let screenFrame = mainScreen?.frame
                // print("---- \(screenFrame?.width) \(screenFrame?.height)")
                var w:Float = Float(screenFrame?.width ?? 1728)
                var h:Float = Float(screenFrame?.height ?? 1117)

                var dx = (xv - primary_last_pos_x) * w / 2
                var dy = (yv - primary_last_pos_y) * h / 2
                let nx = max(0, min(mouse_start_loc_x + dx, w))
                let ny = max(0, min(mouse_start_loc_y - dy, h))
                
                print("\(mouse_start_loc_x) \(mouse_start_loc_y), \(primary_last_pos_x) \(primary_last_pos_y)")
                print("     \(dx) \(dy), \(nx) \(ny)")
                
                if abs(dx) < 10 && abs(dy) < 10 {
                    return
                }
                
                
                
                performMouseAction(x: Float(nx), y: Float(ny), event_type: .mouseMoved)
            }
            dual_sense_controller?.touchpadSecondary.valueChangedHandler = { button, value, pressed in
                print("secondary \(value) \(button)")
                
            }
            dual_sense_controller?.touchpadButton.valueChangedHandler = { button, value, pressed in
                print("touchpad click \(value) \(button)")
                print("leftTrigger state: \(pressed)")
                if pressed {
                    mouse_action_here(event_type: .leftMouseDown)
                }
                else {
                    mouse_action_here(event_type: .leftMouseUp)
                }
            }
        }
    }
    
    // 监听游戏控制器的连接
    NotificationCenter.default.addObserver(forName: .GCControllerDidConnect, object: nil, queue: nil) { note in
        _closure(note: note)
    }
    
    // 监听游戏控制器的连接
    NotificationCenter.default.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: nil) { note in
        print("Device disconnected")
        let notification = Notification(name: NSNotification.Name("UpdateUI"), object: nil, userInfo: ["message": "No device connected" ])
        NotificationCenter.default.post(notification)
    }


    // 开始检测游戏控制器
    GCController.startWirelessControllerDiscovery {
        print("Finished discovering wireless controllers")
    }
    
}
