require("Libs/Library")
local multi = require("multi")
local bin = require("bin")
GLOBAL,sThread = require("multi.integration.loveManager").init()
require("GuiManager")
require("parseManager")
--VNCore = require("VNCore").init(gui:newFullFrame("Main"), parseManager, multi)
--debug = require("VNCore.debug")
local TM_Count = 0
function gui:newTabMenu(x,y,w,h,sx,sy,sw,sh)
	TM_Count = TM_Count + 1
	local c = self:newFrame("TabMenu_"..TM_Count,x,y,w,h,sx,sy,sw,sh)
	c.Id = TM_Count
	c.tabs = {}
	c.frames = {}
	c.tabheight = 30
	function c:setTabHeight(n)
		self.tabheight = n or 30
	end
	function c:updateTabs()
		local n = #self.tabs
		for i = 1,#self.tabs do
			self.tabs[i]:SetDualDim(0,0,0,self.tabheight,(i-1)/n,0,1/n)
			multi.nextStep(function()
				self.tabs[i]:fitFont()
			end)
		end
	end
	function c:addTab(name,c1,c2)
		local bnt = self:newTextLabel(name,name,0,0,0,self.tabheight)
		local frame = self:newFrame(name,0,self.tabheight,0,-self.tabheight,0,0,1,1)
		bnt.Frame = frame
		if c1 then
			bnt.Color = c1
			frame.Color = c1
		end
		if c2 then
			frame.Color = c2
		end
		table.insert(self.tabs,bnt)
		table.insert(self.frames,frame)
		self:updateTabs()
		bnt:OnReleased(function(b,self)
			for i = 1,#c.frames do
				c.frames[i].Visible = false
			end
			self.Frame.Visible = true
		end)
		return frame,bnt
	end
	function c:removeTab(name)

	end
	return c
end
local wincount = 0
function gui:newWindow(name)
	local win=self:newFrame(0+(wincount*25),0+(wincount*25),400,20)
	wincount=wincount+1
	win:enableDragging(true)
	win.dragbut="l"
	if name then
		local font=love.graphics.getFont()
		win.title=win:newTextLabel(name,0,0,font:getWidth(name),20)
		win.title.TextFormat="left"
		win.title.Visibility=0
		win.title.XTween=3
		win.title.Tween=3
	end
	win:ApplyGradient({Color.new(70,70,70),Color.Darken(Color.new(70,70,70),.25),trans=200})
	win.close=win:newImageButton("GuiManager/icons/cancel.png",-20,2,16,16,1)
	local click = false
	win:OnClicked(function(b,self)
		if not click then
			self:TopStack()
			click = true
		end
	end)
	win:OnReleased(function(b,self)
		click = false
	end)
	win.close:OnReleased(function(b,self)
		self.Parent:Destroy()
		love.mouse.setCursor()
	end)
	win.holder=win:newFrame(0,0,0,280,0,1,1)
	win.holder.Color = Color.new(25,25,25)
	return win.holder,win
end
win = gui:newWindow("Taskmanager")
test = win:newTabMenu(0,0,400,500)
test:setTabHeight(30)
f,b = test:addTab("Tasks",Color.new(60,60,60), Color.new(80,80,80))
f,b = test:addTab("Threads",Color.new(60,60,60), Color.new(80,80,80))
f,b = test:addTab("SThreads",Color.new(60,60,60), Color.new(80,80,80))
f,b = test:addTab("Details",Color.new(60,60,60), Color.new(80,80,80))
local temp = f:newScrollMenu("System Threads")
temp:setRef{
	[[fitFont()]],
}
local f
for i=1,20 do
	hmm=temp:addItem("Item "..i, math.random(30,60), 5)
	hmm:OnReleased(function(b,self)
		print(self.text)
	end)
	if i == 1 then
		f = hmm
	end
end
temp:removeItem(f)
function love.update()
	multi:uManager()
end
multi.OnError(function(...)
	print(...)
end)
