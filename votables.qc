//
// Votables.qc
//
// Code to handle all votes
//
// All code by J.P. Grossman unless otherwise commented
//

// global variables
string request_mapname;     // Used for requesting a new level
float request_timelimit;    // Used for requesting a new time limit
float request_overtime;		// Used for requesting a new overtime
float request_gibs;         // Used to set gib level
float request_mode;         // Used to request a new mode

//
//  S E N D  A L I A S E S
//
//  Stuffs aliases for votable commands and numbers.
//
void () votables_send_aliases =
{
	local entity temp;

	temp = self;
	self = self.owner;

	//
	// maps
	//
	// e.g.:   alias start impulse 150
	//
	stuffcmd(self, "alias w5 \"wait;wait;wait;wait;wait\"\n");
/*	local float levelnum, episode;
	local string szTemp;
	levelnum = 100;
	while (levelnum < 170)
	{
		szTemp = strings_get_mapname(levelnum - 100);
		if (szTemp != "")
		{
			episode = floor(levelnum / 10) - 10;

			stuffcmd(self, "alias ");
			stuffcmd(self, szTemp);
			stuffcmd(self, " \"impulse ");
			szTemp = ftos(190 + episode);
			stuffcmd(self, szTemp);
			stuffcmd(self, ";w5;");
			szTemp = ftos(levelnum - 100 - episode * 10);
			stuffcmd(self, szTemp);
			stuffcmd(self, "\"\n");
		}
		levelnum = levelnum + 1;
	}
*/
	// toggle autopausing
	stuffcmd(self, "alias autopause impulse 210\n");

	// toggle extended obits
	stuffcmd(self, "alias obits impulse 211\n");

	// timelimit aliases
	stuffcmd(self, "alias timeset impulse 215\n");
	stuffcmd(self, "alias otset impulse 216\n");

	// Quad, Pent, Ring aliases
	stuffcmd(self, "alias setquad impulse 222\n");
	stuffcmd(self, "alias setpent impulse 223\n");
	stuffcmd(self, "alias setring impulse 224\n");

	// gib aliases
	stuffcmd(self, "alias nogibs impulse 225\n");
	stuffcmd(self, "alias lowgibs impulse 226\n");
	stuffcmd(self, "alias highgibs impulse 227\n");

	// playmode aliases
	stuffcmd(self, "alias normal impulse 217\n");
	stuffcmd(self, "alias ffa impulse 217\n");
	stuffcmd(self, "alias practice impulse 218\n");
	stuffcmd(self, "alias match impulse 219\n");
	stuffcmd(self, "alias dual impulse 220\n");
	stuffcmd(self, "alias speedball impulse 221\n");

	// number aliases
	stuffcmd(self, "alias 0 impulse 230\n");
	stuffcmd(self, "alias 1 impulse 231\n");
	stuffcmd(self, "alias 2 impulse 232\n");
	stuffcmd(self, "alias 3 impulse 233\n");
	stuffcmd(self, "alias 4 impulse 234\n");
	stuffcmd(self, "alias 5 impulse 235\n");
	stuffcmd(self, "alias 6 impulse 236\n");
	stuffcmd(self, "alias 7 impulse 237\n");
	stuffcmd(self, "alias 8 impulse 238\n");
	stuffcmd(self, "alias 9 impulse 239\n");
	stuffcmd(self, "alias 10 impulse 240\n");
	stuffcmd(self, "alias 11 impulse 241\n");
	stuffcmd(self, "alias 12 impulse 242\n");
	stuffcmd(self, "alias 13 impulse 243\n");
	stuffcmd(self, "alias 14 impulse 244\n");
	stuffcmd(self, "alias 15 impulse 245\n");

	// send this LAST to make sure that client received all impulses
	stuffcmd(self, "alias ignorethis \"impulse 180 ; sm0\"\n"); // CRMOD - matches alias init that is used in crmods pre-4.0 and turns smooth off

	self = temp;
	remove(self);
};

//
//  C H A N G E  L E V E L
//
//  Called when a request to change level passses.  The level name is
//  stored in request_mapname.
//
void () votables_change_level =
{
	if (elohim_state & ELOHIM_MATCH_STARTED)
	return;

	utils_set_cvar("timelimit", elohim_timelimit);
	if (request_mapname == "start0")
	{
		serverflags = 0;
		changelevel("start");
	}
	else if (request_mapname == "start1")
	{
		serverflags = 15;
		changelevel("start");
	}
	else
	changelevel (request_mapname);
};

//
//  R E Q U E S T  C H A N G E  L E V E L
//
//  Called when a player requests a new level.
//
void () votables_request_change_level =
{
	local float level;
	local string newmap;

	self.use = SUB_Null;

	if (elohim_levelcount != CONTENT_EMPTY)
	{
		sprint(self, "Wait for map to initialize\n");
		return;
	}

	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change level while match is in progress.\n");
		return;
	}

	level = (self.warp_episode * 10) + (self.warp_map);//new r00k
	newmap = strings_get_mapname(level);

	//clear warp flags
	self.warp_episode=0;
	self.warp_map=0;

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_mapname = newmap;
		votables_change_level();
	}
	else if (vote_init("change level to ", newmap, votables_change_level))
	{
		request_mapname = newmap;
		vote_yes();
	}
};

//
//  I N I T  W A R P
//
//  Called to initiate the warp.  The episode is passed as a parameter.
//  The level will be entered next; votables_request_change_level will be
//  called when it is.
//
void (float episode) votables_init_warp =
{
	self.count = episode;
	self.use = votables_request_change_level;
};

//
//  P H A T T E N  P L A Y E R
//
//  Phatten up players when entering practice mode.
//
void () votables_phatten_player =
{
	self.items = IT_SHOTGUN | IT_AXE | IT_ROCKET_LAUNCHER | IT_ARMOR3 |
	IT_SUPER_SHOTGUN | IT_NAILGUN | IT_GRENADE_LAUNCHER |
	IT_LIGHTNING | IT_SUPER_NAILGUN;
	self.health = 100;
	self.armorvalue = 200;
	self.ammo_shells = 100;
	self.ammo_nails = 200;
	self.ammo_rockets = 100;
	self.ammo_cells = 100;
	self.weapon = 32;
	self.armortype = 0.8;
	self.weaponmodel = "progs/v_rock2.mdl";
	self.weaponframe = 0;
};

//
//  S E T  M O D E
//
//  Called when a request to set the mode passes.
//
void () votables_set_mode =
{
	if (elohim_state & ELOHIM_MATCH_STARTED)
	return;

	if (elohim_playmode & ELOHIM_MATCH_MODE)
	{
		if (elohim_playmode & ELOHIM_SPEEDBALL_MODE)
			elohim_playmode = elohim_playmode - (elohim_playmode & ELOHIM_SPEEDBALL_MODE);
		
		elohim_playmode = elohim_playmode - (elohim_playmode & ELOHIM_MATCH_MODE);

		// Reset teamplay to 0
		cvar_set("teamplay", "0");

		// Get rid of observers
		utils_do_players(observer_end);
	}

	// Set the default timelimit if it was not set by options
	if (!(self.style & ELOHIM_SETTING_OPTIONS) || (self.pos1_x != cvar("timelimit")))
	{
		if (request_mode == ADMIN_NORMAL_MODE)
		cvar_set("timelimit", "30");
		else if (request_mode == ADMIN_PRACTICE_MODE)
		cvar_set("timelimit", "0");
	}

	elohim_playmode = elohim_playmode - (elohim_playmode & ELOHIM_PRACTICE_MODE);

	if (request_mode == ADMIN_PRACTICE_MODE)
	{
		elohim_playmode = elohim_playmode | ELOHIM_PRACTICE_MODE;
		utils_do_players(votables_phatten_player);
	}
	else if (request_mode == ADMIN_MATCH_MODE)
	{
		elohim_playmode = elohim_playmode | ELOHIM_MATCH_MODE;
		utils_set_cvar("timelimit", elohim_timelimit);
		if (!(self.style & ELOHIM_SETTING_OPTIONS))
		cvar_set("teamplay", "2");
	}
	else if (request_mode == ADMIN_INDIVIDUAL_MODE)
	{
		elohim_playmode = elohim_playmode | ELOHIM_MATCH_MODE;
		utils_set_cvar("timelimit", elohim_timelimit);
		cvar_set("teamplay", "0");
	}
	else if (request_mode == ADMIN_SPEEDBALL_MODE)
	{
		elohim_playmode = elohim_playmode | (ELOHIM_MATCH_MODE | ELOHIM_SPEEDBALL_MODE | ELOHIM_NO_QUAD | ELOHIM_NO_PENT | ELOHIM_NO_RING);
		utils_set_cvar("timelimit", elohim_timelimit);
		if (!(self.style & ELOHIM_SETTING_OPTIONS))
			cvar_set("teamplay", "1");
	}

	local string mode;
	mode = strings_get_mode(request_mode);
	bprint("playmode set to '", mode, "'\n");
	cprint3("\"playmode set to '", mode, "'\"\n");
	utils_set_cvar("samelevel", elohim_playmode);
	changelevel(mapname);
};

//
//  R E Q U E S T  S E T  M O D E
//
//  Request to change to the mode indicated by 'newmode':
//
//      0   -   normal
//      1   -   practice
//      2   -   match
//      3   -   individual
//      4   -   speedball

void (float newmode) votables_request_set_mode =
{
	local string mode;

	mode = strings_get_mode(newmode);
	if (newmode == options_get_mode() && !(self.style & ELOHIM_SETTING_OPTIONS))
	{
		if (self == world)
		cprint3("Already in ", mode, " mode\n");
		else
		sprint(self, "Already in ", mode, " mode\n");
		return;
	}

	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		if (self == world)
		cprint("Cannot change mode while match is in progress\n");
		else
		sprint(self, "Match has started; cannot change mode\n");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_mode = newmode;
		votables_set_mode();
	}
	else if (!(elohim_playmode & ELOHIM_MODE_VOTE))
	sprint(self, "Mode voting has been disabled\n");
	else if ((newmode == 1) && (elohim_state & ELOHIM_NO_PRACTICE))
	sprint(self, "Practice mode has been disabled\n");
	else
	{
		if (vote_init("change mode to ", mode, votables_set_mode))
		{
			request_mode = newmode;
			vote_yes();
		}
	}
};

//
//  S E T  T I M E L I M I T
//
//  Called when a request to change the timelimit passes.  The new
//  timelimit is stored in the global variable request_timelimit.
//
void () votables_set_timelimit =
{
	local string temp;

	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change time limit while match is in progress.\n");
		return;
	}

	if (elohim_playmode & ELOHIM_MATCH_MODE)
	{
		elohim_timelimit = request_timelimit;
		temp = ftos(elohim_timelimit);
		bprint("Match length changed to ", temp, " minutes\n");
		cprint3("Match length changed to ", temp, " minutes\n");
		match_show_timelimit();
	}
	else
	{
		timelimit = request_timelimit * 60;
		utils_set_cvar("timelimit", request_timelimit);
		temp = ftos(request_timelimit);
		cprint3("timelimit changed to ", temp, " minutes\n");
	}
};

//
//  R E Q U E S T  S E T  T I M E L I M I T
//
//  Called when a player requests a new timelimit.
//
void (float newlimit) votables_request_set_timelimit =
{
	local string temp;

	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change time limit while match is in progress.\n");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_timelimit = newlimit;
		votables_set_timelimit();
	}
	else
	{
		if (!(elohim_playmode & ELOHIM_MATCH_MODE))
		return;
		temp = strings_ftos(newlimit);
		if (vote_init("change match length to ", temp, votables_set_timelimit))
		{
			request_timelimit = newlimit;
			vote_yes();
		}
	}
};

//
//  G E T  T I M E L I M I T
//
void () votables_get_timelimit =
{
	if (self.finaldest_z >= 1 && self.finaldest_z <= 6)
	votables_request_set_timelimit(self.finaldest_z * 5);
	else
	sprint(self, "invalid selection\n");

	self.use = SUB_Null;
};

//
//  S E L E C T  T I M E L I M I T
//
void () votables_select_timelimit =
{
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change time limit while match is in progress.\n");
		return;
	}

	sprint(self, "Select timelimit:\n");
	sprint(self, "“Ÿ µ Íéîõôåó     –Ÿ ²° Íéîõôåó\n");
	sprint(self, "”Ÿ ±° Íéîõôåó    —Ÿ ²µ Íéîõôåó\n");
	sprint(self, "•Ÿ ±µ Íéîõôåó    ˜Ÿ ³° Íéîõôåó\n");
	self.use = votables_get_timelimit;
};

//
//  S E T  O V E R T I M E
//
void () votables_set_overtime =
{
	elohim_overtime = request_overtime;

	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change overtime while match is in progress.\n");
		return;
	}

	if (elohim_overtime == -1)
	{
		bprint("Overtime set to Sudden Death\n");
		cprint("Overtime set to Sudden Death\n");
	}
	else if (elohim_overtime == 0)
	{
		bprint("Overtime disabled\n");
		cprint("Overtime disabled\n");
	}
	else
	{
		local string temp;
		local string szplural;
		temp = ftos(elohim_overtime);
		szplural = strings_szplural(elohim_overtime);
		bprint("Overtime changed to ", temp, " minute", szplural);
		cprint4("Overtime changed to ", temp, " minute", szplural);
	}

	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
	utils_set_cvar("v_kicktime", elohim_overtime);
};

//
//  R E Q U E S T  S E T  O V E R T I M E
//
void (float overtime) votables_request_set_overtime =
{
	local string temp;

	overtime = floor(overtime);

	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change overtime while match is in progress.\n");
		return;
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_overtime = overtime;
		votables_set_overtime();
	}
	else
	{
		if (!(elohim_playmode & ELOHIM_MATCH_MODE))
		return;
		if (overtime < 0)
		temp = "sudden death";
		else if (overtime == 0)
		temp = "disabled";
		else
		temp = strings_ftos(overtime);
		if (vote_init("change overtime to ", temp, votables_set_overtime))
		{
			request_overtime = overtime;
			vote_yes();
		}
	}
};

//
//  G E T  O V E R T I M E
//
void () votables_get_overtime =
{
	if (self.finaldest_z < 6)
	votables_request_set_overtime(self.finaldest_z);
	else if (self.finaldest_z == 6)
	votables_request_set_overtime(10);
	else if (self.finaldest_z == 7)
	votables_request_set_overtime(-1);
	else
	sprint(self, "invalid selection\n");

	self.use = SUB_Null;
};

//
//  S E L E C T  O V E R T I M E
//
void () votables_select_overtime =
{
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change overtime while match is in progress.\n");
		return;
	}
	sprint(self, "Select overtime:\n");
	sprint(self, "’Ÿ Äéóáâìåä      –Ÿ ´ Íéîõôåó\n");
	sprint(self, "“Ÿ ± Íéîõôå      —Ÿ µ Íéîõôåó\n");
	sprint(self, "”Ÿ ² Íéîõôåó     ˜Ÿ ±° Íéîõôåó\n");
	sprint(self, "•Ÿ ³ Íéîõôåó     ™Ÿ Óõääåî äåáôè\n");
	self.use = votables_get_overtime;
};

//
//  S E T  G I B S
//
//  Called when a request to set gibs passes.  The new setting for gibs
//  is specified by the global variable request_gibs.
//
void () votables_set_gibs =
{
	elohim_playmode = elohim_playmode -
	(elohim_playmode & (ELOHIM_NO_GIBS | ELOHIM_LOW_GIBS));
	if (request_gibs == 0)
	{
		elohim_playmode = elohim_playmode | ELOHIM_NO_GIBS;
		bprint("Gibs disabled\n");
		cprint("Gibs disabled\n");
	}
	else if (request_gibs == 1)
	{
		elohim_playmode = elohim_playmode | ELOHIM_LOW_GIBS;
		bprint("Gibs set to 'low'\n");
		cprint("\"Gibs set to 'low'\"\n");
	}
	else
	{
		bprint("Gibs set to 'high'\n");
		cprint("\"Gibs set to 'high'\"\n");
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  G I B S
//
//  Called when a player requests a new setting for gibs.
//
void (float gibs) votables_request_set_gibs =
{
	if (elohim_playmode & ELOHIM_NO_GIBS)
	{
		if (gibs == 0)
		{
			if (self == world)
			cprint("Gibs already disabled\n");
			else
			sprint(self, "Gibs already disabled\n");
			return;
		}
	}
	else if (elohim_playmode & ELOHIM_LOW_GIBS)
	{
		if (gibs == 1)
		{
			if (self == world)
			cprint("\"Gibs already set to 'low'\"\n");
			else
			sprint(self, "Gibs already set to 'low'\n");
			return;
		}
	}
	else
	{
		if (gibs == 2)
		{
			if (self == world)
			cprint("\"Gibs already set to 'high'\"\n");
			else
			sprint(self, "Gibs already set to 'high'\n");
			return;
		}
	}

	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		request_gibs = gibs;
		votables_set_gibs();
	}
	else
	{
		local string gibmode;
		if (gibs == 0)
		gibmode = "'disabled'";
		else if (gibs == 1)
		gibmode = "'low'";
		else
		gibmode = "'high'";
		if (vote_init("change gibs to ", gibmode, votables_set_gibs))
		{
			request_gibs = gibs;
			vote_yes();
		}
	}
};

//
//  D I S A B L E  I T E M
//
//  Used to disable quad/pent/ring.  Called with the item as 'self'.
//
void () votables_disable_item =
{
	self.model = string_null;
	self.solid = SOLID_NOT;
	self.nextthink = 9999999; // must be really big for quaketv
};

//
//  S E T  Q U A D
//
//  Enable/disable quad.
//
void () votables_set_quad =
{
	if (elohim_playmode & ELOHIM_NO_QUAD)
	{
		utils_do_item(SUB_regen, "item_artifact_super_damage");
		bprint("Quad enabled\n");
		cprint("Quad enabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_NO_QUAD;
	}
	else
	{
		utils_do_item(votables_disable_item, "item_artifact_super_damage");
		bprint("Quad disabled\n");
		cprint("Quad disabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_NO_QUAD;
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  Q U A D
//
//  Request to enable/disable quad.
//
void () votables_request_set_quad =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		if (elohim_state & (ELOHIM_SETQUAD_COUNT * 4))
		{
			sprint(self, "Stop fucking with the quad\n");
			return;
		}
		elohim_state = elohim_state + ELOHIM_SETQUAD_COUNT;
		votables_set_quad();
	}
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_NO_QUAD)
		newstate = "enable";
		else
		newstate = "disable";

		if (vote_init(newstate, " quad", votables_set_quad))
		vote_yes();
	}
};

//
//  S E T  P E N T
//
//  Enable/disable pentagram.
//
void () votables_set_pent =
{
	if (elohim_playmode & ELOHIM_NO_PENT)
	{
		utils_do_item(SUB_regen, "item_artifact_invulnerability");
		bprint("Pentagram enabled\n");
		cprint("Pentagram enabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_NO_PENT;
	}
	else
	{
		utils_do_item(votables_disable_item, "item_artifact_invulnerability");
		bprint("Pentagram disabled\n");
		cprint("Pentagram disabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_NO_PENT;
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  P E N T
//
//  Request to enable/disable pentagram.
//
void () votables_request_set_pent =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		if (elohim_state & (ELOHIM_SETPENT_COUNT * 4))
		{
			sprint(self, "Stop fucking with the pentagram\n");
			return;
		}
		elohim_state = elohim_state + ELOHIM_SETPENT_COUNT;
		votables_set_pent();
	}
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_NO_PENT)
		newstate = "enable";
		else
		newstate = "disable";

		if (vote_init(newstate, " pentagram", votables_set_pent))
		vote_yes();
	}
};

//
//  S E T  R I N G
//
//  Enable/disable ring of shadows.
//
void () votables_set_ring =
{
	if (elohim_playmode & ELOHIM_NO_RING)
	{
		utils_do_item(SUB_regen, "item_artifact_invisibility");
		bprint("Ring of shadows enabled\n");
		cprint("Ring of shadows enabled\n");
		elohim_playmode = elohim_playmode - ELOHIM_NO_RING;
	}
	else
	{
		utils_do_item(votables_disable_item, "item_artifact_invisibility");
		bprint("Ring of shadows disabled\n");
		cprint("Ring of shadows disabled\n");
		elohim_playmode = elohim_playmode | ELOHIM_NO_RING;
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  R E Q U E S T  S E T  R I N G
//
//  Request to enable/disable ring of shadows.
//
void () votables_request_set_ring =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	{
		if (elohim_state & (ELOHIM_SETRING_COUNT * 4))
		{
			sprint(self, "Stop fucking with the ring\n");
			return;
		}
		elohim_state = elohim_state + ELOHIM_SETRING_COUNT;
		votables_set_ring();
	}
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_NO_RING)
		newstate = "enable";
		else
		newstate = "disable";

		if (vote_init(newstate, " ring of shadows", votables_set_ring))
		vote_yes();
	}
};

//
//  S E T  O B I T S
//
//  Enable/disable extended obituaries.
//
void () votables_set_obits =
{
	utils_toggle_sflag(ELOHIM_EXTENDED_OBITS, "Extended obituaries");
};

//
//  R E Q U E S T  S E T  O B I T S
//
//  Request to enable/disable extended obituaries.
//
void () votables_request_set_obits =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	utils_toggle_sflag(ELOHIM_EXTENDED_OBITS, "Extended obituaries");
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_EXTENDED_OBITS)
		newstate = "disable";
		else
		newstate = "enable";

		if (vote_init(newstate, " extended obituaries", votables_set_obits))
		vote_yes();
	}
};

//
//  S E T  A U T O P A U S E
//
//  Enable/disable autopausing
//
void () votables_set_autopause =
{
	utils_toggle_sflag(ELOHIM_AUTO_PAUSE, "Automatic match pausing");
};

//
//  R E Q U E S T  S E T  A U T O P A U S E
//
//  Request to enable/disable autopausing
//
void () votables_request_set_autopause =
{
	// Do it right away if we're an administrator, otherwise vote
	if (self.style & ELOHIM_ADMINISTRATOR)
	utils_toggle_sflag(ELOHIM_AUTO_PAUSE, "Automatic match pausing");
	else
	{
		local string newstate;

		if (elohim_playmode & ELOHIM_AUTO_PAUSE)
		newstate = "disable";
		else
		newstate = "enable";

		if (vote_init(newstate, " automatic match pausing", votables_set_autopause))
		vote_yes();
	}
};
