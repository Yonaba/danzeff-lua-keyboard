# danzeff-lua-keyboard
*Emulating Danzeff's Keyboard for LuaPlayerHM*

What's this ?
-------------

Danzeff Lua Keyboard is a virtual keyboard to let you write easily some text on screen in your Lua Homebrews.
It might be useful for simple text writing, but not as a full text editor.

Commands
-------------
Tapping `R` or `L` triggers cycling through the 4 (four) sets of characters supported.

* Set 1: Lowercase Alphabetic letters
* Set 2: Uppercase Alphabetic letters
* Set 3: Numbers
* Set 4: Special characters

Move `Analog` to select a block of character. Any block is composed of 4 characters matching with 4 buttons on your Sony's PSP. <br>
Tap `Triangle` or `Square` or `Cross` or `Circle` button to input the desired character.<br>
`Select` enables or disables the keyboard

Usage
-------------
First, include the library itself by copying the OSK folder in your Homebrew.
Then load the library in your program using `loadfile` or `require` or `dofile` command.

```lua
require './OSK/osk'
loadfile './OSK/osk.lua'
dofile './OSK/osk.lua'
````

In your main application, out of the main loop, create a new keyboard and init it with the X & Y coordinates corresponding to where you want to place your input.

```lua
myKeyboard= OSK:New()
myKeyboard:Init(myX,myY)
````

Now declare a string where you want to hold the inputted text.

```lua
myText = ''
````

In the main Loop, read a characted from the keyboard input using `osk:Input()`.You must have declared a `pad` and an `oldpad` variables before.

```lua
local char = osk:Input(pad,oldpad)
if char then
  if char=='del' then 
  text = string.sub(text,1,-2)
  else text = text..char
  end
end
````

Note: When you hit `del` on the keyboard, it returns string 'del'. You'll have to deal with that issue as shown in the previous code to withdraw the last written character.

Now print your text using `osk:Print()`

```lua
osk:Print(text)
````

This last command draws the Virtual keyboard.

```lua
osk:Draw(pad,oldpad) 
````

The usage is pretty simple as you see. Just refers to the given example for more details.

Acknowledgements 
----------------
* Danzel & Jeff for pics, and the original keyboard
* Homemister for LuaPlayerHM
* Devsgen & XtreamLua Communities members


License
--------------
This software is [MIT-Licensed](LICENSE).<br>
*Copyright (c) 2012 Roland Yonaba.*
