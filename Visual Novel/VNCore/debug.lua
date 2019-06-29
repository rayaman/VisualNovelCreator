local vncore = require("VNCore")
local multi = require("multi")
if not vncore.loaded then
    error("The vncore module needs to be loaded and initiated before it can be used!")
end
local debug = {}
local taskmanagerDetails = {}
local debugF = gui:newFrame("DebugFrame",0,0,0,0,0,0,1,1)
debugF.Visibility = 0--.5
debugF.Color = Color.Black
vncore.getWorkspace().Active = false
vncore.getWorkspace().Visibility = 1
-- debugF.Visible = false
local taskmanager = debugF:newFrame("TaskManager",0,0,400,500,0,0)
taskmanager.scroll = taskmanager:newFrame("ScrollBar",-20,30,20,-60,1,0,0,1)
taskmanager.header = taskmanager:newTextLabel(" Task Manager","Task Manager",1,1,-2,29,0,0,1)
taskmanager.header.X = taskmanager.header:newTextButton("X","X",-25,5,20,20,1)
taskmanager.header.X.Color = Color.Red
taskmanager.header.X:setRoundness(4,4,60)
taskmanager.details = taskmanager:newTextLabel(" Details","",1,-31,-2,30,0,1,1)
taskmanager.header:AddDrawRuleE(function(self)
    love.graphics.line(self.x, self.y+self.height, self.x+self.width, self.y+self.height)
end)
taskmanager.details:AddDrawRuleE(function(self)
    love.graphics.line(self.x, self.y+1, self.x+self.width, self.y+1)
end)
--taskmanager.frame = taskmanager:new
taskmanager:setRoundness(8,8,180)
gui.massMutate({ 
    TextFormat = "middleleft",
    BorderSize = 0,
    [[setRoundness(8,8,180)]],
},taskmanager.header,taskmanager.details)
taskmanager:centerX()
taskmanager:centerY()
function debug:show(frame)
    vncore.getWorkspace().Active = false -- Prevents click events from functioning
    if not frame then
        -- Show the console
    elseif frame == "tasks" then
        -- Show the task manager
    end
end
function debug:hide(frame)
    vncore.getWorkspace().Active = true -- Reinstates the click events on the workspace
    if not frame then
        -- Hide everything
    end
end
multi:newThread("DebugHandler",function()
    while true do
        thread.hold(function()
            return debugF.Visible -- If the debug frame is not in view dont bother process any debug info
        end)
        thread.sleep(.1)
        taskmanagerDetails = multi:getTasksDetails("t")
        debugF:TopStack()
    end
end)
return debug