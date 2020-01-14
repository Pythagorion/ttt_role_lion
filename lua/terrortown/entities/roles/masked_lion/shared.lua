if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mali")

	util.AddNetworkString("LionRevealWithName")
	util.AddNetworkString("LionRevealNoName")
end

function ROLE:PreInitialize()
	self.color = Color(209, 43, 39, 255)
	self.abbr = "mali"
	self.surviveBonus               = 0.2
	self.scoreKillsMultiplier       = 2
	self.scoreTeamKillsMultiplier   = 4
	self.unknownTeam                = true
	self.preventWin					= true

	self.defaultTeam                = TEAM_TRAITOR
	self.defaultEquipment 			= TRAITOR_EQUIPMENT

	self.conVarData = {
		pct          = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum      = 1, -- maximum amount of roles in a round
		minPlayers   = 7, -- minimum amount of players until this role is able to get selected
		credits      = 3, -- the starting credits of a specific role
		shopFallback = SHOP_FALLBACK_TRAITOR,
		togglable    = true, -- option to toggle a role for a client if possible (F1 menu)
		random       = 33
	}
end

if CLIENT then

	function ROLE:Initialize()
		roles.SetBaseRole(self, ROLE_TRAITOR)

		-- Role specific language elements
		LANG.AddToLanguage("English", self.name, "Masked Lion")
		LANG.AddToLanguage("English", "info_popup_" .. self.name, [[A Traitor with a mask - That´s You! Your partners see you as their colleague, but you have a different attitude: You wanna win alone! But hurry up!: You must kill all the traitors, before they win.]])
		LANG.AddToLanguage("English", "body_found_" .. self.abbr, "They were a masked Lion!")
		LANG.AddToLanguage("English", "search_role_" .. self.abbr, "This person was a masked Lion!")
		LANG.AddToLanguage("English", "target_" .. self.name, "Lion")
		LANG.AddToLanguage("English", "ttt2_desc_" .. self.name, [[You can only win as a lone wolf. You must be the last one standing. When the traitors win, you´ll lose. But caution: When you kill the first traitor, the other ones will see your true attitude!]])

		LANG.AddToLanguage("Deutsch", self.name, "Maskierter Löwe")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. self.name, [[Du bist ein Traitor, mit Maske. Deine Partner sehen dich als Kollege, doch hast du ein geheimes Verlangen: Du willst alleine gewinnen. Du musst dich beeilen: Du musst alle töten - auch deine T-Kollegen, bevor sie gewinnen!]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. self.abbr, "Er war der maskierte Löwe...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. self.abbr, "Diese Person war der maskierte Löwe!")
		LANG.AddToLanguage("Deutsch", "target_" .. self.name, "Löwe")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. self.name, [[Du kannst nur als einsamer Wolf gewinnen. Du musst der letzte Stehende sein. Wenn die Ts gewinnen, wirst du verlieren. Aber Vorsicht: Wenn du den ersten Traitor ermordet hast, werden die anderen sehen, wer du wirklich bist!]])
	end
end

if SERVER then
	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentItem("item_ttt_radar")
	end
	
	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:RemoveEquipmentItem("item_ttt_radar")
	end

	local function ClearMali()
		local plys = player.GetAll()
	
		for i = 1, #plys do
			local ply = plys[i]
	
			mali_data = {}
			mali_killed_traitor = false
			mali_killed_t_no_ident = false
		end
	end

	--Table with traitors must be created--
	local trplys = {}

	for _, tplys in pairs(player.GetAll()) do
    	if tplys:GetTeam() == TEAM_TRAITOR then
        	table.insert( trplys, tplys )
   		end
	end		

	--We need the masked lion´s identity--
	local MaliPly = ply

	--When the masked lion kills his first colleague, he will be revealed--
	if lion_killed_traitor then
		net.Start("LionRevealWithName")
		net.WriteEntity( MaliPly )
		net.Send( trplys )
	else
		net.Start("LionRevealNoName")
		net.Send( trplys )	
	end	

	--The Lion is shown to the traitor as their colleague--
	hook.Add("TTT2SpecialRoleSyncing", "TTT2RoleLionMod", function(ply, tbl)
        if ply and not ply:HasTeam(TEAM_TRAITOR) or ply:GetSubRoleData().unknownTeam or GetRoundState() == ROUND_POST then return end

        local lionSelected = false

        for mali in pairs(tbl) do
            if mali:IsTerror() and mali:Alive() and mali:GetSubRole() == ROLE_MASKED_LION then
                tbl[mali] = {ROLE_TRAITOR, TEAM_TRAITOR}
            
                lionSelected = true
            end
        end
	end)

	--This hook shall control the cases that take effect on the round--
	hook.Add("PlayerDeath", "TTT2MaliFunctionality", function(victim, inflictor, attacker)
		if victim:GetSubRole() == ROLE_MASKED_LION then return end

		if attacker:GetSubRole() == ROLE_MASKED_LION and victim:GetTeam() == TEAM_TRAITOR then
			if mali_name_reveal then
				mali_killed_traitor = true
			else
				mali_killed_t_no_ident = true	
			end	
		end	
	end)

	--Let the Spy not spawn together with the masked lion--
	hook.Add("TTT2ModifySelectableRoles", "TTT2LionOrTheSpy", function(selectableRoles)
    	if not selectableRoles[MASKED_LION] or not selectableRoles[SPY] then return end

    	if math.random(2) == 2 then
        	selectableRoles[MASKED_LION] = nil
    	else
        	selectableRoles[SPY] = nil
    	end
	end)
else
	net.Receive("LionRevealWithName", function()
		local MaliPly = net.ReadEntity()
		chat.AddText("Anonymous Voice: ", Color(210, 105, 030), MaliPly:Nick(), Color(060, 179, 113), " dropped his mask and shows you his true attitude. He is the ", Color(210, 105, 030), "LION", Color(060, 179, 113),"!")
		chat.PlaySound()
	end)
	
	net.Receive("LionRevealNoName", function()
		chat.AddText("Anonymous Voice: ", Color(060, 179, 113), "You´ve got a ", Color(210, 105, 030), "Lion", Color(060, 179, 113), " in your Team. WATCH OUT!: Every moment, a supposed colleague could betray you!")
		chat.PlaySound()
	end)
end	
