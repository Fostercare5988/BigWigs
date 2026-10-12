-- This macro only needs aura names. ClassicAPI's positional getter avoids
-- constructing a tooltip or an AuraData table for every searched buff.
if not C_UnitAuras or type(C_UnitAuras.UnitBuff) ~= "function" then
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage("BigWigs /frbuff requires ClassicAPI C_UnitAuras.UnitBuff.")
	end
	return
end

local function FR_FindBuff(obuff, unit)
	local buff=strlower(obuff);
	if ( not unit ) then
		unit ='player';
	end

	for i=1, 16 do
		local name = C_UnitAuras.UnitBuff(unit, i);
		if ( name and strfind(strlower(name), buff) ) then
			return "buff", i, name;
		elseif ( name==nil ) then
			break;
		end
	end
end

local function BuffFireResist()
	for i=1, GetNumRaidMembers() do
		if UnitExists("raidpet"..i) then
			if not FR_FindBuff("Resist Fire","raidpet"..i) and not FR_FindBuff("phase shift","raidpet"..i) then
				if CheckInteractDistance("raidpet"..i, 4) then
					TargetUnit("raidpet"..i)
					CastPetAction(3)
					return
				end
			end
		end
	end

	for i=1, GetNumRaidMembers() do
		if not FR_FindBuff("Resist Fire", "raid"..i) then
			if CheckInteractDistance("raid"..i, 4) then
				TargetUnit("raid"..i)
				CastPetAction(3)
				return
			end
		end
	end
end

SLASH_FRBUFF1 = "/frbuff"
SlashCmdList["FRBUFF"] = BuffFireResist
