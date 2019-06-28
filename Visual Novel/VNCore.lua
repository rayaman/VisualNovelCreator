return {
    init = function(frame, parseManager, multi)
        frame.Visibility = 0
        local workspace = frame:newImageLabel(nil,"Workspace", 0,0,0,0,0,0,1,1)
        workspace.Color = Color.Green
        local HUD = frame:newFullFrame("HUD")
        local go = false
        HUD.Visibility = 0
        local handle = parseManager:load("init.dms")
        handle:define{
            sleep = thread.sleep
        }
        local chat = HUD:newTextLabel("","",0,0,0,0,.5/40,31/40,39/40,1/5)
        local name = chat:newTextLabel("Name","Name",0,0,80,0,0,-1.165/5,0,1/5)
        name.Visible = false
        name:fitFont()
        name:widthToTextSize()
        name:setRoundness(6,6,180)
        local disp = chat:newTextLabel("","",15/2,15/2,-15,-15,0,0,1,1)
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
            local pan = false
            local n,txt = text:match("([%w ]+):(.+)")
            if n then
                text = txt
                name.text = n
                name:widthToTextSize()
                name.Visible = true
            end
            multi:newThread("UpdateText",function()
                disp.text = ""
                for i in text:gmatch(".") do
                    disp.text = disp.text .. i
                    thread.sleep(.05)
                    if go then disp.text = text go = false pan = true break end
                end
                pan = true
                go = false
            end)
            thread.hold(function()
                return pan
            end)
            pan = false
        end
        multi:newThread("Runner",function()
            local active = true
            while true do
                thread.skip()
                active = handle:think()
            end
        end)
        return frame
    end
}