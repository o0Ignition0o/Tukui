local T, C, L = select(2, ...):unpack()

local Loading = CreateFrame("Frame")

function Loading:StoreDefaults()
	T.Defaults = {}

	for group, options in pairs(C) do
		if (not T.Defaults[group]) then
			T.Defaults[group] = {}
		end

		for option, value in pairs(options) do
			T.Defaults[group][option] = value

			if (type(C[group][option]) == "table") then
				if C[group][option].Options then
					T.Defaults[group][option] = value.Value
				else
					T.Defaults[group][option] = value
				end
			else
				T.Defaults[group][option] = value
			end
		end
	end
end

function Loading:LoadCustomSettings()
	local Settings

	if (not TukuiSettingsPerCharacter) then
		TukuiSettingsPerCharacter = {}
	end

	if (not TukuiSettingsPerCharacter[T.MyRealm]) then
		TukuiSettingsPerCharacter[T.MyRealm] = {}
	end

	if (not TukuiSettingsPerCharacter[T.MyRealm][T.MyName]) then
		TukuiSettingsPerCharacter[T.MyRealm][T.MyName] = {}
	end
	
	if not TukuiSettings then
		TukuiSettings = {}
	end
	
	-- Globals settings will be removed in the next coming weeks, if currently using globals, move into current character profile
	if TukuiSettingsPerCharacter[T.MyRealm][T.MyName].General and TukuiSettingsPerCharacter[T.MyRealm][T.MyName].General.UseGlobal == true then
		TukuiSettingsPerCharacter[T.MyRealm][T.MyName] = TukuiSettings
		
		if TukuiSettingsPerCharacter[T.MyRealm][T.MyName].General then
			TukuiSettingsPerCharacter[T.MyRealm][T.MyName].General.UseGlobal = false
		end
	end

	Settings = TukuiSettingsPerCharacter[T.MyRealm][T.MyName]

	for group, options in pairs(Settings) do
		if C[group] then
			local Count = 0

			for option, value in pairs(options) do
				if (C[group][option] ~= nil) then
					if (C[group][option] == value) then
						Settings[group][option] = nil
					else
						Count = Count + 1

						if (type(C[group][option]) == "table") then
							if C[group][option].Options then
								C[group][option].Value = value
							else
								C[group][option] = value
							end
						else
							C[group][option] = value
						end
					end
				end
			end

			-- Keeps settings clean and small
			if (Count == 0) then
				Settings[group] = nil
			end
		else
			Settings[group] = nil
		end
	end
end

function Loading:LoadProfiles()
	local Profiles = C.General.Profiles
	local Menu = Profiles.Options
	local Data = TukuiData
	local GUISettings = TukuiSettingsPerCharacter
	local Nickname = T.MyName
	local Server = T.MyRealm
	
	if not GUISettings then
		return
	end
	
	for Index, Table in pairs(GUISettings) do
		local Server = Index
		
		for Nickname, Settings in pairs(Table) do
			local ProfileName = Server.."-"..Nickname
			local MyProfileName = T.MyRealm.."-"..T.MyName
			
			if MyProfileName ~= ProfileName then
				Menu[ProfileName] = ProfileName
			end
		end
	end
end

function Loading:Enable()
	local Toolkit = T.Toolkit

	self:StoreDefaults()
	self:LoadProfiles()
	self:LoadCustomSettings()

	Toolkit.Settings.BackdropColor = C.General.BackdropColor
	Toolkit.Settings.BorderColor = C.General.ClassColorBorder and T.Colors.class[T.MyClass] or C.General.BorderColor
	Toolkit.Settings.UIScale = C.General.UIScale

	if C.General.HideShadows then
		Toolkit.Settings.ShadowTexture = ""
	end
end

function Loading:OnEvent(event)
	if (event == "PLAYER_LOGIN") then
		T["Inventory"]["Bags"]:Enable()
		T["Inventory"]["Loot"]:Enable()
		T["Inventory"]["GroupLoot"]:Enable()
		T["Inventory"]["Merchant"]:Enable()
		T["Auras"]:Enable()
		T["Maps"]["Minimap"]:Enable()
		T["Maps"]["Zonemap"]:Enable()
		T["Maps"]["Worldmap"]:Enable()
		T["DataTexts"]:Enable()
		T["Chat"]:Enable()
		T["ActionBars"]:Enable()
		T["Cooldowns"]:Enable()
		T["Miscellaneous"]["Experience"]:Enable()
		T["Miscellaneous"]["Errors"]:Enable()
		T["Miscellaneous"]["MirrorTimers"]:Enable()
		T["Miscellaneous"]["DropDown"]:Enable()
		T["Miscellaneous"]["GarbageCollection"]:Enable()
		T["Miscellaneous"]["GameMenu"]:Enable()
		T["Miscellaneous"]["StaticPopups"]:Enable()
		T["Miscellaneous"]["Durability"]:Enable()
		T["Miscellaneous"]["UIWidgets"]:Enable()
		T["Miscellaneous"]["AFK"]:Enable()
		T["Miscellaneous"]["MicroMenu"]:Enable()
		T["Miscellaneous"]["Keybinds"]:Enable()
		T["Miscellaneous"]["TimeManager"]:Enable()
		T["Miscellaneous"]["ThreatBar"]:Enable()
		T["Miscellaneous"]["TalkingHead"]:Enable()
		T["Miscellaneous"]["LossControl"]:Enable()
		T["Miscellaneous"]["DeathRecap"]:Enable()
		T["Miscellaneous"]["Ghost"]:Enable()
		T["Miscellaneous"]["TimerTracker"]:Enable()
		T["Miscellaneous"]["AltPowerBar"]:Enable()
		T["Miscellaneous"]["OrderHall"]:Enable()
		T["Miscellaneous"]["Tutorials"]:Enable()
		T["Miscellaneous"]["VehicleIndicator"]:Enable()
		T["Miscellaneous"]["ItemLevel"]:Enable()
		T["Miscellaneous"]["RaidUtilities"]:Enable()
		T["Miscellaneous"]["Alerts"]:Enable()
		T["UnitFrames"]:Enable()
		T["Tooltips"]:Enable()
		T["PetBattles"]:Enable()

		-- restore original stopwatch commands
		SlashCmdList["STOPWATCH"] = Stopwatch_Toggle
	elseif (event == "PLAYER_ENTERING_WORLD") then
		T["Miscellaneous"]["ObjectiveTracker"]:Enable()
		
		-- Temp Fix for Action MultiBarBottomRight buttons 1 to 6 on low monitor resolution
		for i = 1, 6 do
			local Button = _G["MultiBarBottomRightButton"..i]

			Button:SetAttribute("showgrid", 1)
			Button:Show()
		end
	elseif (event == "VARIABLES_LOADED") then
		T["Loading"]:Enable()
		T["GUI"]:Enable()
		
		-- welcome message
		local HexClassColor = T.RGBToHex(unpack(T.Colors.class[T.MyClass]))

		T.Print("Welcome "..HexClassColor..T.MyName.."|r! For a commands list, type /tukui")
	end
end

Loading:RegisterEvent("PLAYER_LOGIN")
Loading:RegisterEvent("VARIABLES_LOADED")
Loading:RegisterEvent("PLAYER_ENTERING_WORLD")
Loading:SetScript("OnEvent", Loading.OnEvent)

T["Loading"] = Loading
