//
//  NativeAPI.h
//  ControllerControl
//
//  Created by Acane on 2024/3/10.
//

#ifndef NativeAPI_h
#define NativeAPI_h

#include <ApplicationServices/ApplicationServices.h>

void invokeMouseEvent(int x, int y, int event);

CGPoint getCurrentMouseLocation();

#endif /* NativeAPI_h */
