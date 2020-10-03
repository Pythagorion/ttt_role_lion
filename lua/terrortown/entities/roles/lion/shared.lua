if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_lion")
	util.AddNetworkString("LionRevealWithName")
	util.AddNetworkString("LionRevealNoName")
end

roles.InitCustomTeam(ROLE.name, {
	icon = "vgui/ttt/dynamic/roles/icon_lion",
	color = Color(139, 034, 082, 255)
})

function ROLE:PreInitialize()
	self.color = Color(139, 034, 082, 255)
	self.abbr = "lion"
	self.surviveBonus               = 0.2
	self.scoreKillsMultiplier       = 2
	self.scoreTeamKillsMultiplier   = 4
	self.unknownTeam                = true
	self.preventWin 				= true
	self.notSelectable			    = true

	self.defaultTeam                = TEAM_LION

	self.conVarData = {
		pct          = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum      = 1, -- maximum amount of roles in a round
		minPlayers   = 7, -- minimum amount of players until this role is able to get selected
		credits      = 0, -- the starting credits of a specific role
		shopFallback = SHOP_FALLBACK_TRAITOR,
		togglable    = true, -- option to toggle a role for a client if possible (F1 menu)
		random       = 33
	}
end

if CLIENT then

	function ROLE:Initialize()
		-- Role specific language elements
		LANG.AddToLanguage("English", LION.name, "Lion")
		LANG.AddToLanguage("English", TEAM_LION, "TEAM Lion")
		LANG.AddToLanguage("English", "hilite_win_" .. TEAM_LION, "THE LION WON")
		LANG.AddToLanguage("English", "win_" .. TEAM_LION, "The Lion has won!") -- teamname
		LANG.AddToLanguage("English", "info_popup_" .. LION.name, [[A Traitor with a mask - That´s You! Your partners see you as their colleague, but you have a different attitude: You wanna win alone! But hurry up!: You must kill all the traitors, before they win.]])
		LANG.AddToLanguage("English", "body_found_" .. LION.abbr, "They were a Lion!")
		LANG.AddToLanguage("English", "search_role_" .. LION.abbr, "This person was a Lion!")
		LANG.AddToLanguage("English", "ev_win_" .. TEAM_LION, "The evil Lion won the round!")
		LANG.AddToLanguage("English", "target_" .. LION.name, "Lion")
		LANG.AddToLanguage("English", "ttt2_desc_" .. LION.name, [[You can only win as a lone wolf. You must be the last one standing. When the traitors win, you´ll lose. But caution: When you kill the first traitor, the other ones will see your true attitude!]])

		LANG.AddToLanguage("Deutsch", LION.name, "Löwe")
		LANG.AddToLanguage("Deutsch", TEAM_LION, "TEAM Löwe")
		LANG.AddToLanguage("Deutsch", "hilite_win_" .. TEAM_LION, "THE LION WON")
		LANG.AddToLanguage("Deutsch", "win_" .. TEAM_LION, "Der Löwe hat gewonnen!")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. LION.name, [[Du bist ein Traitor, mit Maske. Deine Partner sehen dich als Kollege, doch hast du ein geheimes Verlangen: Du willst alleine gewinnen. Du musst dich beeilen: Du musst alle töten - auch deine T-Kollegen, bevor sie gewinnen!]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. LION.abbr, "Er war der Löwe...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. LION.abbr, "Diese Person war der Löwe!")
		LANG.AddToLanguage("Deutsch", "ev_win_" .. TEAM_LION, "Der böse Löwe hat die Runde gewonnen!")
		LANG.AddToLanguage("Deutsch", "target_" .. LION.name, "Löwe")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. LION.name, [[Du kannst nur als einsamer Wolf gewinnen. Du musst der letzte Stehende sein. Wenn die Ts gewinnen, wirst du verlieren. Aber Vorsicht: Wenn du den ersten Traitor ermordet hast, werden die anderen sehen, wer du wirklich bist!]])

		LANG.AddToLanguage("Русский", LION.name, "Лев")
		LANG.AddToLanguage("Русский", TEAM_LION, "Команда льва")
		LANG.AddToLanguage("Русский", "hilite_win_" .. TEAM_LION, "ЛЕВ ВЫИГРАЛ")
		LANG.AddToLanguage("Русский", "win_" .. TEAM_LION, "Лев победил!") -- teamname
		LANG.AddToLanguage("Русский", "info_popup_" .. LION.name, [[Предатель в маске - это вы! Ваши партнёры видят в вас своего коллегу, но у вас другое отношение: вы хотите выиграть в одиночку! Но поторопитесь! Вы должны убить всех предателей, прежде чем они победят.]])
		LANG.AddToLanguage("Русский", "body_found_" .. LION.abbr, "Он был львом!")
		LANG.AddToLanguage("Русский", "search_role_" .. LION.abbr, "Этот человек был львом!")
		LANG.AddToLanguage("Русский", "ev_win_" .. TEAM_LION, "Злой лев выиграл раунд!")
		LANG.AddToLanguage("Русский", "target_" .. LION.name, "Лев")
		LANG.AddToLanguage("Русский", "ttt2_desc_" .. LION.name, [[Вы можете победить только волком-одиночкой. Вы должны быть последним выжившим. Когда предатели победят, вы проиграете. Но осторожно: когда вы убьёте первого предателя, остальные увидят ваше истинное отношение!]])

	end
end

if SERVER then

	--The Lion is shown to the traitor as their colleague--
	hook.Add("TTT2SpecialRoleSyncing", "TTT2RoleLionMod", function(ply, tbl)
    	if not lion_killed_traitor and not lion_killed_t_no_ident then
        	if ply and not ply:HasTeam(TEAM_TRAITOR) or ply:GetBaseRoleData().unknownTeam or GetRoundState() == ROUND_POST then return end

        	local lionSelected = false

        	for lion in pairs(tbl) do
            	if lion:IsTerror() and lion:Alive() and lion:GetBaseRole() == ROLE_LION then
                	tbl[lion] = {ROLE_TRAITOR, TEAM_TRAITOR}
            
                	lionSelected = true
            	end
        	end
    	end
	end)

	--Let the Spy not spawn together with the lion--
	hook.Add("TTT2ModifySelectableRoles", "TTT2LionOrTheSpy", function(selectableRoles)
    	if not selectableRoles[LION] or not selectableRoles[SPY] then return end

    	if math.random(2) == 2 then
        	selectableRoles[LION] = nil
    	else
        	selectableRoles[SPY] = nil
    	end
	end)
else
	hook.Add("TTTScoreboardRowColorForPlayer", "TTT2LIONColorScoreboard", function(ply)
		local client = LocalPlayer()

		if client:GetBaseRole() == ROLE_LION and ply ~= client and not ply:GetForceSpec() and ply.lion_specialRole then
			return Color(255, 0, 0, 255)
		end
	end)	
end	
