//
//  NativeAPI.c
//  ControllerControl
//
//  Created by Acane on 2024/3/10.
//

#include "NativeAPI.h"

#include <ApplicationServices/ApplicationServices.h>
#include <unistd.h>

void invokeMouseEvent(int x, int y, int event_code) {
    CGEventRef event = CGEventCreateMouseEvent(
          NULL, kCGEventLeftMouseDown,
          CGPointMake(x, y),
          event_code
    );
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}

CGPoint getCurrentMouseLocation() {
    CGEventRef event = CGEventCreate(NULL);
    CGPoint cursor = CGEventGetLocation(event);
    CFRelease(event);
    return cursor;
}
