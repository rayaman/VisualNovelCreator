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