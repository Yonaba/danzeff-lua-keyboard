--Copyright (c) 2012 Roland Yonaba

--[[
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--% file osk Danzeff Keyboard Lua Version.
--% class OSK The Main keyboard class.
print('require', ...)
local PATH = (...):match('(.+)[/%.]osk$')
print('PATH', PATH .. "/assets/keys.png")
local f = io.open('PATH .. "/assets/keys.png"')
print('io.open', f)
local OSK = {
	  --% attribute active boolean Holds The status of the keyboard: true Means active (shown), false means inactive.
	  active = true,
	  --% attribute pictures table List all keyboard pictures.
	  pictures = {
		[1] = Image.load(PATH .. "/assets/keys.png"),
		[3] = Image.load("./OSK/nums.png"),
		[2] = Image.load("./OSK/keys_c.png"),
		[4] = Image.load("./OSK/nums_c.png"),
	  },
	  --% attribute pictures_shade table List all keyboard shaded pictures.
	   pictures_shade = {
		[1] = Image.load("./OSK/keys_t.png"),
		[3] = Image.load("./OSK/nums_t.png"),
		[2] = Image.load("./OSK/keys_c_t.png"),
		[4] = Image.load("./OSK/nums_c_t.png"),
	  },
	  --% attribute caption table Define keyboard caption box coordinates and picture.
	  caption = {x = 2,y = 2,picture = Image.createEmpty(150,150)},	
	  --% attribute mode number Holds the current character set : 1 for Lowercase Letters, 2 for Uppercase Letters, 3 for nums and 4 for Extra characters.
	  mode = 1,
	  --% attribute oskX number X coordinate where keyboard will be blitted on screen.
	  oskX = 480-151,
	  --% attribute oskY number Y coordinate where keyboard will be blitted on screen.
	  oskY = 272-151,
	  --% attribute keys_map table Contains characters set.
	  keys_map = {
				--mode 1: letters
				[1]={ 					
					[1] = { [1]={',','a','b','c'}, 
							[2]={'.','d','e','f'},
							[3]={'!','g','h','i'},
						  },
					[2] = { [1]={'-','j','k','l'},
							[2]={'del','m',' ','n'},
							[3]={'?','o','p','q'},
						  },
					[3] = { [1]={'(','r','s','t'},
							[2]={':','u','v','w'},
							[3]={')','x','y','z'},
						  },					 
					},
				--mode 2: Uppercase letters
				[2]={ 
							[1] = { [1]={'^','A','B','C'},
							[2]={'@','D','E','F'},
							[3]={'*','G','H','I'},
						  },
					[2] = { [1]={'_','J','K','L'},
							[2]={'del','M',' ','N'},
							[3]={'\"','O','P','Q'},
						  },
					[3] = { [1]={'=','R','S','T'},
							[2]={';','U','V','W'},
							[3]={'/','X','Y','Z'},
						  },					 
					},
				--mode 3: Nums
				[3]={ 
							[1] = { [1]={'','','','1'},
							[2]={'','','','2'},
							[3]={'','','','3'},
						  },
					[2] = { [1]={'','','','4'},
							[2]={'del','',' ','5'},
							[3]={'','','','6'},
						  },
					[3] = { [1]={'','','','7'},
							[2]={'','','','8'},
							[3]={'','','0','9'},
						  },					 
					},
				--mode 4: extra characters
				[4]={ 
							[1] = { [1]={',','(','.',')'},
							[2]={'\"','<',',','>'},
							[3]={'-','[','_',']'},
						  },
					[2] = { [1]={'!','{','?','}'},
							[2]={'del','',' ',''},
							[3]={'+','\\','=','/'},
						  },
					[3] = { [1]={':','@',';','#'},
							[2]={'~','$','`','%'},
							[3]={'*','^','|','&'},
						  },					 
					},					
	  },
	  --% attribute printX number X coordinate where text will be blitted on screen.Use Init(x,y) Method to modify this.
	  printX = 0,
	  --% attribute printY number Y coordinate where text will be blitted on screen.Use Init(x,y) Method to modify this.
	  printY = 0,
	}

--% method Init(x,y) Inits the keyboard at coordinates X,Y.
--% arg number x X coordinate of text input.
--% arg number  Y coordinate of text input.
--% ret nil Returns nothing.
function OSK:Init(x,y)
	self.printX = x or 0
	self.printY = y or 0
end

--% method New() Returns a new OSK Object.
--% ret osk An OSK Instance.
function OSK:New()
   local osk = {}
   setmetatable(osk, self)
   self.__index = self
   return osk
end

--% method setMode(pad, oldpad) Sets Visible a Character Set
--% arg table pad A Controls:read() object declared in the main loop.
--% arg table oldpad A Controls:read()object declared out of the main loop.
--% ret nil Returns nothing.
function OSK:setMode(pad,oldpad)
	if pad and oldpad then
		if pad:r() and not oldpad:r() then
		self.mode = self.mode+1
		elseif pad:l() and not oldpad:l() then
		self.mode = self.mode-1
		end
	end
	if self.mode > 4 then self.mode = 1 end
	if self.mode < 1 then self.mode = 4 end
end


--% method drawCaption(pad) Draws the caption box.
--% arg table pad A Controls:read() object declared in the main loop.
--% ret nil Returns nothing.
function OSK:drawCaption(pad)
	if pad then
		if pad:analogX() < -42 then self.caption.x = 1
		elseif pad:analogX() > 42  then self.caption.x = 3
		else self.caption.x = 2 
		end
		if pad:analogY() < -42 then self.caption.y = 1
		elseif pad:analogY() > 42  then self.caption.y = 3
		else self.caption.y = 2 
		end
	end
	self.caption.picture:blit(0,0,self.pictures[self.mode])
	screen:blit(480-150+(self.caption.x-1)*50,272-150+(self.caption.y-1)*50,self.caption.picture,50*(self.caption.x-1),50*(self.caption.y-1),50,50)
end

--% method PadBinding(pad,oldpad) Matches a pressed key with a character in the current caption box.
--% arg table pad A Controls:read() object declared in the main loop.
--% arg table oldpad A Controls:read()object declared out of the main loop.
--% ret nil Returns nothing.
function OSK.PadBinding(pad,oldpad)
	if pad then
		if pad:triangle() and not oldpad:triangle() then return 1 end
		if pad:square() and not oldpad:square()  then return 2 end
		if pad:cross() and not oldpad:cross()  then return 3 end
		if pad:circle() and not oldpad:circle() then return 4 end
	end
end

--% method Input(pad,oldpad) Returns the last input chararacter.
--% arg table pad A Controls:read() object declared in the main loop.
--% arg table oldpad A Controls:read()object declared out of the main loop.
--% ret char The last input character.
function OSK:Input(pad,oldpad)	
	if self.active then
		local key_map_offset = self.PadBinding(pad,oldpad)	
		if key_map_offset then
		local char = self.keys_map[self.mode][self.caption.y][self.caption.x][key_map_offset]
		return char
		end
	end
end

--% method Print(text,color) Prints the string text with Color at previously defined X,Y coordinates.
--% arg string text The current string inputted.
--% arg userdata Color A custom color. This argument is optionnal.Default value is White Color (Color.new(255,255,255)).
--% ret nil Returns nothing.
function OSK:Print(text,color)
	if text then
	screen:print(self.printX,self.printY,((self.active) and text..'_' or text),color or Color.new(255,255,255))
	end
end

--% method Draw(pad,oldpad) Draws the Virtual keyboard.
--% arg table pad A Controls:read() object declared in the main loop.
--% arg table oldpad A Controls:read()object declared out of the main loop.
--% ret nil Returns nothing.
function OSK:Draw(pad,oldpad)
	if pad:select() and not oldpad:select() then self.active = not self.active end
	if self.active then
		self:setMode(pad,oldpad)
		screen:blit(self.oskX,self.oskY,self.pictures_shade[self.mode])
		self:drawCaption(pad)
	end
end

return OSK

