//
// Debug.qc
//
// Debugging routines
//

float () options_get_mode;

//
//  I N F O
//
//  General info - currently autochase scores
//
void () debug_info =
{
	local entity e;
	local string temp;
	
    sprint(self, "clients:\n");
    e = find(world, classname, "player");
    while (e)
    {
		if ((e.style & ELOHIM_CONNECTED) && !(e.style & ELOHIM_OBSERVER))
		{
			temp = ftos(e.colormap);
			sprint(self, temp, " ", e.netname, "   ");
			temp = ftos(e.crmod_chase_score);
			centerprint(self, temp, "\n");
		}
        e = find(e, classname, "player");
    }
	sprint(self, "cameras:\n");
    e = find(world, classname, "elohim_camera");
    while (e)
    {
        temp = ftos(e.crmod_chase_score);
        centerprint(self, temp, " ");
        e = find(e, classname, "elohim_camera");
    }
	sprint(self, "\n");
};

//
//  F L A G S
//
//  Dump the server flags
//
void () debug_flags =
{
	sprint(self, "Server flags:\n");
    sprint(self, "\n");

	// playmode flags
	if (elohim_playmode & ELOHIM_SAME_LEVEL)
		sprint(self, "ELOHIM_SAME_LEVEL\n");
	if (elohim_playmode & ELOHIM_MATCH_MODE)
		sprint(self, "ELOHIM_MATCH_MODE\n");
	if (elohim_playmode & ELOHIM_PRACTICE_MODE)
		sprint(self, "ELOHIM_PRACTICE_MODE\n");
	if (elohim_playmode & ELOHIM_SERVER_INITIALIZED)
		sprint(self, "ELOHIM_SERVER_INITIALIZED\n");
	if (elohim_playmode & ELOHIM_NO_GIBS)
		sprint(self, "ELOHIM_NO_GIBS\n");
	if (elohim_playmode & ELOHIM_LOW_GIBS)
		sprint(self, "ELOHIM_LOW_GIBS\n");
	if (elohim_playmode & ELOHIM_NO_QUAD)
		sprint(self, "ELOHIM_NO_QUAD\n");
	if (elohim_playmode & ELOHIM_NO_PENT)
		sprint(self, "ELOHIM_NO_PENT\n");
	if (elohim_playmode & ELOHIM_NO_RING)
		sprint(self, "ELOHIM_NO_RING\n");
	if (elohim_playmode & ELOHIM_MODE_VOTE)
		sprint(self, "ELOHIM_MODE_VOTE\n");
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
		sprint(self, "ELOHIM_DEDICATED_SERVER\n");
	if (elohim_playmode & ELOHIM_NO_SPOOGE)
		sprint(self, "ELOHIM_NO_SPOOGE\n");
//	if (elohim_playmode & CRMOD_QSMACK_ON)
//		sprint(self, "CRMOD_QSMACK_ON\n");
	if (elohim_playmode & ELOHIM_EXTENDED_OBITS)
		sprint(self, "ELOHIM_EXTENDED_OBITS\n");
	if (elohim_playmode & ELOHIM_CONSOLE_INITIALIZED)
		sprint(self, "ELOHIM_CONSOLE_INITIALIZED\n");
	if (elohim_playmode & ELOHIM_FAST_START)
		sprint(self, "ELOHIM_FAST_START\n");
	if (elohim_playmode & ELOHIM_FRESH_SPAWNS)
		sprint(self, "ELOHIM_FRESH_SPAWNS\n");
	if (elohim_playmode & ELOHIM_AUTO_PAUSE)
		sprint(self, "ELOHIM_AUTO_PAUSE\n");

    sprint(self, "\n");

	// state flags
	if (elohim_state & ELOHIM_TIMER_STARTED)
		sprint(self, "ELOHIM_TIMER_STARTED\n");
	if (elohim_state & ELOHIM_MATCH_STARTED)
		sprint(self, "ELOHIM_MATCH_STARTED\n");
	if (elohim_state & ELOHIM_MATCH_PAUSED)
		sprint(self, "ELOHIM_MATCH_PAUSED\n");
	if (elohim_state & ELOHIM_MATCH_OVER)
		sprint(self, "ELOHIM_MATCH_OVER\n");
	if (elohim_state & ELOHIM_MATCH_WAIT)
		sprint(self, "ELOHIM_MATCH_WAIT\n");
	if (elohim_state & ELOHIM_KICKING)
		sprint(self, "ELOHIM_KICKING\n");
	if (elohim_state & ELOHIM_NO_PRACTICE)
		sprint(self, "ELOHIM_NO_PRACTICE\n");
	if (elohim_state & ELOHIM_ELOSTART)
		sprint(self, "ELOHIM_ELOSTART\n");
	if (elohim_state & ELOHIM_UNPAUSING)
		sprint(self, "ELOHIM_UNPAUSING\n");
	if (elohim_state & ELOHIM_AUTO_PAUSED)
		sprint(self, "ELOHIM_AUTO_PAUSED\n");
	if (elohim_state & ELOHIM_DELAYED_AUTOSS)
		sprint(self, "ELOHIM_DELAYED_AUTOSS\n");

    sprint(self, "\n");
};

//
//  V A R S
//
//  Dumps certain elohim global variables to the console.
//
//  (Do NOT dump elohim_password)
//
void () debug_vars = 
{
	// entities
	sprint(self, "elohim_num_spawns = ");
	utils_print_float(elohim_num_spawns);	
	sprint(self, "elohim_num_starts = ");
	utils_print_float(elohim_num_starts);	
	sprint(self, "elohim_num_cameras = ");
	utils_print_float(elohim_num_cameras);	
	sprint(self, "elohim_score_count = ");
	utils_print_float(elohim_score_count);	
	sprint(self, "elohim_numteams = ");
	utils_print_float(elohim_numteams);	
	sprint(self, "elohim_sentinel.ammo_rockets = ");
	utils_print_float(elohim_sentinel.ammo_rockets);
};

//
//  C V A R  T H I N K
//
void () debug_cvar_think = 
{
	local float f;
	local string s;

	f = cvar(self.owner.netname);
	s = ftos(f);
	sprint(self.owner, self.owner.netname, " = ", s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M 1  T H I N K
//
void () debug_parm1_think = 
{
	local string s;

	s = ftos(auto_parm1);
	sprint(self.owner, "auto_parm1 changed from ", s, " to ");
	auto_parm1 = utils_stof(self.owner.netname);
	s = ftos(auto_parm1);
	centerprint(self.owner, s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M 2  T H I N K
//
void () debug_parm2_think = 
{
	local string s;

	s = ftos(auto_parm2);
	sprint(self.owner, "auto_parm2 changed from ", s, " to ");
	auto_parm2 = utils_stof(self.owner.netname);
	s = ftos(auto_parm2);
	centerprint(self.owner, s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M 3  T H I N K
//
void () debug_parm3_think = 
{
	local string s;

	s = ftos(auto_parm3);
	sprint(self.owner, "auto_parm3 changed from ", s, " to ");
	auto_parm3 = utils_stof(self.owner.netname);
	s = ftos(auto_parm3);
	centerprint(self.owner, s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M 4  T H I N K
//
void () debug_parm4_think = 
{
	local string s;

	s = ftos(auto_parm4);
	sprint(self.owner, "auto_parm4 changed from ", s, " to ");
	auto_parm4 = utils_stof(self.owner.netname);
	s = ftos(auto_parm4);
	centerprint(self.owner, s, "\n");
	stuffcmd(self.owner, "name cr4debug\n");
	remove(self);
};

//
//  P A R M S
//
void () debug_parms = 
{
	sprint(self, "auto_parm1 = ");
	utils_print_float(auto_parm1);
	sprint(self, "auto_parm2 = ");
	utils_print_float(auto_parm2);
	sprint(self, "auto_parm3 = ");
	utils_print_float(auto_parm3);
	sprint(self, "auto_parm4 = ");
	utils_print_float(auto_parm4);
};

//
//  C L I E N T  F L A G S
//
//  Dumps movetarget's flags
//
void () debug_client_flags = 
{
    if (!self.movetarget)
    {
        sprint(self, "No movetarget\n");
        return;
    }
    sprint(self, "Client flags for ", self.movetarget.netname, ":\n");
    sprint(self, "\n");
    if (self.movetarget.style & ELOHIM_NEW_CLIENT)
        sprint(self, "ELOHIM_NEW_CLIENT\n");
    if (self.movetarget.style & ELOHIM_ADMINISTRATOR)
        sprint(self, "ELOHIM_ADMINISTRATOR\n");
   	if (self.movetarget.style & CRMOD_DETECTING_QSMACK)	// CRMOD was SMOOTH
		sprint(self, "CRMOD_DETECTING_QSMACK\n");					// CRMOD was SMOOTH
	if (self.movetarget.style & ELOHIM_POP_FORWARD)
        sprint(self, "ELOHIM_POP_FORWARD\n");
    if (self.movetarget.style & ELOHIM_READY)
        sprint(self, "ELOHIM_READY\n");
    if (self.movetarget.style & ELOHIM_YES)
        sprint(self, "ELOHIM_YES\n");
    if (self.movetarget.style & ELOHIM_HEADS_UP)
        sprint(self, "ELOHIM_HEADS_UP\n");
    if (self.movetarget.style & ELOHIM_SETTING_OPTIONS)
        sprint(self, "ELOHIM_SETTING_OPTIONS\n");
    if (self.movetarget.style & ELOHIM_MOTD)
        sprint(self, "ELOHIM_MOTD\n");
    if (self.movetarget.style & ELOHIM_OK_TO_SHOOT)
        sprint(self, "ELOHIM_OK_TO_SHOOT\n");
    if (self.movetarget.style & ELOHIM_KICK_CONFIRM)
        sprint(self, "ELOHIM_KICK_CONFIRM\n");
    if (self.movetarget.style & ELOHIM_CONFIRM_LEAVE)
        sprint(self, "ELOHIM_CONFIRM_LEAVE\n");
    if (self.movetarget.style & ELOHIM_CONNECTED)
        sprint(self, "ELOHIM_CONNECTED\n");
    if (self.movetarget.style & ELOHIM_FOUND_BINDINGS)
        sprint(self, "ELOHIM_FOUND_BINDINGS\n");
	if (self.movetarget.style & CRMOD_SMART_WEAPON)
		sprint(self, "CRMOD_SMART_WEAPON\n");
    if (self.movetarget.style & ELOHIM_OBSERVER)
        sprint(self, "ELOHIM_OBSERVER\n");
    if (self.movetarget.style & CRMOD_QSMACK)
        sprint(self, "CRMOD_QSMACK\n");
    if (self.movetarget.style & ELOHIM_SCOREBOARD)
        sprint(self, "ELOHIM_SCOREBOARD\n");
    if (self.movetarget.style & ELOHIM_NO_POST_THINK)
        sprint(self, "ELOHIM_NO_POST_THINK\n");
    if (self.movetarget.style & ELOHIM_WINQUAKE)
        sprint(self, "ELOHIM_WINQUAKE\n");
    if (self.movetarget.style & ELOHIM_GLQUAKE)
        sprint(self, "ELOHIM_GLQUAKE\n");
    if (self.movetarget.style & ELOHIM_AUTOSTATS)
        sprint(self, "ELOHIM_AUTOSTATS\n");
    sprint(self, "\n");

    if (self.movetarget.oflags & OBSERVER_WALK)
        sprint(self, "OBSERVER_WALK\n");
    if (self.movetarget.oflags & OBSERVER_FLY)
        sprint(self, "OBSERVER_FLY\n");
    if (self.movetarget.oflags & OBSERVER_CHASE)
        sprint(self, "OBSERVER_CHASE\n");
    if (self.movetarget.oflags & OBSERVER_DEMO)
        sprint(self, "OBSERVER_DEMO\n");
    if (self.movetarget.oflags & OBSERVER_CAMERA)
    	sprint(self, "OBSERVER_CAMERA\n");
	if (self.movetarget.oflags & OBSERVER_AUTO)
		sprint(self, "OBSERVER_AUTO\n");
	if (self.movetarget.oflags & OBSERVER_TOURNEY)
		sprint(self, "OBSERVER_TOURNEY\n");
	if (self.movetarget.oflags & OBSERVER_GO_AUTO)
		sprint(self, "OBSERVER_GO_AUTO\n");
	if (self.movetarget.oflags & OBSERVER_COMMENTARY)
		sprint(self, "OBSERVER_COMMENTARY\n");
    sprint(self, "\n");
};

//
//  G E T  M O V E T A R G E T
//
void () debug_get_movetarget = 
{
	self.use = SUB_Null;

	other = self.movetarget;
	self.movetarget = find(world, classname, "player");
	while (self.movetarget)
	{
		if (self.movetarget.colormap == self.finaldest_z)
		{
			sprint(self, "Debugging ", self.movetarget.netname, "\n");
			return;	
		}
		self.movetarget = find(self.movetarget, classname, "player");
	}
	sprint(self, "Not found\n");
	self.movetarget = other;
};

//
//  H E L P
//
//  Print out debug commands
//
void () debug_help =
{
	sprint(self, "Debug commands:\n");
	sprint(self, " dbinfo     - General info\n");
	sprint(self, " dbflags    - Server flags\n");
	sprint(self, " dbvars     - Elohim global variables\n");
	sprint(self, " dbcvar     - Console variable\n");
	sprint(self, " dbclient   - Choose movetarget\n");
	sprint(self, " dbcflags   - View movetarget flags\n");
	sprint(self, " dbparm1-4  - change auto_parm1-4\n");
	sprint(self, " dbparms    - view auto_parms\n");
	sprint(self, " dbplayers  - list players\n");
	sprint(self, " dbteams    - list teams\n");
	sprint(self, " dbsettings - list server settings\n");
    sprint(self, " dbents     - show entity information\n");
	sprint(self, " dbwingl    - who is using dos/win/gl\n");
};

//
//  P L A Y E R S
//
void () debug_players = 
{
	local entity player;

	player = elohim_sentinel.next_player;
	while (player)
	{
		centerprint(self, player.netname, "\n");
		player = player.next_player;
	}
};

//
//  T E A M S
//
void () debug_teams = 
{
	local entity pteam;
	local entity player;
	local float n;

	if (!(elohim_playmode && ELOHIM_MATCH_MODE) || !teamplay)
	{
		sprint(self, "Valid in match mode only\n");
		return;
	}

	pteam = elohim_sentinel.next_team;
	while (pteam)
	{
		centerprint(self, pteam.mdl, " - rockets = ");
		utils_print_float(pteam.ammo_rockets);
		n = pteam.count;
		player = pteam.next_player;
		while(n)
		{
			sprint(self, "    ", player.netname, "\n");
			player = player.next_player;
			n = n - 1;
		}
		pteam = pteam.next_team;
	}
};

//
//  O N O F F
//
void (float val) debug_onoff = 
{
	if (val)
		sprint(self, "on\n");
	else
		sprint(self, "off\n");
};

//
//  S H O W  C V A R
//
void (string varname) debug_show_cvar = 
{
	local float temp;

	temp = cvar(varname);
	centerprint(self, varname, " = ");
	utils_print_float(temp);
};

//
//  S E T T I N G S
//
void () debug_settings = 
{
	local float temp;
	local string sz;

    temp = options_get_mode();
    sz = strings_get_mode(temp);
    centerprint(self, sz, " mode\n");

	debug_show_cvar("timelimit");
	debug_show_cvar("fraglimit");
	debug_show_cvar("teamplay");
	debug_show_cvar("deathmatch");
	debug_show_cvar("pausable");
	temp = cvar("sys_ticrate");
	sprint(self, "sys_ticrate = ");
	utils_print_floatn(temp, 3);

	sprint(self, "overtime: ");
	if (elohim_overtime == -1)
		sprint(self, "sudden death\n");
	else if (elohim_overtime == 0)
		sprint(self, "disabled\n");
	else 
	{
		sz = ftos(elohim_overtime);
		sprint(self, sz);
		sz = strings_szplural(elohim_overtime);
		centerprint(self, " minute", sz);
	}

	sz = ftos(elohim_maxteams);
	sprint(self, "maxteams: ", sz, "\n");

	sprint(self, "gibs: ");
	if (elohim_playmode & ELOHIM_NO_GIBS)
		sprint(self, "off\n");
	else if (elohim_playmode & ELOHIM_LOW_GIBS)
		sprint(self, "low\n");
	else
		sprint(self, "high\n");

	sprint(self, "safe practice: ");
	debug_onoff(elohim_playmode & ELOHIM_NO_SPOOGE);

	sprint(self, "quad: ");
	debug_onoff(ELOHIM_NO_QUAD - (elohim_playmode & ELOHIM_NO_QUAD));
	sprint(self, "pentagram: ");
	debug_onoff(ELOHIM_NO_PENT - (elohim_playmode & ELOHIM_NO_PENT));
	sprint(self, "ring: ");
	debug_onoff(ELOHIM_NO_RING - (elohim_playmode & ELOHIM_NO_RING));

	sprint(self, "mode voting: ");
	debug_onoff(elohim_playmode & ELOHIM_MODE_VOTE);
	sprint(self, "extended obituaries: ");
	debug_onoff(elohim_playmode & ELOHIM_EXTENDED_OBITS);
	sprint(self, "fast match starts: ");
	debug_onoff(elohim_playmode & ELOHIM_FAST_START);
	sprint(self, "fresh spawns: ");
	debug_onoff(elohim_playmode & ELOHIM_FRESH_SPAWNS);
};

//
//  E N T I T I E S
//
void () debug_entities = 
{
   local entity e;
   local float num;

   e = nextent(world);
   sprint(self,"  0 \"",e.classname,"\"\n");
   num = 1;
   while (e) 
   {
      utils_print_int3(num);
      num = num + 1;
      sprint(self," \"",e.classname,"\"\n");
      e = nextent(e);
   }
};

//
//  W I N G L
//
void () debug_wingl = 
{
	local entity e;

	sprint(self, "а╤їсыха╓хЄєщяюа№а╬сэх\n");
	sprint(self, "нннннннннннннннлнннннннннннннннн\n");

	e = find(world, classname, "player");
	while (e)
	{
		if (e.style & ELOHIM_CONNECTED)
		{
			if (e.style & ELOHIM_WINQUAKE)
			{
				if (e.style & ELOHIM_GLQUAKE)
					sprint(self, "   ???         № ", e.netname, "\n");
				else
					sprint(self, "   WinQuake    № ", e.netname, "\n");
			}
			else if (e.style & ELOHIM_GLQUAKE)
				sprint(self, "   GlQuake     № ", e.netname, "\n");
			else
				sprint(self, "   DosQuake    № ", e.netname, "\n");
		}
		e = find(e, classname, "player");
	}
};

//
//  L O A D  A L I A S E S
//
void () debug_load_aliases = 
{
	sprint(self, "Loading debug binds...\n");

	stuffcmd(self, "alias dbbinds echo debug binds already loaded\n");
	stuffcmd(self, "alias dbinfo impulse 40\n"); 
	stuffcmd(self, "alias dbflags impulse 41\n");
	stuffcmd(self, "alias dbvars impulse 42\n"); 
	stuffcmd(self, "alias dbcvar impulse 43\n"); 
	stuffcmd(self, "alias dbclient impulse 44\n");
	stuffcmd(self, "alias dbcflags impulse 45\n");
	stuffcmd(self, "alias dbparm1 impulse 46\n");
	stuffcmd(self, "alias dbparm2 impulse 47\n");
	stuffcmd(self, "alias dbparm3 impulse 48\n");
	stuffcmd(self, "alias dbparm4 impulse 49\n");
	stuffcmd(self, "alias dbparms impulse 50\n");
	stuffcmd(self, "alias dbplayers impulse 51\n");
	stuffcmd(self, "alias dbteams impulse 52\n");
	stuffcmd(self, "alias dbsettings impulse 53\n");
    stuffcmd(self, "alias dbents impulse 54\n");
	stuffcmd(self, "alias dbwingl impulse 55\n");
	stuffcmd(self, "alias dbhelp impulse 59\n");
};

float debug_sound_number;

//
//  D E B U G  S O U N D
//
void () debug_sound = 
{
	sprint(self, "Sound number ");
	utils_print_float(debug_sound_number);
	utils_sound(self, debug_sound_number);
	debug_sound_number = debug_sound_number + 1;
};

//
//  I M P U L S E
//
void () debug_impulse = 
{
    if (!(self.style & ELOHIM_ADMINISTRATOR) && (self.netname != "cr4debug"))
        return;

	if (self.impulse == 40)
		debug_info();
	else if (self.impulse == 41)
		debug_flags();
	else if (self.impulse == 42)
		debug_vars();
	else if (self.impulse == 43)
		utils_make_scheduled_event(debug_cvar_think, 0.5);
	else if (self.impulse == 44)
	{
		sprint(self, "Enter client number:\n");
		self.use = debug_get_movetarget;
	}
	else if (self.impulse == 45)
		debug_client_flags();
	else if (self.impulse == 46)
		utils_make_scheduled_event(debug_parm1_think, 0.5);
	else if (self.impulse == 47)
		utils_make_scheduled_event(debug_parm2_think, 0.5);
	else if (self.impulse == 48)
		utils_make_scheduled_event(debug_parm3_think, 0.5);
	else if (self.impulse == 49)
		utils_make_scheduled_event(debug_parm4_think, 0.5);
	else if (self.impulse == 50)
		debug_parms();
	else if (self.impulse == 51)
		debug_players();
	else if (self.impulse == 52)
		debug_teams();
	else if (self.impulse == 53)
		debug_settings();
	else if (self.impulse == 54)
		debug_entities();
	else if (self.impulse == 55)
		debug_wingl();
	//else if (self.impulse == 56)
	//	debug_sound();
	else if (self.impulse == 58)
		debug_load_aliases();
	else if (self.impulse == 59)
		debug_help();
};

