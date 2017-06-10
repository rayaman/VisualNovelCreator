--package.path="/?/init.lua;"..package.path
require("Libs/Library")
require("Libs/Utils")
require("Libs/bin")
require("Libs/MultiManager")
require("parseManager")
require("Libs/lovebind")
require("GuiManager")
gui.LoadAll("Interface")
function form(link,x,y,w,h,sx,sy,sw,sh)
    local x,y,w,h,sx,sy,sw,sh=(link:varExists(x) or tonumber(x)),(link:varExists(y) or tonumber(y)),(link:varExists(w) or tonumber(w)),(link:varExists(h) or tonumber(h)),(link:varExists(sx) or tonumber(sx)),(link:varExists(sy) or tonumber(sy)),(link:varExists(sw) or tonumber(sw)),(link:varExists(sh) or tonumber(sh))
    return x,y,w,h,sx,sy,sw,sh
end
parseManager.internalcount=0
parseManager.funcType=function(link,name,t,data,filename)
    if parseManager.loaded then print("Thread loaded not going to re-init!") return end
    local ft,args=t:match("(function)(%b())")
    if ft~="function" then return false end
    local _args=parseManager.split(args)
    local phantomChunk=link._chunks[name][1]
    local func=function(self,...)
      if type(self)~="table" then
        thread=link._methods.newThread(link,name)
        print("THREAD:",self,thread.test,link)
        local args_={self,...}
        for i=1,#args_ do
            if _args[i] then
              thread.test._variables[(_args[i]:gsub("%)",""):gsub("%(",""))]=args_[i]
            end
        end
        print("!!Diff Thread Method")
      else
        print("MAINTHREAD:",self,link,test)
        print("!!Same Thread Method")
        parseManager.internalcount=parseManager.internalcount+1
        test._chunks[name][1]=phantomChunk.."\nGOTO(__TEMPGOTO"..parseManager.internalcount.."__)"
        test._labels["__TEMPGOTO"..parseManager.internalcount.."__"]={self._cblockname,test.pos}
        test._methods.JUMP(test,name)
      end
    end
    link._variables[name]=func
    link._methods[name]=func
end
parseManager.OnExtendedBlock(parseManager.funcType)
function parseManager:pushError(err)
	print(err) -- print to the console
	local file=self._chunks[self._cblockname].file
	local d={}
	if love then
    print(file)
		d=bin.new((love.filesystem.read(file)))
	else
		d=bin.load(file)
	end
	local t=d:lines()
	local pos=0
	--Sigh... comments are still a pain to deal with...
	local cc=d:match("%["..self._cblockname.."[:.-]?%].-({.-})")
	cc=cc:gsub("{.-\n","")
	cc=cc:gsub((self._cblock[self.pos]:gsub("%%","%%%%"):gsub("%(","%%%("):gsub("%)","%%%)"):gsub("%[","%%%["):gsub("%]","%%%]"):gsub("%+","%%%+"):gsub("%-","%%%-"):gsub("%*","%%%*"):gsub("%.","%%%."):gsub("%$","%%%$"):gsub("%^","%%%^")).."(.+)","NOPE LOL")
	--mlc,a=cc:gsub("%-%-%[%[.-%]%]","\n")
	--print(mlc)
	--d=#bin._lines(mlc or "")
	_,b=cc:gsub("(%-%-.-)\n","\n")
	_,c=cc:gsub("%-:.-:%-","\n")
	e=b+c
	print(a,b,c)
	for i=1,#t do
		if t[i]:find("["..self._cblockname,1,true) then
			pos=i+self.pos
			break
		end
	end
	error("In Block '"..self._cblockname.."' LIQ: '"..self._cblock[self.pos].."' Filename: "..file.." On line: "..pos+e..": "..err)
end
actornum=0
animnum=0
rand=randomGen:new(0)
parseManager:define{
    getInput=multi:newFunction(function(mulitobj,self,msg)
        inputBox.message.text=msg
        inputBox.Visible=true
        go.Visible=false
        self.handle:Pause()
        while _inputvar==nil do
            multi:lManager()
        end
        self.handle:Resume()
        local i=_inputvar
        _inputvar=nil
        inputBox.Visible=false
        go.Visible=true
        return i
    end),
    loadAudio=function(self,path)
        return love.audio.newSource(path)
    end,
    loadSong=function(self,path)
        print(path)
        return love.audio.newSource(path)
    end,
    playSongLooped=function(self,item)
        item:setLooping(true)
        item:play()
    end,
    playAudio=function(self,item)
        item:play()
    end,
    playSong=function(self,item)
        item:play()
    end,
    sleep=function(self,n)
        local num=n
        self.handle:hold(num)
    end,
    fadeSong=function(self,item)
        self.handle:Pause()
        local handle=self:varExists(item)
        local step=multi:newTStep(100,0,-1,.05)
        step:OnStep(function(pos,self)
            handle:setVolume(pos/100)
        end)
        while handle:getVolume()~=0 do
            multi:lManager()
        end
        self.handle:Resume()
    end,
    stopAudio=function(self,item)
        item:stop()
    end,
    stopSong=function(self,item)
        if self:varExists(item)==nil then
            love.audio.stop()
            return
        end
        item:stop()
    end,
    pauseAudio=function(self,item)
        item:pause()
    end,
    cls=function(self)
        core.chatFrame.textHolder.text=""
    end,
    BG=function(self,path)
      core:SetImage(path)
    end,
    SHOW=function(self,item)
        self:varExists(item).Visible=true
    end,
    HIDE=function(self,item)
        self:varExists(item).Visible=false
    end,
    createObject=function(self,x,y,w,h,sx,sy,sw,sh)
        actornum=actornum+1
        local x,y,w,h,sx,sy,sw,sh=form(self,x,y,w,h,sx,sy,sw,sh)
        local obj=workspace:newItem("",nil,"Actor "..actornum, x, y, w, h, sx ,sy ,sw ,sh)
        if obj.DPI>=2 then
          obj.DPI=obj.DPI-1
        end
		print("OBJECT: "..tostring(obj))
        return obj
    end,
    makeObject=function(self,link,x,y,w,h,sx,sy,sw,sh)
        actornum=actornum+1
        local x,y,w,h,sx,sy,sw,sh=form(self,x,y,w,h,sx,sy,sw,sh)
        local obj= link:newItem("",nil,"Actor "..actornum, x, y, w, h, sx ,sy ,sw ,sh)
        if obj.DPI>=2 then
            obj.DPI=obj.DPI-1
        end
        return obj
    end,
    createAnimation=function(self,file,delay,x,y,w,h,sx,sy,sw,sh)
        local file,delay=(self:varExists(file) or file),(tonumber(self:varExists(delay)) or tonumber(delay))
        animnum=animnum+1
        local x,y,w,h,sx,sy,sw,sh=form(self,x,y,w,h,sx,sy,sw,sh)
        local anim = workspace:newAnim(file,delay, x, y, w, h, sx ,sy ,sw ,sh)
        anim:OnAnimEnd(function(link)
            link:Reset()
            link:Resume()
        end)
        if anim.DPI>=2 then
          anim.DPI=anim.DPI-1
        end
        return anim
    end,
    stopAnimation=function(self,item)
        item:Pause()
    end,
    resumeAnimation=function(self,item)
        item:Resume()
    end,
    resetAnimation=function(self,item)
        item:Reset()
    end,
    setImage=function(self,item,path)
		smartPrint(item)
        item:SetImage(path)
    end,
    setText=function(self,item,text)
		if type(item)=="string" then
			print(actor)
			self:pushError("item must be a gui object!")
		end
        item.text=text
    end,
    JUMPPLAY=function(self,to,handle)
        self._methods.playSong(self,handle)
        self._methods.JUMP(self,to)
    end,
    setPosition=function(self,item,x,y,w,h,sx,sy,sw,sh)
        local x,y,w,h,sx,sy,sw,sh=form(self,x,y,w,h,sx,sy,sw,sh)
        item:SetDualDim(x,y,w,h,sx,sy,sw,sh)
    end,
    makeDraggable=function(self,item,db)
        item.Draggable=true
        if db then
          item.dragbut=db
        end
    end,
    centerX=function(self,item)
        item:centerX()
    end,
    centerY=function(self,item)
        item:centerY()
    end,
    centerXY=function(self,item)
        item:centerX()
        item:centerY()
    end,
    setVar=function(self,v,t) if t=="n" then return tonumber(v) else return v end end,
    destroy=function(self,item)
        item:Destroy()
    end,
    newThread=function(blocklink,block)
      local loop=multi:newLoop(function(ti,self)
          if self.t.Type=="text" then
            print(self.t.text)
             self.t=self.test:next()
          elseif self.t.Type=="condition" then
           self.t=self.test:next()
          elseif self.t.Type=="assignment" then
            self.t=self.test:next()
          elseif self.t.Type=="label" then
            self.t=self.test:next()
          elseif self.t.Type=="method" then
            self.t=self.test:next()
          elseif self.t.Type=="choice" then
            self.t=self.test:next(self.t,math.random(1,#self.t.choices))
          elseif self.t.Type=="end" then
            self:Destroy()
          elseif self.t.Type=="error" then
            print(self.t.text)
          else
            self.t=self.test:next()
          end
      end)
      loop.test=parseManager:load(blocklink._chunks[blocklink._cblockname].file)
      loop.test._variables=blocklink._variables
      loop.test.handle=loop
      loop.t=loop.test:start(block)
      return loop
    end,
}
gui.enableAutoWindowScaling(true)
core=gui:newImageLabel(nil,0,0,0,0,0,0,1,1)--gui:newFullImageLabel("fire.jpg","BG")
workspace=core:newFullFrame()
top=gui:newFrame("",0,0,0,0,0,0,1,1)
workspace.Visibility=0
top.Visibility=0
core.chatFrame=core:newFrame("chatFrame",20,-100,-40,80,0,1,1)
core.chatFrame:setRoundness(10,10,360)
core.chatFrame.BorderSize=4
core.chatFrame.textHolder=core.chatFrame:newTextLabel("","",5,5,-10,-10,0,0,1,1)
core.chatFrame.textHolder.Visibility=0
core.chatFrame.textHolder.text=""
core.chatFrame.textHolder.TextFormat="left"
parseManager:setVariable("gui",workspace)
parseManager:setVariable("__workspace",workspace)
parseManager:setVariable("__top",top)
parseManager:setVariable("__menu",top)
test=parseManager:load("structure.dat")
t=test:start("CONDITIONS")
go=core.chatFrame.textHolder:newImageButton("arrow.png",-25,-25,20,20,1,1)
go:OnReleased(function(b,self)
   dialogeHandler:Resume()
end)
dialogeHandler=multi:newLoop(function(ti,self)
	if t.Type=="text" then
		core.chatFrame.textHolder.text=t.text
		self:Pause()
		t=test:next()
	elseif t.Type=="condition" then
		t=test:next()
	elseif t.Type=="assignment" then
		t=test:next()
	elseif t.Type=="label" then
		t=test:next()
	elseif t.Type=="method" then
		t=test:next()
	elseif t.Type=="choice" then
		go.Visible=false
		local choiceframe=gui:newFrame("",0,0,300,(#t.choices+1)*40-10)
		choiceframe:newTextLabel(t.text,0,0,0,40,0,0,1).Color=Color.light_blue
		for i=1,#t.choices do
			local choice=choiceframe:newTextButton(t.choices[i],0,i*40,0,40,0,0,1)
			choice.Color=Color.Darken(Color.saddle_brown,.15)
			choice.index=i
			choice:OnReleased(function(b,self)
				choicemade=self.index
			end)
		end
		choiceframe:centerX()
		choiceframe:centerY()
		self:Pause()
		while choicemade==nil do
			multi:lManager()
		end
		self:Resume()
		go.Visible=true
		choiceframe:Destroy()
		local cm=choicemade
		choicemade=nil
		t=test:next(nil,cm,nil,t)
	elseif t.Type=="end" then
		if t.text=="leaking" then -- go directly to the block right under the current block if it exists
			t=test:next()
		else
      --os.exit()
		end
	elseif t.Type=="error" then
		error(t.text)
	else
		test:next()
	end
end)
test.handle=dialogeHandler
inputBox=gui:newFrame(0,0,500,160)
inputBox.Visibility=0
inputBox.header=inputBox:newFrame(0,0,8,28,0,0,1)
inputBox.header.Visibility=0
inputBox.header.ClipDescendants=true
inputBox.header.helper=inputBox.header:newFrame("",4,4,-8,40,0,0,1)
inputBox.header.helper.BorderSize=4
inputBox.header.helper:setRoundness(10,20,360)
inputBox.header.helper:ApplyGradient{Color.Brown,Color.Lighten(Color.Brown,.15)}
inputBox.body=inputBox:newFrame("",4,28,0,150,0,0,1)
inputBox.body.BorderSize=4
inputBox.body:ApplyGradient{Color.tan,Color.Lighten(Color.tan,.3)}
inputBox.X=inputBox.header.helper:newTextButton("X","X",-23,4,15,15,1)
inputBox.X:setRoundness(5,5,360)
inputBox.X:ApplyGradient{Color.red,Color.Lighten(Color.red,.2)}
inputBox.X.Tween=-6
inputBox.X.XTween=-2
inputBox.message=inputBox.body:newTextLabel("","Prompt",0,0,0,0,.05,.1,.9,.5)
inputBox.input2=inputBox.body:newTextLabel("","",0,0,0,30,.05,.65,.7)
inputBox.input=inputBox.body:newTextBox("","Enter Text",0,0,0,30,.05,.65,.7)
inputBox.enter=inputBox.body:newTextButton("","GO",0,0,0,30,.8,.65,.15)
inputBox.message.BorderSize=4
inputBox.input2.BorderSize=4
inputBox.enter.BorderSize=4
inputBox.message:setRoundness(5,5,360)
inputBox.input2:setRoundness(5,5,360)
inputBox.input2:ApplyGradient{Color.tan,Color.Lighten(Color.tan,.2)}
inputBox.enter:ApplyGradient{Color.Darken(Color.green,.2),Color.green}
inputBox.enter:setRoundness(5,5,360)
inputBox.enter:OnReleased(function(b,self)
    _inputvar=inputBox.input.text
    inputBox.Visible=false
end)
inputBox.input:OnEnter(function(self,text)
    _inputvar=inputBox.input.text
    inputBox.Visible=false
end)
inputBox.input.TextFormat="left"
inputBox.input.XTween=3
inputBox.input.Visibility=0
inputBox.input.ClipDescendants=true
inputBox:centerX()
inputBox:centerY()
inputBox.Visible=false
