//
//  KeyboardControl.swift
//  ControllerControl
//
//  Created by Acane on 2024/3/10.
//

import Foundation

func performKeyEvent(key: UInt16, keyDown: Bool) {
    let keyEvent = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: keyDown)
    keyEvent?.post(tap: .cghidEventTap)
}

// KeyCode
enum KeyCode: UInt16 {
    case controlKey = 59
    case leftArrow = 123
    case rightArrow = 124
    case upArrow = 125
    case downArrow = 126
}
