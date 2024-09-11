local Pool = MenuPool.New()
local Politie = Pool:AddSubMenu(Wagenpark, 'Politie')
local Boa = Pool:AddSubMenu(Wagenpark, 'BOA')
local KMAR = Pool:AddSubMenu(Wagenpark, 'KMAR')
local Brandweer = Pool:AddSubMenu(Wagenpark, 'Brandweer')
local Ambulance = Pool:AddSubMenu(Wagenpark, 'Ambulance')
local Onopvallend = Pool:AddSubMenu(Wagenpark, 'Onopvallend')
local Burger = Pool:AddSubMenu(Wagenpark, 'Burger')
local Overig = Pool:AddSubMenu(Wagenpark, 'Overig')
local SettingsMenu = Pool:AddSubMenu(Wagenpark, 'Instellingen')
----
local SubMenus = {}; Items = {}
--Pool:Add(MainMenu)

local Despawnable = UIMenuCheckboxItem.New('Despawnable', AOVSM.despawnable)
    SettingsMenu:AddItem(Despawnable)
	local Replace = UIMenuCheckboxItem.New('Vervangen', AOVSM.autodelete)
    SettingsMenu:AddItem(Replace)
	local MarkOnMap = UIMenuCheckboxItem.New('Op Map Markeren', AOVSM.mapblip)
    SettingsMenu:AddItem(MarkOnMap)

    SettingsMenu.OnCheckboxChange = function(Sender, Item, Checked)
        if Item == Despawnable then
			AOVSM.despawnable = Checked
        elseif Item == Replace then
			AOVSM.autodelete = Checked
        elseif Item == MarkOnMap then
			AOVSM.mapblip = Checked
		end
    end

	Pool:RefreshIndex()


-- Actual Menu [

local IsAdmin, Model

RegisterNetEvent('AOVSM:AdminStatusChecked')
AddEventHandler('AOVSM:AdminStatusChecked', function(State) --Just Don't Edit!
	IsAdmin = State
end)


Citizen.CreateThread(function() --Controls
	AOVSM.CheckStuff()
	while true do
		Citizen.Wait(0)
        Pool:ProcessMenus()
	end
end)

-- RegisterCommand(string.format('%s', 'prior'), function()
-- 	mainMenu:Visible(false)
--     SettingsMenu:Visible(not SettingsMenu:Visible())
-- end, false)

--Politie--
RegisterNetEvent('AOVSM:GotPolitie')
AddEventHandler('AOVSM:GotPolitie', function(PolitieVoertuigen)
	for Key, Value in pairs(PolitieVoertuigen) do
		if Value.ClassPol == 'N/A' then
			PolitieVoertuigen[Key].ClassPol = GetVehicleClassFromName(GetHashKey(Value.SpawnNamePol))
		end

		local Vehicle = UIMenuItem.New(Value.DisplayNamePol, 'Modelnaam: ' .. Value.SpawnNamePol)
		if AOVSM.UseCategorization then
			if not SubMenus[Value.ClassPol] then
				SubMenus[Value.ClassPol] = Pool:AddSubMenu(Politie, Categories[Value.ClassPol] or GetLabelText('VEH_CLASS_' .. tostring(GetVehicleClassFromName(GetHashKey(Value.SpawnNamePol)))))
			end
			
			SubMenus[Value.ClassPol]:AddItem(Vehicle)
		else
			Politie:AddItem(Vehicle)
		end
		table.insert(Items, {Vehicle, Value.SpawnNamePol, Value.ClassPol})
	end

	if AOVSM.UseCategorization then
		for SubMenuIndex, SubMenu in pairs(SubMenus) do
			local SubMenuVehicles = {}
			
			for Key, Value in pairs(Items) do
				if Value[3] == SubMenuIndex then
					table.insert(SubMenuVehicles, Value)
				end
			end

			SubMenu.OnItemSelect = function(Sender, Item, Index)
				for Key, Value in pairs(SubMenuVehicles) do
					if Item == Value[1] then
						AOVSM.SpawnVehicle(Value[2])
						WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    					SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					end
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	else
		Politie.OnItemSelect = function(Sender, Item, Index)
			for Key, Value in pairs(Items) do
				if Item == Value[1] then
					AOVSM.SpawnVehicle(Value[2])
					WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	end
	-- Menupool options
	Pool:RefreshIndex()
end)

--BOA--

RegisterNetEvent('AOVSM:GotBoa')
AddEventHandler('AOVSM:GotBoa', function(BoaVoertuigen)
	for Key, Value in pairs(BoaVoertuigen) do
		if Value.ClassBoa == 'N/A' then
			BoaVoertuigen[Key].ClassBoa = GetVehicleClassFromName(GetHashKey(Value.SpawnNameBoa))
		end

		local VehicleBoa = UIMenuItem.New(Value.DisplayNameBoa, 'Modelnaam: ' .. Value.SpawnNameBoa)
		if AOVSM.UseCategorization then
			if not SubMenus[Value.ClassBoa] then
				SubMenus[Value.ClassBoa] = Pool:AddSubMenu(Boa, Categories[Value.ClassBoa] or GetLabelText('VEH_CLASS_' .. tostring(GetVehicleClassFromName(GetHashKey(Value.SpawnNameBoa)))))
			end
			
			SubMenus[Value.ClassBoa]:AddItem(VehicleBoa)
		else
			Boa:AddItem(VehicleBoa)
		end
		table.insert(Items, {VehicleBoa, Value.SpawnNameBoa, Value.ClassBoa})
	end

	if AOVSM.UseCategorization then
		for SubMenuIndex, SubMenu in pairs(SubMenus) do
			local SubMenuVehicles = {}
			
			for Key, Value in pairs(Items) do
				if Value[3] == SubMenuIndex then
					table.insert(SubMenuVehicles, Value)
				end
			end

			SubMenu.OnItemSelect = function(Sender, Item, Index)
				for Key, Value in pairs(SubMenuVehicles) do
					if Item == Value[1] then
						AOVSM.SpawnVehicle(Value[2])
						WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    					SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					end
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	else
		Boa.OnItemSelect = function(Sender, Item, Index)
			for Key, Value in pairs(Items) do
				if Item == Value[1] then
					AOVSM.SpawnVehicle(Value[2])
					WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	end
	Pool:RefreshIndex()
end)

--KMAR--

RegisterNetEvent('AOVSM:GotKM')
AddEventHandler('AOVSM:GotKM', function(KmarVoertuigen)
	for Key, Value in pairs(KmarVoertuigen) do
		if Value.ClassKmar == 'N/A' then
			KmarVoertuigen[Key].ClassKmar = GetVehicleClassFromName(GetHashKey(Value.SpawnNameKmar))
		end

		local VehicleKmar = UIMenuItem.New(Value.DisplayNameKmar, 'Modelnaam: ' .. Value.SpawnNameKmar)
		if AOVSM.UseCategorization then
			if not SubMenus[Value.ClassKmar] then
				SubMenus[Value.ClassKmar] = Pool:AddSubMenu(KMAR, Categories[Value.ClassKmar] or GetLabelText('VEH_CLASS_' .. tostring(GetVehicleClassFromName(GetHashKey(Value.SpawnNameKmar)))))
			end
			
			SubMenus[Value.ClassKmar]:AddItem(VehicleKmar)
		else
			KMAR:AddItem(VehicleKmar)
		end
		table.insert(Items, {VehicleKmar, Value.SpawnNameKmar, Value.ClassKmar})
	end

	if AOVSM.UseCategorization then
		for SubMenuIndex, SubMenu in pairs(SubMenus) do
			local SubMenuVehicles = {}
			
			for Key, Value in pairs(Items) do
				if Value[3] == SubMenuIndex then
					table.insert(SubMenuVehicles, Value)
				end
			end

			SubMenu.OnItemSelect = function(Sender, Item, Index)
				for Key, Value in pairs(SubMenuVehicles) do
					if Item == Value[1] then
						AOVSM.SpawnVehicle(Value[2])
						WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    					SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					end
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	else
		KMAR.OnItemSelect = function(Sender, Item, Index)
			for Key, Value in pairs(Items) do
				if Item == Value[1] then
					AOVSM.SpawnVehicle(Value[2])
					WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	end
	Pool:RefreshIndex()
end)

--Brandweer--

RegisterNetEvent('AOVSM:GotBrand')
AddEventHandler('AOVSM:GotBrand', function(BrandweerVoertuigen)
	for Key, Value in pairs(BrandweerVoertuigen) do
		if Value.ClassBrandweer == 'N/A' then
			BrandweerVoertuigen[Key].ClassBrandweer = GetVehicleClassFromName(GetHashKey(Value.SpawnNameBrandweer))
		end

		local VehicleBrandweer = UIMenuItem.New(Value.DisplayNameBrandweer, 'Modelnaam: ' .. Value.SpawnNameBrandweer)
		if AOVSM.UseCategorization then
			if not SubMenus[Value.ClassBrandweer] then
				SubMenus[Value.ClassBrandweer] = Pool:AddSubMenu(Brandweer, Categories[Value.ClassBrandweer] or GetLabelText('VEH_CLASS_' .. tostring(GetVehicleClassFromName(GetHashKey(Value.SpawnNameBrandweer)))))
			end
			
			SubMenus[Value.ClassBrandweer]:AddItem(VehicleBrandweer)
		else
			Brandweer:AddItem(VehicleBrandweer)
		end
		table.insert(Items, {VehicleBrandweer, Value.SpawnNameBrandweer, Value.ClassBrandweer})
	end

	if AOVSM.UseCategorization then
		for SubMenuIndex, SubMenu in pairs(SubMenus) do
			local SubMenuVehicles = {}
			
			for Key, Value in pairs(Items) do
				if Value[3] == SubMenuIndex then
					table.insert(SubMenuVehicles, Value)
				end
			end

			SubMenu.OnItemSelect = function(Sender, Item, Index)
				for Key, Value in pairs(SubMenuVehicles) do
					if Item == Value[1] then
						AOVSM.SpawnVehicle(Value[2])
						WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    					SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					end
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	else
		Brandweer.OnItemSelect = function(Sender, Item, Index)
			for Key, Value in pairs(Items) do
				if Item == Value[1] then
					AOVSM.SpawnVehicle(Value[2])
					WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	end
	Pool:RefreshIndex()
end)

--Ambulance--

RegisterNetEvent('AOVSM:GotAmbu')
AddEventHandler('AOVSM:GotAmbu', function(AmbulanceVoertuigen)
	for Key, Value in pairs(AmbulanceVoertuigen) do
		if Value.ClassAmbulance == 'N/A' then
			AmbulanceVoertuigen[Key].ClassKmar = GetVehicleClassFromName(GetHashKey(Value.SpawnNameAmbulance ))
		end

		local VehicleAmbulance  = UIMenuItem.New(Value.DisplayNameAmbulance , 'Modelnaam: ' .. Value.SpawnNameAmbulance)
		if AOVSM.UseCategorization then
			if not SubMenus[Value.ClassAmbulance] then
				SubMenus[Value.ClassAmbulance] = Pool:AddSubMenu(Ambulance, Categories[Value.ClassAmbulance] or GetLabelText('VEH_CLASS_' .. tostring(GetVehicleClassFromName(GetHashKey(Value.SpawnNameAmbulance)))))
			end
			
			SubMenus[Value.ClassAmbulance]:AddItem(VehicleAmbulance)
		else
			Ambulance:AddItem(VehicleAmbulance)
		end
		table.insert(Items, {VehicleAmbulance, Value.SpawnNameAmbulance, Value.ClassAmbulance})
	end

	if AOVSM.UseCategorization then
		for SubMenuIndex, SubMenu in pairs(SubMenus) do
			local SubMenuVehicles = {}
			
			for Key, Value in pairs(Items) do
				if Value[3] == SubMenuIndex then
					table.insert(SubMenuVehicles, Value)
				end
			end

			SubMenu.OnItemSelect = function(Sender, Item, Index)
				for Key, Value in pairs(SubMenuVehicles) do
					if Item == Value[1] then
						AOVSM.SpawnVehicle(Value[2])
						WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    					SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					end
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	else
		Ambulance.OnItemSelect = function(Sender, Item, Index)
			for Key, Value in pairs(Items) do
				if Item == Value[1] then
					AOVSM.SpawnVehicle(Value[2])
					WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	end
	Pool:RefreshIndex()
end)

--Onopvallend--

RegisterNetEvent('AOVSM:GotOnop')
AddEventHandler('AOVSM:GotOnop', function(OnopvallendVoertuigen)
	for Key, Value in pairs(OnopvallendVoertuigen) do
		if Value.ClassOnop == 'N/A' then
			OnopvallendVoertuigen[Key].ClassOnop = GetVehicleClassFromName(GetHashKey(Value.SpawnNameOnop))
		end

		local VehicleOnop  = UIMenuItem.New(Value.DisplayNameOnop , 'Modelnaam: ' .. Value.SpawnNameOnop)
		if AOVSM.UseCategorization then
			if not SubMenus[Value.ClassOnop] then
				SubMenus[Value.ClassOnop] = Pool:AddSubMenu(Onopvallend, Categories[Value.ClassOnop] or GetLabelText('VEH_CLASS_' .. tostring(GetVehicleClassFromName(GetHashKey(Value.SpawnNameOnop)))))
			end
			
			SubMenus[Value.ClassOnop]:AddItem(VehicleOnop)
		else
			Onopvallend:AddItem(VehicleOnop)
		end
		table.insert(Items, {VehicleOnop, Value.SpawnNameOnop, Value.ClassOnop})
	end

	if AOVSM.UseCategorization then
		for SubMenuIndex, SubMenu in pairs(SubMenus) do
			local SubMenuVehicles = {}
			
			for Key, Value in pairs(Items) do
				if Value[3] == SubMenuIndex then
					table.insert(SubMenuVehicles, Value)
				end
			end

			SubMenu.OnItemSelect = function(Sender, Item, Index)
				for Key, Value in pairs(SubMenuVehicles) do
					if Item == Value[1] then
						AOVSM.SpawnVehicle(Value[2])
						WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    					SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					end
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	else
		Onopvallend.OnItemSelect = function(Sender, Item, Index)
			for Key, Value in pairs(Items) do
				if Item == Value[1] then
					AOVSM.SpawnVehicle(Value[2])
					WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	end
	Pool:RefreshIndex()
end)

--Burger--

RegisterNetEvent('AOVSM:GotBurg')
AddEventHandler('AOVSM:GotBurg', function(BurgerVoertuigen)
	for Key, Value in pairs(BurgerVoertuigen) do
		if Value.ClassBurger == 'N/A' then
			BurgerVoertuigen[Key].ClassBurger = GetVehicleClassFromName(GetHashKey(Value.SpawnNameBurger))
		end

		local VehicleBurger = UIMenuItem.New(Value.DisplayNameBurger , 'Modelnaam: ' .. Value.SpawnNameBurger)
		if AOVSM.UseCategorization then
			if not SubMenus[Value.ClassBurger] then
				SubMenus[Value.ClassBurger] = Pool:AddSubMenu(Burger, Categories[Value.ClassBurger] or GetLabelText('VEH_CLASS_' .. tostring(GetVehicleClassFromName(GetHashKey(Value.SpawnNameBurger)))))
			end
			
			SubMenus[Value.ClassBurger]:AddItem(VehicleBurger)
		else
			Burger:AddItem(VehicleBurger)
		end
		table.insert(Items, {VehicleBurger, Value.SpawnNameBurger, Value.ClassBurger})
	end

	if AOVSM.UseCategorization then
		for SubMenuIndex, SubMenu in pairs(SubMenus) do
			local SubMenuVehicles = {}
			
			for Key, Value in pairs(Items) do
				if Value[3] == SubMenuIndex then
					table.insert(SubMenuVehicles, Value)
				end
			end

			SubMenu.OnItemSelect = function(Sender, Item, Index)
				for Key, Value in pairs(SubMenuVehicles) do
					if Item == Value[1] then
						AOVSM.SpawnVehicle(Value[2])
						WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    					SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					end
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	else
		Wagenpark.OnItemSelect = function(Sender, Item, Index)
			for Key, Value in pairs(Items) do
				if Item == Value[1] then
					AOVSM.SpawnVehicle(Value[2])
					WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	end
	Pool:RefreshIndex()
end)

--Overig--

RegisterNetEvent('AOVSM:GotOverig')
AddEventHandler('AOVSM:GotOverig', function(OverigVoertuigen)
	for Key, Value in pairs(OverigVoertuigen) do
		if Value.ClassOverig == 'N/A' then
			OverigVoertuigen[Key].ClassOverig = GetVehicleClassFromName(GetHashKey(Value.SpawnNameOverig))
		end

		local VehicleOverig = UIMenuItem.New(Value.DisplayNameOverig , 'Modelnaam: ' .. Value.SpawnNameOverig)
		if AOVSM.UseCategorization then
			if not SubMenus[Value.ClassOverig] then
				SubMenus[Value.ClassOverig] = Pool:AddSubMenu(Overig, Categories[Value.ClassOverig] or GetLabelText('VEH_CLASS_' .. tostring(GetVehicleClassFromName(GetHashKey(Value.SpawnNameOverig)))))
			end
			
			SubMenus[Value.ClassOverig]:AddItem(VehicleOverig)
		else
			Overig:AddItem(VehicleOverig)
		end
		table.insert(Items, {VehicleOverig, Value.SpawnNameOverig, Value.ClassOverig})
	end

	if AOVSM.UseCategorization then
		for SubMenuIndex, SubMenu in pairs(SubMenus) do
			local SubMenuVehicles = {}
			
			for Key, Value in pairs(Items) do
				if Value[3] == SubMenuIndex then
					table.insert(SubMenuVehicles, Value)
				end
			end

			SubMenu.OnItemSelect = function(Sender, Item, Index)
				for Key, Value in pairs(SubMenuVehicles) do
					if Item == Value[1] then
						AOVSM.SpawnVehicle(Value[2])
						WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    					SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					end
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	else
		Overig.OnItemSelect = function(Sender, Item, Index)
			for Key, Value in pairs(Items) do
				if Item == Value[1] then
					AOVSM.SpawnVehicle(Value[2])
					WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
    				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
				end
			end
		end
		-- Pool options
		Pool:MouseControlsEnabled(false)
		Pool:MouseEdgeEnabled(false)
		Pool:ControlDisablingEnabled(false)
	end
	Pool:RefreshIndex()
end)



-- ] Actual Menu

-- Functions [

function AOVSM.SpawnVehicle(Model)
	Model = GetHashKey(Model)
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	if IsModelValid(Model) then
		if AOVSM.autodelete then
			if IsPedInAnyVehicle(PlayerPedId(), true) then
				SetEntityAsMissionEntity(Object, 1, 1)
				SetEntityAsMissionEntity(GetVehiclePedIsIn(PlayerPedId(), false), 1, 1)
				DeleteEntity(Object)
				DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
			end
		end
		RequestModel(Model)
		while not HasModelLoaded(Model) do
			Citizen.Wait(0)
		end
		local veh = CreateVehicle(Model, x, y, z + 1, GetEntityHeading(PlayerPedId()), true, true)
		SetPedIntoVehicle(PlayerPedId(), veh, -1)
		if AOVSM.despawnable then
			SetEntityAsNoLongerNeeded(veh)
		else
			SetVehicleHasBeenOwnedByPlayer(veh, true)
		end

		if AOVSM.mapblip then
			local vehBlip = AddBlipForEntity(veh)
			SetBlipColour(vehBlip, 3)
		end
		SetVehicleModKit(veh, 0)
		SetModelAsNoLongerNeeded(Model)
	else
		SetNotificationTextEntry('STRING')
		AddTextComponentString('~r~Model bestaat niet!')
		DrawNotification(false, false)
	end
end

function AOVSM.CheckStuff()
	IsAdmin = nil
	if AOVSM.OnlyForAdmins then
		TriggerServerEvent('AOVSM:CheckAdminStatus')
		while (IsAdmin == nil) do
			Citizen.Wait(0)
		end
		if IsAdmin then
			TriggerServerEvent('AOVSM:GetPolitie')
			TriggerServerEvent('AOVSM:GetBoa')
			TriggerServerEvent('AOVSM:GetKM')
			TriggerServerEvent('AOVSM:GetBrand')
			TriggerServerEvent('AOVSM:GetAmbu')
			TriggerServerEvent('AOVSM:GetOnop')
			TriggerServerEvent('AOVSM:GetBurg')
			TriggerServerEvent('AOVSM:GetOverig')
		end
	else
		TriggerServerEvent('AOVSM:GetPolitie')
		TriggerServerEvent('AOVSM:GetBoa')
		TriggerServerEvent('AOVSM:GetKM')
		TriggerServerEvent('AOVSM:GetBrand')
		TriggerServerEvent('AOVSM:GetAmbu')
		TriggerServerEvent('AOVSM:GetOnop')
		TriggerServerEvent('AOVSM:GetBurg')
		TriggerServerEvent('AOVSM:GetOverig')
	end
end

function GetIsControlPressed(Control)
	if IsControlPressed(1, Control) or IsDisabledControlPressed(1, Control) then
		return true
	end
	return false
end

function GetIsControlJustPressed(Control)
	if IsControlJustPressed(1, Control) or IsDisabledControlJustPressed(1, Control) then
		return true
	end
	return false
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght, NoSpaces)
	AddTextEntry(GetCurrentResourceName() .. '_KeyboardHead', TextEntry)
	DisplayOnscreenKeyboard(1, GetCurrentResourceName() .. '_KeyboardHead', '', ExampleText, '', '', '', MaxStringLenght)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		if NoSpaces == true then
			drawNotification('~y~NO SPACES!')
		end
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		return result
	else
		Citizen.Wait(500)
		return nil
	end
end
	
-- ] Functions

