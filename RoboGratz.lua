local addonName, RoboGratz = ...
RoboGratz.ScheduleTimer = LibStub("AceTimer-3.0").ScheduleTimer

local autoGZ = true
local leuteBegruessen = true	

local lastMsg = 0
local lastAutoGreet = 0

function weighted_total(choices)
	local total = 0
	for i, v in ipairs(choices) do
		total = total + v.weight
	end
	return total
end

function weighted_random_choice(choices)
	local threshold = math.random(0, weighted_total(choices))
	local last_choice
	for i,v in ipairs(choices) do
		threshold = threshold - v.weight
		if threshold <= 0 then return v.msg end
		last_choice = v.msg
	end
	return last_choice
end

local msgs = {
  {msg="gz  {name}", weight=10},
  {msg="gz ", weight=40},
  {msg="gratz ", weight=30},
  {msg="GZ {name}", weight=10},
  {msg="gratz {name}", weight=10}
}

local greets={ "Hallo","Hui","Huhu","halo","hallo","hai","wuhu","tach","hi","hallöööö" }
local byes={ "bye","tschüss","tschau","bis morgen","bis dann","bb","bubu","nachti"}

local greetPatterns = {"abend","hallo","huhu","servus","sers","was geht","halo","guten morgen","moin","hai","hi","tag","holla","guten abend"}
local byePatterns={"bye","tschüss","tschau","bis morgen","bis dann","bb","gute nacht","g8","nachti","gn8","Tschöö"}

totals=weighted_total(msgs)

local MDGZ = CreateFrame("frame")
MDGZ:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

if (autoGZ) then MDGZ:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT"); end
if (leuteBegruessen) then MDGZ:RegisterEvent("CHAT_MSG_GUILD"); end

local function DelayChatMessage(msg)
  SendChatMessage(msg,"GUILD")
end

function MDGZ:CHAT_MSG_GUILD_ACHIEVEMENT(...)
	if (lastMsg < time())then
		local arg = {...}
		local name = arg[2]
		local msg = weighted_random_choice(msgs)
    
    name=string.gsub(name,"%-[^|]+", "")
        
		if (name ~=UnitName("player"))then
			msg = string.gsub(msg, "{name}", name)
      RoboGratz:ScheduleTimer(DelayChatMessage, 2, msg)
		end
		lastMsg=time()+2 --2 seconds 
	end
end

function MDGZ:CHAT_MSG_GUILD(...)
	local msg=...
	local senderName=select(2,...)
	msg=string.lower(msg)
	if (senderName == UnitName("player")) then 
    lastAutoGreet=time()+20
    return 
  end
	if (lastAutoGreet < time()) then
  
		for i = 1, #greetPatterns do
			if (string.find(string.gsub(msg,"(.*)"," %1 "), "[^%a]"..greetPatterns[i].."[^%a]"))then
        RoboGratz:ScheduleTimer(DelayChatMessage, math.random(2, 5), greets[math.random(#greets)])
				lastAutoGreet=time()+20
				return
			end	
		end
		if (msg=="re") then
      RoboGratz:ScheduleTimer(DelayChatMessage,  math.random(2, 3), "wb")
			lastAutoGreet=time()+20
		end
		for i = 1, #byePatterns do
			if (string.find(string.gsub(msg,"(.*)"," %1 "), "[^%a]"..byePatterns[i].."[^%a]"))then
        RoboGratz:ScheduleTimer(DelayChatMessage,  math.random(2, 5), byes[math.random(#byes)])
				lastAutoGreet=time()+20
				return
			end
		end
		
	end
end


