local vncore = {}
vncore.loaded = false
local HUD,workspace,disp,chat,name,disp,handle
function vncore.getHUD()
    return HUD
end
function vncore.getWorkspace()
    return workspace
end
function vncore.getStateMachine()
    return handle
end
-- We need to manage the disp, chat and name loval varaibles
function vncore.init(frame, parseManager, multi)
    if vncore.loaded then return vncore.__Frame end
    vncore.__Frame = frame
    frame.Visibility = 0
    workspace = frame:newImageLabel(nil,"Workspace", 0,0,0,0,0,0,1,1)
    workspace.Color = Color.Green
    HUD = frame:newFullFrame("HUD")
    local go = false
    HUD.Visibility = 0
    handle = parseManager:load("init.dms")
    handle:define{
        sleep = thread.sleep
    }
    chat = HUD:newTextLabel("","",0,0,0,0,.5/40,31/40,39/40,1/5)
    name = chat:newTextLabel("Name","Name",0,0,80,0,0,-1.165/5,0,1/5)
    name.Visible = false
    name:fitFont()
    name:widthToTextSize()
    name:setRoundness(6,6,180)
    disp = chat:newTextLabel("","",15/2,15/2,-15,-15,0,0,1,1)
    disp.TextFormat = "left"
    disp.Font = name.Font
    disp.Visibility = 0
    disp.BorderSize = 0
    chat:setRoundness(15,15,180)
    workspace:OnReleased(function(b,self)
        if b == "l" then
            go = true
        else
            HUD.Visible = not HUD.Visible
        end
    end)
    parseManager.print("\n"..handle:dump())
    handle.__TEXT = function(text) -- change the default text stuff
        local n,txt = text:match("([%w ]+):(.+)")
        if disp.text == "" then
            go = true
        end
        thread.hold(function()
            return go
        end)
        if n then
            text = txt
            name.text = n
            name:widthToTextSize()
            name.Visible = true
        end
        go = false
        disp.text = ""
        for i in text:gmatch(".") do
            disp.text = disp.text .. i
            thread.sleep(.1)
            if go then disp.text = text go = false break end
        end
    end
    multi:newThread("Runner",function()
        local active = true
        while true do
            thread.skip()
            active = handle:think()
        end
    end)
    vncore.loaded = true
    return vncore
end
return vncore