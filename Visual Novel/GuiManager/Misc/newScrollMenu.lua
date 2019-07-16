function gui:newScrollMenu(name,SC,MC)
	local temp = self:newFullFrame(name)
	temp.ref = {
		[[setNewFont(16)]],
		[[setRoundness(10,10,180)]],
		Tween = 6
	}
	temp.allowOverlapping = true
	temp.Visibility = 0
	local ScrollY = temp:newFrame(name.."ScrollY",-20,0,20,0,1,0,0,1)
	temp.scroll = ScrollY
	local cc = self.Color
	local c1,c2=Color.new(cc[1]*255,cc[2]*255,cc[3]*255),Color.new(cc[1]*255+20,cc[2]*255+20,cc[3]*255+20)
	print(cc[1]-20,cc[2]-20,cc[3]-20)
	ScrollY.Color=SC or c1
	ScrollY.allowOverlapping = true
	ScrollY.Mover = ScrollY:newFrame(name.."MoverY",5,5,10,80)
	ScrollY.Mover.Color = MC or c2
	local func = function(b,self,x,y,nn)
		temp.symbolicY = y
		if y>45 and y<self.height-45 then
			self.Mover:SetDualDim(nil,y-40)
			temp.first:setDualDim(nil,nil,nil,nil,nil,-((y-46)/(self.height-92))*((temp.max-temp.height+60)/temp.height))
			if not nn then
				self:setMouseXY(10)
			end
		end
	end
	ScrollY:OnClicked(func)
	temp.symbolicY = 45
	temp.scrollM = 2
	temp:OnMouseWheelMoved(function(self,x,y)
		temp.symbolicY=temp.symbolicY-(y*temp.scrollM)
		if temp.symbolicY<45 then
			temp.symbolicY = 45
		elseif temp.symbolicY>ScrollY.height-40 then
			temp.symbolicY = ScrollY.height-40
		end
		func("l",ScrollY,x,temp.symbolicY,true)
	end)
	temp.ClipDescendants=true
	temp.first = temp:newTextLabel("","",15,10,-50,40,0,0,1)
	local nice = temp:newTextLabel(name,name,15,10,-50,40,0,0,1)
	temp.header = nice
	temp.last = temp.first
	temp.last.BorderSize = 0
	temp.last.Visibility = 0
	nice:setNewFont(26)
	nice.Tween = 6
	temp.list = {}
	local alarm
	multi:newLoop(function()
		for i=1,#temp.list do
			local val = (temp.first.y+(temp.list[i].staticpos)+10)
			if val>temp.y and val<temp.height+temp.y+temp.height then
				temp.list[i].Visible = true
			else
				temp.list[i].Visible = false
			end
		end
	end)
	function temp:setRef(ref)
		self.ref = ref
	end
	temp.max = 40
	function temp:addItem(text, height, padding, obj)
		local padding = padding or 10
		local height = height or 30
		temp.max = temp.max + padding-- + height
		if obj then
			obj:SetDualDim(0,temp.max-padding+padding,0,height,0,0,1)
			obj:setParent(self.first)
		end
		local c = obj or self.first:newTextLabel(text,text,0,temp.max-padding+padding,0,height,0,0,1)
		if not obj then
			c:Mutate(temp.ref)
		end
		c.adjustment = padding + height
		temp.max = temp.max + height
		c.staticpos = temp.max
		c.LID = #temp.list
		temp.list[#temp.list+1] = c
		return c
	end
	function temp:removeItem(obj)
		local id = obj.LID
		if not id then error("GUI object is not part of this menu!") end
		self.max = self.max - obj.adjustment
		local adj = obj.adjustment
		obj:Destroy()
		for i = id+1,#self.list do
			self.list[i]:setDualDim(nil,self.list[i].offset.pos.y-adj)
		end
	end
	return temp
end