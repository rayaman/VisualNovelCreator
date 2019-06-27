require("Libs/Library")
local multi = require("multi")
local bin = require("bin")
GLOBAL,sThread = require("multi.integration.loveManager").init()
require("GuiManager")
require("parseManager")
local handle = parseManager:load("init.dms")
handle:define{
	sleep = thread.sleep
}
local disp = gui:newTextLabel("","",0,0,200,100)
local go = false
disp:OnReleased(function()
	go = true
end)
parseManager.print(handle:dump())
handle.__TEXT = function(text)
	disp.text = text
	thread.hold(function()
		return go
	end)
	go = false
end
multi:newThread("Runner",function()
	local active = true
	while true do
		thread.skip()
		active = handle:think()
	end
end)
function love.update()
	multi:uManager()
end
multi.OnError(function(...)
	print(...)
end)