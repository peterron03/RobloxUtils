-- Utils --
local Utils = {}

-- Services --
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

function Utils.isEffect(e : any)
	return e:IsA("ParticleEmitter") or e:IsA("Fire") or e:IsA("Trail") or e:IsA("Beam") or e:IsA("Smoke") or e:IsA("Highlight")
end

function Utils.lerp(a, b, t)
	return a + (b - a) * t
end

function Utils.quadraticBezier(a, b, c, t)
	local point1 = Utils.lerp(a, b, t)
	local point2 = Utils.lerp(b, c, t)
	local calculatedPoint = Utils.lerp(point1, point2, t)

	return calculatedPoint
end

function Utils.isMobile()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled and not UserInputService.GamepadEnabled and not GuiService:IsTenFootInterface() then
		return true
	else
		return false
	end
end

function Utils.commaValue(n : number)
	local formatted = n
	local k = nil

	while k ~= 0 do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
	end

	return formatted
end

function Utils.roundNumber(n : number, numberOfDecimalPlaces : number?)
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

		return split[1] .. "." .. toReturn
	else
		return split[1]
	end
end

function Utils.formatNumber(n : number, onlyIfHigherThan : number?) 
	local names = {"K","M","B","T","q","Q","s","S","O","N","d","U","D","t"}
	local pows = {}
	
	for i = 1, #names do table.insert(pows, 1000^i) end
	
	local ab = math.abs(n)

	if ab < onlyIfHigherThan then return Utils.commaValue(math.round(n)) end 

	local p = math.min(math.floor(math.log10(ab) / 3), #names)
	local num = math.floor(ab / pows[p] * 100) / 100

	return num * math.sign(n) .. names[p]
end

function Utils.Format(n : number)
	return string.format("%02i", n)
end

function Utils.convertToHMS(sec : number, includeDecimals : boolean?)
	local mins = (sec - sec % 60) / 60
	sec = sec - mins * 60

	local hrs = (mins - mins % 60) / 60
	mins = mins - hrs * 60

	if includeDecimals then
		return Utils.Format(hrs).. ":" .. Utils.Format(mins).. ":" .. Utils.roundNumber(sec, 2)
	else
		return Utils.Format(hrs).. ":" .. Utils.Format(mins).. ":" .. Utils.Format(sec)
	end
end

function Utils.getLastInput()
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
end

return Utils
