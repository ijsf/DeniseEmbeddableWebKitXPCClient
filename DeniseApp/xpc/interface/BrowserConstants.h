//
//  Copyright © 2018-2020 C.E. Etheredge. All rights reserved.
//

#pragma once

enum LoadEvent {
    LOAD_UNKNOWN,
    
    LOAD_STARTED,
    LOAD_REDIRECTED,
    LOAD_COMMITTED,
    LOAD_FINISHED
};

enum ModifierKeys {
    MODIFIER_NONE = 0,
    MODIFIER_SHIFT = 1,
    MODIFIER_CTRL = 2,
    MODIFIER_ALT = 4,
    MODIFIER_COMMAND = 8,
    MODIFIER_LEFT_MOUSE = 16,
    MODIFIER_RIGHT_MOUSE = 32,
    MODIFIER_MIDDLE_MOUSE = 64
};

enum Key {
    KEY_SPACE = 0x20,
    KEY_ESCAPE = 0xff1b,
    KEY_RETURN = 0xff0d,
    KEY_TAB = 0xff09,
    KEY_DELETE = 0xffff,
    KEY_BACKSPACE = 0xff08,
    KEY_INSERT = 0xff63,
    KEY_UP = 0xff52,
    KEY_DOWN = 0xff54,
    KEY_LEFT = 0xff51,
    KEY_RIGHT = 0xff53,
    KEY_PAGE_UP = 0xff55,
    KEY_PAGE_DOWN = 0xff56,
    KEY_HOME = 0xff50,
    KEY_END = 0xff57,
    
    KEY_F1 = 0xffbe,
    KEY_F2 = 0xffbf,
    KEY_F3 = 0xffc0,
    KEY_F4 = 0xffc1,
    KEY_F5 = 0xffc2,
    KEY_F6 = 0xffc3,
    KEY_F7 = 0xffc4,
    KEY_F8 = 0xffc5,
    KEY_F9 = 0xffc6,
    KEY_F10 = 0xffc7,
    KEY_F11 = 0xffc8,
    KEY_F12 = 0xffc9,
    
    KEY_NUMPAD_0 = 0xffb0,
    KEY_NUMPAD_1 = 0xffb1,
    KEY_NUMPAD_2 = 0xffb2,
    KEY_NUMPAD_3 = 0xffb3,
    KEY_NUMPAD_4 = 0xffb4,
    KEY_NUMPAD_5 = 0xffb5,
    KEY_NUMPAD_6 = 0xffb6,
    KEY_NUMPAD_7 = 0xffb7,
    KEY_NUMPAD_8 = 0xffb8,
    KEY_NUMPAD_9 = 0xffb9,
    
    KEY_NUMPAD_ADD = 0xffab,
    KEY_NUMPAD_SUBTRACT = 0xffad,
    KEY_NUMPAD_MULTIPLY = 0xffaa,
    KEY_NUMPAD_DIVIDE = 0xffaf,
    KEY_NUMPAD_SEPARATOR = 0xffac,
    KEY_NUMPAD_DECIMAL = 0xffae,
    KEY_NUMPAD_EQUAL = 0xffbd,
    KEY_NUMPAD_DELETE = 0xff9f
};
