-- Services --
local UserInputService = game:GetService("UserInputService")

-- Utils --
local Utils = {}
local cachedBadgeInfo = {}

function Utils.isPrivateServer() : boolean
	return game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0
end

function Utils.createSignal(eventName : string, remotes : Folder?) : RemoteEvent
	local signal = Instance.new("RemoteEvent")
	signal.Name = eventName
	signal.Parent = remotes or game:GetService("ReplicatedStorage")
	return signal
end

function Utils.isInViewCone(part : BasePart, cameraCFrame : CFrame, viewportSize : Vector2, fov : number) : boolean
	local camForward = cameraCFrame.LookVector
	local toPart = (part.Position - cameraCFrame.Position).Unit

	local dot = camForward:Dot(toPart)

	local vFov = math.rad(fov)
	local aspect = viewportSize.X / viewportSize.Y
	local hFov = 2 * math.atan(math.tan(vFov / 2) * aspect)
	local minDot = math.cos(hFov / 2)

	return dot >= minDot
end

function Utils.roundVector3(vector3 : Vector3, amount : number) : Vector3
	return Vector3.new(
		math.round(vec.X * amount) / amount,
		math.round(vec.Y * amount) / amount,
		math.round(vec.Z * amount) / amount
	)
end

function Utils.lerpColor(color1 : Color3, color2 : Color3, alpha : number) : Color3
	return Color3.new(
		color1.R + (color2.R - color1.R) * alpha,
		color1.G + (color2.G - color1.G) * alpha,
		color1.B + (color2.B - color1.B) * alpha
	)
end

function Utils.playTempSoundClone(sound : Sound, destroyAfter : number?)
	local cloned = sound:Clone()
	cloned.Parent = sound.Parent
	cloned:Play()

	task.delay(destroyAfter or 5, function()
		cloned:Destroy()
	end)
end

function Utils.getHRPAndHumanoidFromPlayer(player : Player) : (BasePart, Humanoid)
	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChild("Humanoid")

	return hrp, humanoid
end

function Utils.getRandomValuesFromArray(array : {any}, min : number, max : number, increasedChanceForValue : {value : string, chance : number}?) : {any}
	if increasedChanceForValue then
		local toAdd = math.round(#array * increasedChanceForValue.chance) - 1

		if toAdd > 0 then
			for i = 1, toAdd do
				table.insert(array, increasedChanceForValue.value)
			end
		end
	end
	
	local random = math.random(min, max)
	local values = {}

	for i = 1, random do
		table.insert(values, array[math.random(1, #array)])
	end

	return values
end

function Utils.playerOwnsBadge(player : Player, badgeId : number) : boolean
	local BadgeService = game:GetService("BadgeService")
	
	local success, result = pcall(function()
		return BadgeService:UserHasBadgeAsync(player.UserId, badgeId)
	end)
	
	if success then
		return result
	else
		warn(result)
		return false
	end
end

function Utils.awardBadge(player : Player, badgeId : number, timeDelay : number?) : boolean
	local BadgeService = game:GetService("BadgeService")
	
	if type(timeDelay) ~= "number" then timeDelay = 0 end
	
	local success, badgeInfo = pcall(function()
		if not cachedBadgeInfo[badgeId] then
			cachedBadgeInfo[badgeId] = BadgeService:GetBadgeInfoAsync(badgeId)
		end
		
		return cachedBadgeInfo[badgeId]
	end)

	if success then
		task.delay(timeDelay or 0, function()
			if badgeInfo.IsEnabled then
				local awardSuccess, result = pcall(function()
					if not Utils.playerOwnsBadge(player, badgeId) then
						return BadgeService:AwardBadge(player.UserId, badgeId)
					end
				end)
				
				if not awardSuccess then
					local success2, result2 = pcall(function()
						return BadgeService:AwardBadge(player.UserId, badgeId)
					end)
					
					return result2 and success2
				end
				
				return result and awardSuccess
			end
		end)
	else
		cachedBadgeInfo[badgeId] = nil
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

function Utils.toNewRange(n : number, oldMin : number, oldMax : number, min : number, max : number) : number
	return (min + ((max - min) * ((n - oldMin) / (oldMax - oldMin))))
end

function Utils.roundToNearest(x : number, mult : number) : number
	return math.round(x / mult) * mult
end

function Utils.roundNumber(n : number, numberOfDecimalPlaces : number?) : number
	local split = string.split(string.format("%." .. (numberOfDecimalPlaces or 0) .. "f", n), ".")
	local split2 = split[2] or "0"
	local newSplit = string.split(split2, "")

	while tostring(newSplit[#split2]) == "0" do
		table.remove(newSplit, #split2)
	end

	if newSplit and newSplit[1] then
		local toReturn = ""

		for _, place in newSplit do
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
	
	onlyIfHigherThan = onlyIfHigherThan or 1000
	
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

function Utils.convertToDHMS(sec : number, includeDecimals : boolean?) : string
	local mins = (sec - sec % 60) / 60
	sec = sec - mins * 60

	local hrs = (mins - mins % 60) / 60
	mins = mins - hrs * 60
	
	local days = (hrs - hrs % 24) / 24
	hrs = hrs - days * 24

	if includeDecimals then
		return Utils.Format(days, "%02i") .. ":" .. Utils.Format(hrs, "%02i") .. ":" .. Utils.Format(mins, "%02i") .. ":" .. Utils.roundNumber(sec, 2)
	else
		return Utils.Format(days, "%02i") .. ":" .. Utils.Format(hrs, "%02i") .. ":" .. Utils.Format(mins, "%02i") .. ":" .. Utils.Format(sec, "%02i")
	end
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
	for _, v in game:GetService("Players"):GetPlayers() do
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
	
	for _, v in GroupService:GetGroupsAsync(userId) do
		if v.Id == groupId then
			return true
		end
	end
		
	return false
end

function Utils.sendNotification(title : string, message : string, icon : string?, button1 : string?, button2 : string?, callback : BindableEvent?)
	local StarterGui = game:GetService("StarterGui")
	
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = message,
		Duration = #message * 0.15,
		Icon = icon,
		Button1 = button1,
		Button2 = button2,
		Callback = callback
	})
end

return Utils
