require("Libs/Library")
local multi = require("multi")
local bin = require("bin")
GLOBAL,sThread = require("multi.integration.loveManager").init()
require("GuiManager")
require("parseManager")
--VNCore = require("VNCore").init(gui:newFullFrame("Main"), parseManager, multi)
--debug = require("VNCore.debug")

win = gui:newWindow("Taskmanager",500,20)
test = win:newTabMenu(0,0,500,600)
test:setTabHeight(30)
local tasks, tasks_b = test:addTab("Tasks",Color.new(60,60,60), Color.new(80,80,80))
threads,threads_b = test:addTab("Threads",Color.new(60,60,60), Color.new(80,80,80))
sthreads,sthreads_b = test:addTab("SThreads",Color.new(60,60,60), Color.new(80,80,80))
details,details_b = test:addTab("Details",Color.new(60,60,60), Color.new(80,80,80))
local ST_Menu = sthreads:newScrollMenu("System Threads")
local T_Menu = threads:newScrollMenu("Threads")
local TASKS_Menu = tasks:newScrollMenu("Tasks")
--local DETAILS_Menu -- We need to manage this one a bit differently
refFrame = gui:newFrame("Reference Object"):asRef() -- Makes cloning an object seamless, since we set this as an object we expect to be cloned
refFrame.ItemName = refFrame:newTextLabel("Item Name","Item Name",5,3,0,19)
refFrame.ItemName:widthToTextSize()
refFrame.ItemPR = refFrame.ItemName:newTextLabel("Running","Running",5,0,0,0,1,0,0,1) -- Doubles as Resume thread as well
refFrame.ItemPR:widthToTextSize()
refFrame.ItemKill = refFrame.ItemPR:newTextLabel("Kill","Kill",5,0,0,0,1,0,0,1) -- Doubles as Resume thread as well
refFrame.ItemKill:widthToTextSize()
refFrame.ItemUpTime = refFrame.ItemKill:newTextLabel("Uptime","Uptime",5,0,0,0,1,0,0,1) -- Doubles as Resume thread as well
refFrame.ItemUpTime:widthToTextSize()
local function pr(b,self)
	if self.GLink:isPaused() then
		self.text = "Running"
		self:widthToTextSize()
		self.GLink:Resume()
	else
		self.text = "Paused"
		self:widthToTextSize()
		self.GLink:Pause()
	end
end
local function kill(b,self)
	self.GLink:Destroy()
end
--temp:setRef{
--	[[fitFont()]],
--}

	--ST_Menu:addItem("System Threads "..i, 25, 1,refFrame:clone())
	--T_Menu:addItem("Threads "..i, 25, 1,refFrame:clone())
	--
local listref = {
	["ProcessName"] = true,
	["CyclesPerSecondPerTask"] = true,
	["MemoryUsage"] = true,
	["ThreadCount"] = true,
	["SystemLoad"] = true,
	["PriorityScheme"] = true,
	["SystemThreadCount"] = true,
	_Tasks = {},
	_Threads = {},
	_SystemThreads = {},
}
function table.sync(a,b)
	for i,v in pairs(b) do
		if a[i] then
			a[i] = v
		end
	end
end
multi:newThread("Updater",function()
	while true do
		local taskslist = multi:getTasksDetails("t")
		table.sync(listref,taskslist) -- Managing details
		thread.sleep(.1)
		for i=1,#taskslist.Tasks do
			if not listref._Tasks[taskslist.Tasks[i].TID] then
				local ref = TASKS_Menu:addItem("Tasks "..i, 25, 1,refFrame:clone())
				ref.GLink = taskslist.Tasks[i].Link
				ref.ItemKill:OnReleased(kill)
				ref.ItemKill.GLink = ref.GLink
				ref.ItemPR:OnReleased(pr)
				ref.ItemPR.GLink = ref.GLink
				listref._Tasks[taskslist.Tasks[i].TID] = {ref,taskslist.Tasks[i].Link}
				ref.ItemName.text = taskslist.Tasks[i].Name
				ref.ItemName:widthToTextSize()
				ref.ItemUpTime.text = "Uptime: "..taskslist.Tasks[i].Uptime
				ref.ItemUpTime:widthToTextSize()
			elseif listref._Tasks[taskslist.Tasks[i].TID] then
				-- Update whats already there
				listref._Tasks[taskslist.Tasks[i].TID][1].ItemUpTime.text = taskslist.Tasks[i].Priority.." | "..taskslist.Tasks[i].Type.." | "..taskslist.Tasks[i].Uptime
				listref._Tasks[taskslist.Tasks[i].TID][1].ItemUpTime:widthToTextSize()
			end
		end
		for i,v in pairs(listref._Tasks) do
			if v[2].Destroyed then
				TASKS_Menu:removeItem(v[1])
				listref._Tasks[i] = nil
			end
		end
		for i=1,#taskslist.Threads do
			if not listref._Threads[taskslist.Threads[i].TID] then
				local ref = T_Menu:addItem("Tasks "..i, 25, 1,refFrame:clone())
				ref.GLink = taskslist.Threads[i].Link
				ref.ItemKill:OnReleased(kill)
				ref.ItemKill.GLink = ref.GLink
				ref.ItemPR:OnReleased(pr)
				ref.ItemPR.GLink = ref.GLink
				listref._Threads[taskslist.Threads[i].TID] = {ref,taskslist.Threads[i].Link}
				ref.ItemName.text = taskslist.Threads[i].Name
				ref.ItemName:widthToTextSize()
				ref.ItemUpTime.text = "Uptime: "..taskslist.Threads[i].Uptime
				ref.ItemUpTime:widthToTextSize()
			elseif listref._Threads[taskslist.Threads[i].TID] then
				if taskslist.Tasks[i] then
					listref._Threads[taskslist.Threads[i].TID][1].ItemUpTime.text = "Uptime: "..taskslist.Tasks[i].Uptime
					listref._Threads[taskslist.Threads[i].TID][1].ItemUpTime:widthToTextSize()
				end
			end
		end
		for i,v in pairs(listref._Tasks) do
			if v[2].Destroyed then
				TASKS_Menu:removeItem(v[1])
				listref._Tasks[i] = nil
			end
		end
	end
end)
settings = {protect = true,priority = 2}
function love.update()
	multi:uManager(settings)
end

multi.OnError(function(...)
	print(...)
end)
