//
//  MouseControl.swift
//  ControllerControl
//
//  Created by Acane on 2024/3/10.
//

import Foundation


import Foundation
import GameController

func performMouseAction(x: Float, y: Float, event_type: CGEventType) {
    let mainScreen = NSScreen.main
    let screenFrame = mainScreen?.frame
    // print("---- \(screenFrame?.width) \(screenFrame?.height)")
    let w:Float = Float(screenFrame?.width ?? 1728)
    let h:Float = Float(screenFrame?.height ?? 1117)
    let nx = min(max(x, 0), w)
    let ny = min(max(y, 0), h)
    let event = CGEvent(mouseEventSource: nil, mouseType: event_type,
                        mouseCursorPosition: CGPoint(x: CGFloat(nx), y: CGFloat(ny)),
                        mouseButton: .left)
    event?.post(tap: .cghidEventTap)
}


