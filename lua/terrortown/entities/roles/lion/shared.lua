if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_lion")
end

function ROLE:PreInitialize()
	self.color = Color(139, 034, 082, 255)
	self.abbr = "lion"
	self.surviveBonus               = 0
	self.scoreKillsMultiplier       = 1
	self.scoreTeamKillsMultiplier   = -16
	self.preventFindCredits         = true
	self.preventKillCredits         = true
	self.preventTraitorAloneCredits = true
	self.preventWin                 = false
	self.unknownTeam                = true

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
	roles.SetBaseRole(self, ROLE_LION)

	function ROLE:Initialize()
		-- Role specific language elements
		LANG.AddToLanguage("English", LION.name, "Lion")
		LANG.AddToLanguage("English", TEAM_LION, "TEAM Lion")
		LANG.AddToLanguage("English", "hilite_win_" .. TEAM_LION, "THE LION WON")
		LANG.AddToLanguage("English", "win_" .. TEAM_LION, "The Lion has won!") -- teamname
		LANG.AddToLanguage("English", "necroo_popup_" .. LION.name, [[A Traitor with a mask - That´s You! Your partners see you as their colleague, but you have a different attitude: You wanna win alone! But hurry up!: You must kill all the traitors, before they win.]])
		LANG.AddToLanguage("English", "body_found_" .. LION.abbr, "They were a Lion!")
		LANG.AddToLanguage("English", "search_role_" .. LION.abbr, "This person was a Lion!")
		LANG.AddToLanguage("English", "ev_win_" .. TEAM_LION, "The evil Lion won the round!")
		LANG.AddToLanguage("English", "target_" .. LION.name, "Lion")
		LANG.AddToLanguage("English", "ttt2_desc_" .. LION.name, [[You can only win as a lone wolf. You must be the last one standing. When the traitors win, you´ll lose. But caution: When you kill the first traitor, the other ones will see your true attitude!]])

		LANG.AddToLanguage("Deutsch", LION.name, "Löwe")
		LANG.AddToLanguage("Deutsch", TEAM_LION, "TEAM Löwe")
		LANG.AddToLanguage("Deutsch", "hilite_win_" .. TEAM_LION, "THE LION WON")
		LANG.AddToLanguage("Deutsch", "win_" .. TEAM_LION, "Der Löwe hat gewonnen!")
		LANG.AddToLanguage("Deutsch", "necroo_popup_" .. LION.name, [[Du bist ein Traitor, mit Maske. Deine Partner sehen dich als Kollege, doch hast du ein geheimes Verlangen: Du willst alleine gewinnen. Du musst dich beeilen: Du musst alle töten - auch deine T-Kollegen, bevor sie gewinnen!]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. LION.abbr, "Er war der Löwe...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. LION.abbr, "Diese Person war der Löwe!")
		LANG.AddToLanguage("Deutsch", "ev_win_" .. TEAM_LION, "Der böse Löwe hat die Runde gewonnen!")
		LANG.AddToLanguage("Deutsch", "target_" .. LION.name, "Löwe")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. LION.name, [[Du kannst nur als einsamer Wolf gewinnen. Du musst der letzte Stehende sein. Wenn die Ts gewinnen, wirst du verlieren. Aber Vorsicht: Wenn du den ersten Traitor ermordet hast, werden die anderen sehen, wer du wirklich bist!]])
	end
end