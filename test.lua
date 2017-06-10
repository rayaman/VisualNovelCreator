package.path=package.path..";?/init.lua"
require("Libs/bin")
require("Libs/Multimanager")
require("dialogueManager")
test=dialogueManager:load("Tests.dmf")
t=test:start()-- start the reading
while true do--  working on saving and loading of data
	if t.Type=="text" then
		if test.stats.reading then
			local a=t.text:find(":")
			if a then
				if t.text=="..." then
					speak(t.text:sub(1,a-1).." Didn't say a word!")
				else
					speak(t.text:sub(1,a-1).." says: "..t.text:sub(a+1,-1))
				end
			else
				speak(t.text)
			end
		else
			io.write(t.text)
			io.read()
		end
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
		if test.stats.reading then
			speak(t.text)
		else
			print(t.text)
		end
		for i=1,#t.choices do
			io.write(i..": "..t.choices[i].."\n")
		end
		io.write("Enter choice#: ")
		local n=tonumber(io.read())
		t=test:next(t,n)
	elseif t.Type=="end" then
		if t.text=="leaking" then--  go directly to the block right under the current block if it exists
			t=test:next()
		else
			print(t.text)
			os.exit()--  if you have more than one dialogue objects you are using, you may want to change this from exiting the code to escaping your loop or changing the reference to t. Remember seperate block objects cannot access variables from each other!
		end
	elseif t.Type=="error" then
		print(t.text)
		io.read()
	else
		t=test:next()
	end
end
