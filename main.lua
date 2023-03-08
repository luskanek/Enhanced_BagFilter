local _G = getfenv(0)

local function GetNextItem()
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link then
				local _, _, id, _, _, _ = strfind(link, 'item:(%d+):(%d*):(%d*):(%d*)')
				id = tonumber(id)
				local name, _, _, _, type, _, _, _ = GetItemInfo(id)
				for _bag = 0, 4 do
					if Enhanced_BagFilters[_bag + 1] == type then
						if bag ~= _bag then
							if Enhanced_BagFilters[bag + 1] ~= Enhanced_BagFilters[_bag + 1] then
								for _slot = 1, GetContainerNumSlots(_bag) do
									local _link = GetContainerItemLink(_bag, _slot)
									if not _link then
										return bag, slot, _bag, _slot
									else
										local _, _, _id, _, _, _ = strfind(_link, 'item:(%d+):(%d*):(%d*):(%d*)')
										_id = tonumber(_id)
										local _name, _, _, _, _type, _subType, _, _ = GetItemInfo(_id)
										if type ~= _type then
											return bag, slot, _bag, _slot
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	return nil, nil, nil, nil
end

dummy = CreateFrame('Frame', nil, UIParent)
dummy:Hide()
dummy:RegisterEvent('LOOT_CLOSED')
dummy:RegisterEvent('MERCHANT_CLOSED')
dummy:RegisterEvent('TRADE_CLOSED')
dummy:SetScript("OnEvent", 
	function()
		dummy:Show()
	end
)

dummy:SetScript("OnUpdate", 
	function()
		if (this.tick or 1) > GetTime() then return else this.tick = GetTime() + 1.0 end
		local bag, slot, _bag, _slot = GetNextItem()
		if not bag and not slot then
			dummy:Hide()
			return
		end
		
		local texture, _, srcLocked = GetContainerItemInfo(bag, slot)
		local _, _, dstLocked = GetContainerItemInfo(_bag, _slot)
		
		if texture and not srcLocked and not dstLocked then
			ClearCursor()
			PickupContainerItem(bag, slot)
			PickupContainerItem(_bag, _slot)
		end
	end
)

if not Enhanced_BagFilters then 
	Enhanced_BagFilters = {
		"None", 
		"None", 
		"None",
		"None",
		"None"
	}
end

local items = {
	"Armor",
	"Weapon",
	"Consumable",
	"Trade Goods",
	"Quest"
}

function SetBagFilter(type)
	UIDropDownMenu_SetSelectedName(BagSortingMenu, type, false)
	local bag = tonumber(UIDROPDOWNMENU_MENU_VALUE)
	Enhanced_BagFilters[bag] = type
	dummy:Show()
end

BagSortingMenu = CreateFrame('Frame', 'BagSortingDropDown', UIParent, 'UIDropDownMenuTemplate')
BagSortingMenu:ClearAllPoints()
BagSortingMenu:SetPoint('CENTER', 0, 0)
BagSortingMenu:Hide()
UIDropDownMenu_Initialize(BagSortingMenu, 
	function() 
		level = level or 1
		
		local info = {}
		
		info.text = "Assign to bag:"
		info.isTitle = true
		UIDropDownMenu_AddButton(info, level)
		
		for i = 1, table.getn(items) do
			info = {}
			info.text = items[i]
			info.func = SetBagFilter
			info.arg1 = items[i]
			UIDropDownMenu_AddButton(info, level)
		end
		
		info = {}
		info.text = ""
		info.isTitle = true
		UIDropDownMenu_AddButton(info, level)
		
		info = {}
		info.text = "None"
		info.func = SetBagFilter
		info.arg1 = "None"
		UIDropDownMenu_AddButton(info, level)
	end, 'MENU'
)

ContainerFrame1PortraitButton:SetScript('OnClick', 
	function()
		ToggleDropDownMenu(1, '1', BagSortingMenu, this, 12, 20)
		UIDropDownMenu_SetSelectedName(BagSortingMenu, Enhanced_BagFilters[1], false)
	end
)

ContainerFrame2PortraitButton:SetScript('OnClick', 
	function()
		ToggleDropDownMenu(1, '2', BagSortingMenu, this, 12, 20)
		UIDropDownMenu_SetSelectedName(BagSortingMenu, Enhanced_BagFilters[2], false)
	end
)

ContainerFrame3PortraitButton:SetScript('OnClick', 
	function()
		ToggleDropDownMenu(1, '3', BagSortingMenu, this, 12, 20)
		UIDropDownMenu_SetSelectedName(BagSortingMenu, Enhanced_BagFilters[3], false)
	end
)

ContainerFrame4PortraitButton:SetScript('OnClick', 
	function()
		ToggleDropDownMenu(1, '4', BagSortingMenu, this, 12, 20)
		UIDropDownMenu_SetSelectedName(BagSortingMenu, Enhanced_BagFilters[4], false)
	end
)

ContainerFrame5PortraitButton:SetScript('OnClick', 
	function()
		ToggleDropDownMenu(1, '5', BagSortingMenu, this, 12, 20)
		UIDropDownMenu_SetSelectedName(BagSortingMenu, Enhanced_BagFilters[5], false)
	end
)