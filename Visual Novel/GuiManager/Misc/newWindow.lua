local wincount = 0
function gui:newWindow(name,win_width,win_height)
	local win=self:newFrame(0+(wincount*25),0+(wincount*25),win_width or 400,win_height or 20)
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
	win.close=win:newImageButton("GuiManager/icons/cancel.png",-(win_height or 20),2,(win_height or 20)-4,(win_height or 20)-4,1)
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