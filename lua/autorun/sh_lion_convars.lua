-- replicated convars have to be created on both client and server
CreateConVar("ttt_lion_name_reveal", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt_lion_always_reveal", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
--CreateConVar("ttt_occultist_fire_damagescale", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
--CreateConVar("ttt2_occul_ignite_attacker", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_occultist_convars", function(tbl)
	tbl[ROLE_LION] = tbl[ROLE_LION] or {}

	table.insert(tbl[ROLE_LION], {cvar = "ttt_lion_name_reveal", checkbox = true, desc = "ttt_lion_name_reveal (def. 1)"})
	table.insert(tbl[ROLE_LION], {cvar = "ttt_lion_always_reveal", checkbox = true, desc = "ttt_lion_always_reveal (def. 0)"})
	--table.insert(tbl[ROLE_LION], {cvar = "ttt_occultist_respawn_time", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt_occultist_respawn_time (def. 10)"})--
end)
