-- Utils --
local Utils = {}

function Utils.awardBadge(player : Player, badgeId : number) : boolean
	local BadgeService = game:GetService("BadgeService")
	
	local success, badgeInfo = pcall(function()
		return BadgeService:GetBadgeInfoAsync(badgeId)
	end)

	if success then
		if badgeInfo.IsEnabled then
			local awardSuccess, result = pcall(function()
				return BadgeService:AwardBadge(player.UserId, badgeId)
			end)
			
			return result and awardSuccess
		end
	else
		warn("Error while fetching badge info: " .. badgeInfo)
	end
	
	return success
end

function Utils.isEffect(e : any) : boolean
	return e:IsA("ParticleEmitter") or e:IsA("Fire") or e:IsA("Trail") or e:IsA("Beam") or e:IsA("Smoke") or e:IsA("Highlight")
end

function Utils.lerp(a : Vector3, b : Vector3, t : number) : Vector3
	return a + (b - a) * t
end

function Utils.quadraticBezier(a : Vector3, b : Vector3, c : Vector3, t : number) : Vector3
	local point1 = Utils.lerp(a, b, t)
	local point2 = Utils.lerp(b, c, t)
	local calculatedPoint = Utils.lerp(point1, point2, t)

	return calculatedPoint
end

function Utils.isMobile() : boolean
	local UIS = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")
	
	if UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled and not UIS.GamepadEnabled and not GuiService:IsTenFootInterface() then
		return true
	else
		return false
	end
end

function Utils.commaValue(n : number) : string
	local formatted = n
	local k = nil

	while k ~= 0 do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
	end

	return formatted
end

function Utils.roundNumber(n : number, numberOfDecimalPlaces : number?) : number
	local split = string.split(string.format("%." .. (numberOfDecimalPlaces or 0) .. "f", n), ".")
	local newSplit = string.split(split[2], "")

	while tostring(newSplit[#split[2]]) == "0" do
		table.remove(newSplit, #split[2])
	end

	if newSplit and newSplit[1] then
		local toReturn = ""

		for _, place in pairs(newSplit) do
			toReturn = toReturn .. place
		end
		
		local toNumber = tonumber(split[1] .. "." .. toReturn)

		return (toNumber and toNumber) or (split[1] .. "." .. toReturn)
	else
		local toNumber = tonumber(split[1])
		
		return (toNumber and toNumber) or (split[1])
	end
end

function Utils.formatNumber(n : number, onlyIfHigherThan : number?, noCommas : boolean?) : string | number
	local names = {"K","M","B","T","q","Q","s","S","O","N","d","U","D","t"}
	local pows = {}
	
	for i = 1, #names do table.insert(pows, 1000^i) end
	
	local ab = math.abs(n)

	if ab < onlyIfHigherThan then return (noCommas and n) or (Utils.commaValue(math.round(n))) end 

	local p = math.min(math.floor(math.log10(ab) / 3), #names)
	local num = math.floor(ab / pows[p] * 100) / 100

	return num * math.sign(n) .. names[p]
end

function Utils.Format(n : number, formatString : string) : string
	return string.format(formatString, n)
end

function Utils.convertToHMS(sec : number, includeDecimals : boolean?) : string
	local mins = (sec - sec % 60) / 60
	sec = sec - mins * 60

	local hrs = (mins - mins % 60) / 60
	mins = mins - hrs * 60

	if includeDecimals then
		return Utils.Format(hrs, "%02i") .. ":" .. Utils.Format(mins, "%02i") .. ":" .. Utils.roundNumber(sec, 2)
	else
		return Utils.Format(hrs, "%02i") .. ":" .. Utils.Format(mins, "%02i") .. ":" .. Utils.Format(sec, "%02i")
	end
end

function Utils.getLastInput() : string?
	local UserInputService = game:GetService("UserInputService")
	local lastType = UserInputService:GetLastInputType()
	local uiType = Enum.UserInputType

	if lastType == uiType.Touch then
		return "touch"
	elseif lastType == uiType.Keyboard or lastType == uiType.MouseMovement or lastType == uiType.MouseButton1    
		or lastType == uiType.MouseWheel or lastType == uiType.MouseButton2 or lastType == uiType.MouseButton3 then
		return "mouse"
	elseif lastType == uiType.Gamepad1 or lastType == uiType.Gamepad2 or lastType == uiType.Gamepad3
		or lastType == uiType.Gamepad4 or lastType == uiType.Gamepad5 or lastType == uiType.Gamepad6
		or lastType == uiType.Gamepad7 or lastType == uiType.Gamepad8 then
		return "controller"
	end
	
	return nil
end

function Utils.getCountryCode(player : Player) : string?
	local LocalizationService = game:GetService("LocalizationService")

	local result, code = pcall(function()
		return LocalizationService:GetCountryRegionForPlayerAsync(player)
	end)

	if result and code then
		return code
	else
		return nil
	end
end

function Utils.getCountryEmojiFromCode(code : string) : string?
	local unicodes = require(script:FindFirstChild("Unicodes") or 17601580421)
	
	if unicodes then
		local split = string.split(code, "")
		return unicodes[string.lower(split[1])] .. unicodes[string.lower(split[2])]
	else
		return nil
	end
end

function Utils.getPlayerFromString(str : string) : Player?
	for _, v in pairs(game:GetService("Players"):GetPlayers()) do
		if string.find(string.lower(v.Name), string.lower(str)) then
			return v
		end
	end
	
	return nil
end

function Utils.canSendGameInvite(player : Player) : boolean?
	local SocialService = game:GetService("SocialService")
	
	local success, canSend = pcall(function()
		return SocialService:CanSendGameInviteAsync(player)
	end)

	return success and canSend
end

function Utils.isInGroupAsync(userId : number, groupId : number) : boolean?
	local GroupService = game:GetService("GroupService")
	
	for _, v in pairs(GroupService:GetGroupsAsync(userId)) do
		if v.Id == groupId then
			return true
		end
	end
		
	return false
end

return Utils
