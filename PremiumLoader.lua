repeat
	task.wait()
until game:IsLoaded()

local FOLDER_PATH = "ScyllaV2"
local KEY_PATH = FOLDER_PATH.."/PremiumKey.txt"

if not isfolder(FOLDER_PATH) then 
    makefolder(FOLDER_PATH)
end

script_key = script_key or (isfile(KEY_PATH) and readfile(KEY_PATH) or nil)

local Cloneref = cloneref or clonereference or function(instance) return instance end
local Players = Cloneref(game:GetService("Players"))
local HttpService = Cloneref(game:GetService("HttpService"))
local Request = http_request or request or syn.request or http

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/acezqqq/moddedfluent/refs/heads/main/main.lua"))()
local API = loadstring(game:HttpGet("https://sdkAPI-public.luarmor.net/library.lua"))()

local games = {
	TypeSoul = 4871329703,
	DIG = 7218065222,
	BLR = 6325068386,
	GhoulRe = 6490954291,
	GAG = 7436755782
}

local GAME_SCRIPTS = {
    TypeSoul = "1e2d49a1084a1a6e3bdeb4c3c0ee31ac",
    DIG = "dea730b1e1caba481d4090d3ac2514da",
    BLR = "14d860e5b3f0a71c45ac877e07177807",
    GhoulRe = "36ba19ea80ed17546d9a00db75ee0e34",
    GAG = "4f6c35e87cff68d943ba48699e3b9b02",
}

local OVERRIDES = {}

local function nga()
    if OVERRIDES[game.PlaceId] then
        return OVERRIDES[game.PlaceId]
    end
	
    for name, universeId in pairs(games) do
        if game.GameId == tonumber(universeId) then
            return GAME_SCRIPTS[name]
        end
    end

    return nil
end

local scriptId = nga()


if not scriptId then
    Players.LocalPlayer:Kick("Scylla doesn't support this game | Join our discord for more information")
    return
end

API.script_id = scriptId

local function notify(title, content, duration)
	UI:Notify({ Title = title, Content = content, Duration = duration or 8 })
end

local function openDiscord()
    setclipboard("https://discord.gg/ScyllaHub")
    notify("Copied To Clipboard", "Discord Server Link has been copied to your clipboard", 16)
    local discordInviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()
    discordInviter.Join("https://discord.com/invite/ScyllaHub")
end

local function checkKey(input_key)
    local key = input_key or script_key
    if not key then return notify("Key Error", "No key provided") end
    
	local status = API.check_key(key)
	
	if status.code == "KEY_VALID" then
		script_key = key
		writefile(KEY_PATH, script_key)
        API.load_script()
        UI:Destroy()
        return true
	elseif status.code:find("KEY_") then
		local messages = {
			KEY_HWID_LOCKED = "Key linked to a different HWID. Please reset it using our bot",
			KEY_INCORRECT = "Key is incorrect",
			KEY_INVALID = "Key is invalid"
		}
		notify("Key Check Failed", messages[status.code] or "Unknown error")
	else
		Players.LocalPlayer:Kick("Key check failed: " .. status.message .. " Code: " .. status.code)
	end
	return false
end

local function createUI()
    local Window = UI:CreateWindow({
        Title = "Scylla",
        SubTitle = "Premium",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 320),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.End
    })

    local Tabs = { Main = Window:AddTab({ Title = "Key", Icon = "" }) }

    local Input = Tabs.Main:AddInput("Key", {
        Title = "Enter Key:",
        Default = script_key or "",
        Placeholder = "Example: agKhRikQP..",
        Numeric = false,
        Finished = false
    })

    Tabs.Main:AddButton({
        Title = "Buy Key",
        Callback = function()
			openDiscord()
        end
    })

    Tabs.Main:AddButton({
        Title = "Check Key",
        Callback = function()
            checkKey(Input.Value)
        end
    })

    Tabs.Main:AddButton({
        Title = "Join Discord",
        Callback = openDiscord
    })

    Window:SelectTab(1)
    notify("Scylla", "Loader Has Loaded Successfully")
end

if script_key then
	if not checkKey() then
        createUI()
    end
else
    createUI()
end

repeat
	task.wait()
until getgenv().ScyllaKey
