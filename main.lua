--Loads the Library
local OSK = require "src.osk"

local IO = {''}
local cur=1

-- Helper to force not repeating input on key press
local function Add(key,oldkey)
	if key and oldkey then
		if key:up() and not oldkey:up() then
			if IO[cur-1] then cur = cur-1 end
		elseif key:down() and not oldkey:down() then			
		cur = cur+1
			if not (IO[cur+1]) then IO[cur+1]='' end
		end
	end
end

-- output
local function Print()
	for k in ipairs(IO) do
		screen:print(10,10*k,IO[k]..(k==cur and '_' or ''),Color.new(255,255,255))
	end
end

--Defines X-Y coordinates for text printing
myX = 10
myY = 10

--Creates a new keyboard
osk = OSK:New()

--Inits it
osk:Init(myX,myY)

--A custom variable to hold written text
local text=''

--pad binding
local oldpad = Controls.read()

--


--Main Loop
while true do
local pad = Controls.read() --pad binding
screen:clear() --clears screen
screen:print(10,260,cur,Color.new(255,255,255))
 
--Reads a new character from the keyboard and formats the custom variable holding written text
Add(pad,oldpad)

local char = osk:Input(pad,oldpad) 
if char then
	if char=='del' then 
	IO[cur] = string.sub(IO[cur],1,-2)
	else IO[cur] = IO[cur]..char
	end
end

Print()


--Draws the keyboard
osk:Draw(pad,oldpad) 

--end of loop
oldpad = pad 
screen.flip()
screen.waitVblankStart()
end