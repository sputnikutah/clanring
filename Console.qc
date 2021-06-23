//
// Console.qc
//
// This file contains code to implement server console directives.
//
// All code by J.P. Grossman unless otherwise commented.
//

string (void () function) fnstrings_function;

// constants
float CONSOLE_ENT_YAW = 1;
float CONSOLE_ENT_PITCH = 2;
float CONSOLE_ENT_ROLL = 4;

// global variables
vector console_origin;

//
//  S E T  A L I A S E S
//
//  Called once when the server is initialized.
//
void () console_set_aliases =
{
    // set local aliases (server console commands)

	// immediate mode commands
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
	{
		localcmd("alias sping temp1 1\n");
		localcmd("alias time temp1 2\n");
		localcmd("alias s temp1 3\n");
		localcmd("alias debug temp1 4\n");
		localcmd("alias score temp1 5\n");
		localcmd("alias ghostlist temp1 6\n");
		localcmd("alias killstats temp1 7\n");
		localcmd("alias efficiency temp1 8\n");
		localcmd("alias eff temp1 8\n");
		localcmd("alias stats temp1 9\n");
		localcmd("alias commands temp1 10\n");
		localcmd("alias vinfo temp1 11\n");
		localcmd("alias normal temp1 12\n");
		localcmd("alias ffa temp1 12\n");
		localcmd("alias practice temp1 13\n");
		localcmd("alias match temp1 14\n");
		localcmd("alias individual temp1 15\n");
		localcmd("alias quadstats temp1 16\n");
		localcmd("alias badstats temp1 18\n");
	}
	localcmd("alias settings temp1 17\n");
	
	// config file commands
	localcmd("alias safepracticeon \"temp1 20;wait\"\n");
	localcmd("alias safepracticeoff \"temp1 21;wait\"\n");
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
	{
		localcmd("alias nogibs \"temp1 22;wait\"\n");
		localcmd("alias lowgibs \"temp1 23;wait\"\n");
		localcmd("alias highgibs \"temp1 24;wait\"\n");
	}
	localcmd("alias quadon \"temp1 25;wait\"\n");
	localcmd("alias quadoff \"temp1 26;wait\"\n");
	localcmd("alias penton \"temp1 27;wait\"\n");
	localcmd("alias pentoff \"temp1 28;wait\"\n");
	localcmd("alias ringon \"temp1 29;wait\"\n");
	localcmd("alias ringoff \"temp1 30;wait\"\n");
	localcmd("alias modevoteon \"temp1 31;wait\"\n");
	localcmd("alias modevoteoff \"temp1 32;wait\"\n");
	localcmd("alias obitson \"temp1 33;wait\"\n");
	localcmd("alias obitsoff \"temp1 34;wait\"\n");
	localcmd("alias setpassword \"temp1 35;wait\"\n");//R00k changed to 'setpassword, as 'setpass' is a reserved FTE command
	localcmd("alias setovertime \"temp1 36;wait\"\n");
	localcmd("alias maxteams \"temp1 37;wait\"\n");
	localcmd("alias faststarton \"temp1 38;wait\"\n");
	localcmd("alias faststartoff \"temp1 39;wait\"\n");
	localcmd("alias freshspawnson \"temp1 40;wait\"\n");
	localcmd("alias freshspawnsoff \"temp1 41;wait\"\n");
	localcmd("alias nopractice \"temp1 42;wait\"\n");
	localcmd("alias autopauseon \"temp1 43;wait\"\n");
	localcmd("alias autopauseoff \"temp1 44;wait\"\n");

	// entity file commands
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
	{
		localcmd("alias newspawn \"temp1 50;wait\"\n");
		localcmd("alias newstart \"temp1 51;wait\"\n");
		localcmd("alias killspawn \"temp1 52;wait\"\n");
		localcmd("alias makecam \"temp1 53;wait\"\n");
		localcmd("alias killitem \"temp1 54;wait\"\n");
		localcmd("alias makeitem \"temp1 55;wait\"\n");
		localcmd("alias changeitem \"temp1 56;wait\"\n");
	}

	// control commands
	localcmd("alias [init] \"temp1 60;wait\"\n");
	localcmd("alias [normal] \"temp1 61;wait\"\n");
	localcmd("alias [practice] \"temp1 62;wait\"\n");
	localcmd("alias [match] \"temp1 63;wait\"\n");
	localcmd("alias [individual] \"temp1 64;wait\"\n");
	localcmd("alias [done] \"temp1 65;wait\"\n");

	// undocumented debug commands
    localcmd("alias debugclient temp1 70\n");
    localcmd("alias debugoff temp1 71\n");
    localcmd("alias stuffimpulse temp1 72\n");
    localcmd("alias stuffcolor temp1 73\n");
    localcmd("alias dbcflags temp1 74\n");
	localcmd("alias dbsflags temp1 75\n");
	localcmd("alias dbcinfo temp1 76\n");
	localcmd("alias dbhelp temp1 77\n");

    //
    // create map aliases - used for reading levels.cfg
    //
    // e.g.:  alias start "temp1 100;wait"
    //
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
	{
		local float temp;
		local string szTemp;
		temp = 100;
		while (temp < 170)
		{
			szTemp = strings_get_mapname(temp - 100);
			if (szTemp != "")
			{
				localcmd3("alias ", szTemp, " \"temp1 ");
				szTemp = ftos(temp);
				localcmd2(szTemp, ";wait\"\n");
			}
			temp = temp + 1;
		}
	}
};

//
//  P I N G  T H I N K
//
//  Two seconds after console_ping is called, console_ping_think gets
//  called to see what everyone's ping turned out to be and display this
//  on the console.
//
void () console_ping_think =
{
    local entity client;
    local string temp;
    local float ping;

    cprint("\n");
    cprint("client ping times:\n");
    client = find(world, classname, "player");
    while (client)
    {
        if (client.style & ELOHIM_CONNECTED)
        {
            if (client.finaldest_y > self.finaldest_x)
                ping = floor(1000 * (client.finaldest_y - self.finaldest_x));
            else
                ping = 2000;
            temp = ftos(ping);
            cprint5("\"   ", temp, " ", client.netname, "\"\n");
        }
        client = find(client, classname, "player");
    }
    cprint("\n");

	remove(self);
};

//
//  P I N G
//
//  This is a simple attempt at a manual ping that can be executed
//  from the server console (so that you can ping players without
//  actually joining the game).  It works by stuffing "impulse 38" into
//  everyone's console and seeing how long it takes for the impulse to
//  get back.
//
void () console_ping =
{
    local entity client;
    local entity ping;

    WriteByte(MSG_BROADCAST, SVC_STUFFCMD);
    WriteString(MSG_BROADCAST, "impulse 38\n");  // CRMOD was 103

    ping = spawn();
    ping.classname = "elohim_ping";
    ping.owner = world;
    ping.nextthink = time + 2;
    ping.think = console_ping_think;
    ping.finaldest_x = time;
};

//
//  S H O W  T I M E
//
//  Show the elapsed time on the server console.
//
void () console_show_time = 
{
    local float h, m, s, t;
    local string temp;

    h = floor(time / 3600);
    t = time - h * 3600;
    m = floor(t / 60);
    t = t - m * 60;
    s = rint(t);

    cprint("\"time = ");
    if (h > 0)
    {
        temp = ftos(h);
        localcmd2(temp, ":");
        if (m < 10)
            localcmd("0");
    }
    temp = ftos(m);
    localcmd2(temp, ":");
    if (s < 10)
        localcmd("0");
    temp = ftos(s);
    localcmd2(temp, "\"\n");
};

//
//  S H O W  S T A T U S
//
//  Show the elapsed time and status on the server console.
//
void () console_show_status = 
{
    local float mode;
    local string szmode;

    cprint("\n");                    
    mode = options_get_mode();
    szmode = strings_get_mode(mode);
    cprint2(szmode, " mode\n");
    console_show_time();
    localcmd("status;echo\n");
};

//
//  S H O W  D E B U G  I N F O
//
//  Used for development.  Similar to elohim_debug_info, but prints to the
//  server console.
//
void () console_show_debug_info =
{
    local entity e;

    cprint("clients:\n");
    e = find(world, classname, "player");
    while (e)
    {
        local string temp;
        temp = ftos(e.colormap);
        if (e.style & ELOHIM_CONNECTED)
            cprint4(temp, " \"", e.netname, "\" - Connected\n");
        else
            cprint4(temp, " \"", e.netname, "\" - Disconnected\n");
        e = find(e, classname, "player");
    }
};

//
//  S H O W  S C O R E
//
//  Print the time remaining and the score.
//
void () console_show_score =
{
    local float team1, team2;
	local string score;
    local string temp;

	if (!(elohim_playmode & ELOHIM_MATCH_MODE))
	{
		cprint("Command valid in match mode only\n");
		return;
	}

 	if (!(elohim_state & (ELOHIM_MATCH_STARTED | ELOHIM_MATCH_OVER)))
	{
		if (elohim_state & ELOHIM_TIMER_STARTED)
		{
			local string s, pl;
			s = ftos(elohim_match_timer.count);
			pl = strings_szplural(elohim_match_timer.count);
			cprint4("Match begins in ", s, " second", pl);
		}
		else
			cprint3("Waiting for ", elohim_szteam, "s\n");
        return;
	}

    cprint("\n");
    if (elohim_state & ELOHIM_MATCH_OVER)
        cprint("Match over\n");
    else if (elohim_match_timer.lip < 0)
		cprint("Sudden death overtime\n");
	else
    {
        temp = ftos(elohim_match_timer.lip);
        cprint3("\"Time remaining:  ", temp, ":");
        temp = ftos(elohim_match_timer.count);
        if (elohim_match_timer.count < 10)
            localcmd("0");
        localcmd2(temp, "\"\n");
    }

	if (elohim_first_place != elohim_sentinel)
	{
		score = ftos(elohim_first_place.frags);
		temp = strings_szplural(elohim_first_place.frags);
		cprint7("\"", elohim_szthe, elohim_first_place.netname, "\" has ", score, " frag", temp);
	}
	if (elohim_second_place != elohim_sentinel)
	{
		score = ftos(elohim_second_place.frags);
		temp = strings_szplural(elohim_second_place.frags);
		cprint7("\"", elohim_szthe, elohim_second_place.netname, "\" has ", score, " frag", temp);
	}
    cprint("\n");
};

//
//  L I S T  G H O S T S
//
void () console_list_ghosts =
{
    local entity e;
    e = find(world, classname, "elohim_ghost");
    if (!e)
    {
        cprint("There are no ghosts\n");
        return;
    }
    cprint("\n");
	if (teamplay)
		cprint("\" code |    team    | frags |      name\"\n");
	else
		cprint("\" code |   colour   | frags |      name\"\n");
    cprint("------+------------+-------+-----------------\n");
    while (e)
    {
        local string num, szTeam, pad;
        local float frag;
        num = ftos(e.count);
        cprint3("\"  ", num, "  | ");
    
        szTeam = strings_get_teamname2(e.height);
        if (e.owner.owner == e)
            frag = e.owner.frags;
        else
            frag = e.frags;
        if (frag < -99)
            pad = " | ";
        else if (frag < -9)
            pad = " |  ";
        else if (frag < 0)
            pad = " |   ";
        else if (frag < 10)
            pad = " |    ";
        else if (frag < 100)
            pad = " |   ";
        else
            pad = " |  ";
        num = ftos(frag);
        if (e.owner.owner == e)
            localcmd6(szTeam, pad, num, "  | ", e.owner.netname, "\"\n");
        else
            localcmd4(szTeam, pad, num, "  | Disconnected\"\n");
    
        e = find(e, classname, "elohim_ghost");
    }
    cprint("\n");
};

//
//  S H O W  K I L L S T A T S
//
void () console_show_killstats =
{
    local entity player;

    cprint("\n");                    
    cprint("\" frags | enemies | self | teammates | killed |      name\"\n");
    cprint("-------+---------+------+-----------+--------+-----------------\n");

	player = elohim_sentinel.next_player;
    while (player)
    {
        cprint("\"  ");
        utils_cprint_int3(player.frags);
        localcmd("  |   ");
        utils_cprint_int3(player.frags + player.mangle_x + player.mangle_y);
        localcmd("   | ");
        utils_cprint_int3(player.mangle_x);
        localcmd("  |    ");
        utils_cprint_int3(player.mangle_y);
        localcmd("    |  ");
        utils_cprint_int3(player.mangle_z);
        localcmd3("   | ", player.netname, "\"\n");
        player = player.next_player;
    }
    cprint("\n");
};

//
//  P R I N T  P E R C E N T 4
//
//  Helper function for console_show_efficiency.  Prints the percentage
//  100 * (frac / tot) as a 4 character integer, or N/A if tot = 0.
//
void (float frac, float tot) console_print_percent4 =
{
    if (tot)
    {
        local float n;
        local string temp;

        n = floor(100 * frac / tot);
        if (n < 100)
            localcmd(" ");
        if (n < 10)
            localcmd(" ");
        temp = ftos(n);
        localcmd2(temp, "%");
    }
    else
        localcmd("N/A ");
};


//
// CRMOD
//  S H O W  Q U A D S T A T S
//		by Paul Baker
//
void () console_show_quadstats =
{
	local entity player, pteam;
	local float useteams;
	local string teamname;

	if ((elohim_state & ELOHIM_MATCH_STARTED) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;

	cprint("\n");
	cprint("\" quads | efficiency | enemy | self  | teammates |      name\"\n");
	cprint  ("-------+------------+-------+-------+-----------+-----------------\n");
	
	player = elohim_sentinel.next_player;
	pteam = player.next_team;
	
    while (player)
    {
        cprint("\"  ");
        utils_cprint_int3(player.crmod_qdwep_z);
        localcmd("  |    ");
        console_print_percent4(player.crmod_qdwep_x, player.crmod_qdwep_y);
        localcmd("    |  ");
        utils_cprint_int3(player.crmod_qdkill_x);
        localcmd("  |  ");
        utils_cprint_int3(player.crmod_qdkill_z);
        localcmd("  |    ");
        utils_cprint_int3(player.crmod_qdkill_y);
        localcmd3("    | ", player.netname, "\"\n");
        player = player.next_player;
		if (useteams && (player.next_team != pteam))
		{
			cprint("\" [");
			utils_cprint_int3(pteam.crmod_qdwep_z);
			localcmd3("] |            |       |       |           | ", pteam.netname, "\"\n");
			pteam = player.next_team;
		}
    }
    cprint("\n");
};

//
//  S H O W  B A D S T A T S
//
void () console_show_badstats =
{
    local entity player;
	local float tot_enemy, tot_done;

	if (!(elohim_playmode & ELOHIM_MATCH_MODE) || !teamplay)
	{
		cprint("badstats valid in match mode only\n");
		return;
	}

    cprint("\n");
    cprint("\" paks | self | team |      name\"\n");
    cprint("\"------+------+------+----------------\"\n");

    player = elohim_sentinel.next_player;
    while (player)
    {
        tot_enemy = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
		tot_done = tot_enemy + player.crmod_badstats_y + player.crmod_badstats_z;
        cprint("\"  ");
        utils_cprint_int3(player.crmod_badstats_x);
        localcmd(" | ");
		console_print_percent4(player.crmod_badstats_y, tot_done);
        localcmd(" | ");
		console_print_percent4(player.crmod_badstats_z, tot_done);
        localcmd(" | ");
        localcmd2(player.netname, "\"\n");
        player = player.next_player;
    }
};

//
//  S H O W  E F F I C I E N C Y
//
void () console_show_efficiency =
{
    local entity player;
    local float tot_fired, tot_done;

    cprint("\n");
    cprint("\" bullets | nails | rockets | lightning | total |      name\"\n");
    cprint("---------+-------+---------+-----------+-------+-----------------\n");

    player = elohim_sentinel.next_player;
    while (player)
    {
        cprint("\"   ");
        console_print_percent4(player.dest2_x, player.dest1_x);
        localcmd("  |  ");
        console_print_percent4(player.dest2_y, player.dest1_y);
        localcmd(" |   ");
        console_print_percent4(player.dest_y, player.dest_x);
        localcmd("  |    ");
        console_print_percent4(player.dest2_z, player.dest1_z);
        localcmd("   |  ");

        tot_fired = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
        tot_done = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
        console_print_percent4(tot_done, tot_fired);
        localcmd3(" | ", player.netname, "\"\n");
        player = player.next_player;
    }
    cprint("\n");
};

//
//  S H O W  S T A T S
//
//  Summary: show kill and weapon efficiency for each player.
//
void () console_show_stats =
{
    local entity player;
    local float wfrac, wtot, kfrac, ktot, useteams;
    local string teamname;

	if ((elohim_state & ELOHIM_MATCH_STARTED) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;

    cprint("\n");
    if (useteams)
    {
        cprint("\"    team    | kill | weapon |      name\"\n");
        cprint("------------+------+--------+-----------------\n");
    }
    else
    {
        cprint("\" kill | weapon |      name\"\n");
        cprint("------+--------+-----------------\n");
    }
	player = elohim_sentinel.next_player;

    while (player)
    {
        if (useteams)
		{
			teamname = strings_get_teamname2(player.height);
            cprint3("\" ", teamname, " | ");
		}
		else
            cprint("\" ");
        kfrac = player.frags + player.mangle_x + player.mangle_y;
        ktot = kfrac + player.mangle_x + player.mangle_y + player.mangle_z;
        wtot = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
        wfrac = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
        console_print_percent4(kfrac, ktot);
        localcmd(" |  ");
        console_print_percent4(wfrac, wtot);
        localcmd3("  | ", player.netname, "\"\n");
		player = player.next_player;
    }
    cprint("\n");
};

//
//  C O M M A N D S
//
//  Show a list of valid commands (dedicated only)
//
void () console_commands =
{
    cprint("\n");
    cprint3("\"Clanring CRMod++ v", crmod_version_number, " console commands:\"\n");
    cprint("\n");
    cprint("\"s          - view server status including time elapsed\"\n");
    cprint("\"vinfo      - show server version information\"\n");
    cprint("\"sping      - view approximate client ping times\"\n");
    cprint("\"time       - view time elapsed on current level\"\n");
	cprint("\"settings   - view current server settings\"\n");
    cprint("\"score      - view score and time remaining in match\"\n");
    cprint("\"ghostlist  - view all ghosts in database\"\n");
	cprint("\"setpass    - set password (use 'skill')\"\n");
	cprint("\"otset      - set overtime (use 'skill')\"\n");
	cprint("\"maxteams   - set the maximum number of teams (use 'skill')\"\n");
	cprint("\"nopractice - disable practice mode\"\n");
	cprint("\"obitson/obitsoff      - enable/disable extended obituaries\"\n");
	cprint("\"freshspawnson/freshspawnsoff   - enable/disable fresh spawns\"\n");
	cprint("\"faststarton/faststartoff       - enable/disable fast match starts\"\n");
	cprint("\"autopauseon/autopauseoff       - enable/diable automatic match pausing\"\n");
	cprint("\"highggibs/lowgibs/nogibs       - set gibs to high/low/disabled\"\n");
	cprint("\"modevoteon/modevoteoff         - enable/disable mode voting\"\n");
	cprint("\"safepracticeon/safepracticeoff - enable/disable discharging & grenade spamming\"\n");
    cprint("\"normal/practice/match/individual - set playmode\"\n");
	cprint("\"quadon/quadoff/penton/pentoff/ringon/ringoff - enable/disable powerups\"\n");
	cprint("\"stats/killstats/efficiency/quadstats/badstats - view player statistics\"\n");
};

//
//  D E B U G  C L I E N T
//
//  Enter debug mode for the client indicated by cvar 'skill'.
//
void () console_debug_client =
{
    local float id;
    local entity client;

    id = cvar("skill");
    client = find(world, classname, "player");
    while (client)
    {
        if (client.colormap == id)
        {
            elohim_debug_client = client;
            cprint3("\"debugging ", client.netname, "\"\n");
            return;
        }
        client = find(client, classname, "player");
    }
    cprint("client not found\n");
};

//
//  S T U F F  I M P U L S E
//
//  Stuff an impulse into the console of the debug client.
//
void () console_stuff_impulse =
{
    local float temp;
    local string s;

    if (!elohim_debug_client)
    {
        cprint("No debug client\n");
        return;
    }
    temp = cvar("skill");
    s = ftos(temp);
    stuffcmd(elohim_debug_client, "impulse ");
    stuffcmd(elohim_debug_client, s);
    stuffcmd(elohim_debug_client, "\n");
    cprint3("stuffing impulse ", s, "\n");
};

//
//  S T U F F  C O L O U R
//
//  Stuff a colour into the console of the debug client.
//
void () console_stuff_colour =
{
    local float temp;
    local string s;

    if (!elohim_debug_client)
    {
        cprint("No debug client\n");
        return;
    }
    temp = cvar("skill");
    s = ftos(temp);
    stuffcmd(elohim_debug_client, "color ");
    stuffcmd(elohim_debug_client, s);
    stuffcmd(elohim_debug_client, "\n");
    cprint3("stuffing color ", s, "\n");
};

//
//  C L I E N T  F L A G S
//
void () console_client_flags =
{
    if (!elohim_debug_client)
    {
        cprint("No debug client\n");
        return;
    }
    cprint("\n");
    cprint3("\"Client flags for ", elohim_debug_client.netname, ":\"\n");
    cprint("\n");
    if (elohim_debug_client.style & ELOHIM_NEW_CLIENT)
        cprint("ELOHIM_NEW_CLIENT\n");
    if (elohim_debug_client.style & ELOHIM_ADMINISTRATOR)
        cprint("ELOHIM_ADMINISTRATOR\n");
   	if (elohim_debug_client.style & CRMOD_DETECTING_QSMACK)	// CRMOD was SMOOTH
		cprint("CRMOD_DETECTING_QSMACK\n");					// CRMOD was SMOOTH
	if (elohim_debug_client.style & ELOHIM_POP_FORWARD)
        cprint("ELOHIM_POP_FORWARD\n");
    if (elohim_debug_client.style & ELOHIM_READY)
        cprint("ELOHIM_READY\n");
    if (elohim_debug_client.style & ELOHIM_YES)
        cprint("ELOHIM_YES\n");
    if (elohim_debug_client.style & ELOHIM_HEADS_UP)
        cprint("ELOHIM_HEADS_UP\n");
    if (elohim_debug_client.style & ELOHIM_SETTING_OPTIONS)
        cprint("ELOHIM_SETTING_OPTIONS\n");
    if (elohim_debug_client.style & ELOHIM_MOTD)
        cprint("ELOHIM_MOTD\n");
    if (elohim_debug_client.style & ELOHIM_OK_TO_SHOOT)
        cprint("ELOHIM_OK_TO_SHOOT\n");
    if (elohim_debug_client.style & ELOHIM_KICK_CONFIRM)
        cprint("ELOHIM_KICK_CONFIRM\n");
    if (elohim_debug_client.style & ELOHIM_CONFIRM_LEAVE)
        cprint("ELOHIM_CONFIRM_LEAVE\n");
    if (elohim_debug_client.style & ELOHIM_CONNECTED)
        cprint("ELOHIM_CONNECTED\n");
    if (elohim_debug_client.style & ELOHIM_FOUND_BINDINGS)
        cprint("ELOHIM_FOUND_BINDINGS\n");
	if (elohim_debug_client.style & CRMOD_SMART_WEAPON)
		cprint("CRMOD_SMART_WEAPON\n");
    if (elohim_debug_client.style & ELOHIM_OBSERVER)
        cprint("ELOHIM_OBSERVER\n");
    if (elohim_debug_client.style & CRMOD_QSMACK)
        cprint("CRMOD_QSMACK\n");
    if (elohim_debug_client.style & ELOHIM_SCOREBOARD)
        cprint("ELOHIM_SCOREBOARD\n");
    if (elohim_debug_client.style & ELOHIM_NO_POST_THINK)
        cprint("ELOHIM_NO_POST_THINK\n");
    if (elohim_debug_client.style & ELOHIM_WINQUAKE)
        cprint("ELOHIM_WINQUAKE\n");
    if (elohim_debug_client.style & ELOHIM_GLQUAKE)
        cprint("ELOHIM_GLQUAKE\n");
    if (elohim_debug_client.style & ELOHIM_AUTOSTATS)
        cprint("ELOHIM_AUTOSTATS\n");

	// CRMOD - change to oflags
    cprint("\n");
    cprint3("\"Client Observer Flags for ", elohim_debug_client.netname, ":\"\n");
    cprint("\n");
    if (elohim_debug_client.oflags & OBSERVER_WALK)
        cprint("OBSERVER_WALK\n");
    if (elohim_debug_client.oflags & OBSERVER_FLY)
        cprint("OBSERVER_FLY\n");
    if (elohim_debug_client.oflags & OBSERVER_CHASE)
        cprint("OBSERVER_CHASE\n");
    if (elohim_debug_client.oflags & OBSERVER_DEMO)
        cprint("OBSERVER_DEMO\n");
    if (elohim_debug_client.oflags & OBSERVER_CAMERA)
    	cprint("OBSERVER_CAMERA\n");
	if (elohim_debug_client.oflags & OBSERVER_AUTO)
		cprint("OBSERVER_AUTO\n");
	if (elohim_debug_client.oflags & OBSERVER_TOURNEY)
		cprint("OBSERVER_TOURNEY\n");
	if (elohim_debug_client.oflags & OBSERVER_GO_AUTO)
		cprint("OBSERVER_GO_AUTO\n");
	if (elohim_debug_client.oflags & OBSERVER_COMMENTARY)
		cprint("OBSERVER_COMMENTARY\n");
	// CRMOD END
    cprint("\n");
};

//
//  S E R V E R  F L A G S
//
void () console_server_flags =
{
    cprint("\n");
	cprint("Server flags:\n");
    cprint("\n");

	// playmode flags
	if (elohim_playmode & ELOHIM_SAME_LEVEL)
		cprint("ELOHIM_SAME_LEVEL\n");
	if (elohim_playmode & ELOHIM_MATCH_MODE)
		cprint("ELOHIM_MATCH_MODE\n");
	if (elohim_playmode & ELOHIM_PRACTICE_MODE)
		cprint("ELOHIM_PRACTICE_MODE\n");
	if (elohim_playmode & ELOHIM_SERVER_INITIALIZED)
		cprint("ELOHIM_SERVER_INITIALIZED\n");
	if (elohim_playmode & ELOHIM_NO_GIBS)
		cprint("ELOHIM_NO_GIBS\n");
	if (elohim_playmode & ELOHIM_LOW_GIBS)
		cprint("ELOHIM_LOW_GIBS\n");
	if (elohim_playmode & ELOHIM_NO_QUAD)
		cprint("ELOHIM_NO_QUAD\n");
	if (elohim_playmode & ELOHIM_NO_PENT)
		cprint("ELOHIM_NO_PENT\n");
	if (elohim_playmode & ELOHIM_NO_RING)
		cprint("ELOHIM_NO_RING\n");
	if (elohim_playmode & ELOHIM_MODE_VOTE)
		cprint("ELOHIM_MODE_VOTE\n");
	if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
		cprint("ELOHIM_DEDICATED_SERVER\n");
	if (elohim_playmode & ELOHIM_NO_SPOOGE)
		cprint("ELOHIM_NO_SPOOGE\n");
//	if (elohim_playmode & CRMOD_QSMACK_ON)
//		cprint("CRMOD_QSMACK_ON\n");
	if (elohim_playmode & ELOHIM_EXTENDED_OBITS)
		cprint("ELOHIM_EXTENDED_OBITS\n");
	if (elohim_playmode & ELOHIM_CONSOLE_INITIALIZED)
		cprint("ELOHIM_CONSOLE_INITIALIZED\n");
	if (elohim_playmode & ELOHIM_FAST_START)
		cprint("ELOHIM_FAST_START\n");
	if (elohim_playmode & ELOHIM_FRESH_SPAWNS)
		cprint("ELOHIM_FRESH_SPAWNS\n");
	if (elohim_playmode & ELOHIM_AUTO_PAUSE)
		cprint("ELOHIM_AUTO_PAUSE\n");

    cprint("\n");

	// state flags
	if (elohim_state & ELOHIM_TIMER_STARTED)
		cprint("ELOHIM_TIMER_STARTED\n");
	if (elohim_state & ELOHIM_MATCH_STARTED)
		cprint("ELOHIM_MATCH_STARTED\n");
	if (elohim_state & ELOHIM_MATCH_PAUSED)
		cprint("ELOHIM_MATCH_PAUSED\n");
	if (elohim_state & ELOHIM_MATCH_OVER)
		cprint("ELOHIM_MATCH_OVER\n");
	if (elohim_state & ELOHIM_MATCH_WAIT)
		cprint("ELOHIM_MATCH_WAIT\n");
	if (elohim_state & ELOHIM_KICKING)
		cprint("ELOHIM_KICKING\n");
	if (elohim_state & ELOHIM_NO_PRACTICE)
		cprint("ELOHIM_NO_PRACTICE\n");
	if (elohim_state & ELOHIM_ELOSTART)
		cprint("ELOHIM_ELOSTART\n");
	if (elohim_state & ELOHIM_UNPAUSING)
		cprint("ELOHIM_UNPAUSING\n");
	if (elohim_state & ELOHIM_AUTO_PAUSED)
		cprint("ELOHIM_AUTO_PAUSED\n");
	if (elohim_state & ELOHIM_DELAYED_AUTOSS)
		cprint("ELOHIM_DELAYED_AUTOSS\n");

    cprint("\n");
};

//
//  D E B U G  H E L P 
//
void () console_debug_help = 
{
	cprint("\n");
	cprint("\"debugclient  - select client (use 'skill')\"\n");
	cprint("\"debugoff     - deselect client\"\n");
	cprint("\"stuffimpulse - stuff impulse (use 'skill')\"\n");
	cprint("\"stuffcolor   - stuff colour (use 'skill')\"\n");
	cprint("\"dbcflags     - show client flags\"\n");
	cprint("\"dbcinfo      - show client info\"\n");
	cprint("\"dbsflags     - show server flags\"\n");
	cprint("\n");
};

//
//  C L I E N T  I N F O 
//
void () console_client_info = 
{
	local string temp;

    if (!elohim_debug_client)
    {
        cprint("No debug client\n");
        return;
    }
	cprint("\n");
	temp = fnstrings_function(elohim_debug_client.think);
	cprint3("\"think     = ", temp, "\"\n");
	temp = ftos(elohim_debug_client.nextthink);
	cprint3("\"nextthink = ", temp, "\"\n");
	temp = ftos(time);
	cprint3("\"current time = ", temp, "\"\n");
	cprint("\n");
};

//
//  V E R S I O N  I N F O
//
void () console_version_info =
{
    cprint("\n");
    cprint3("\"", elohim_version_info, "\"\n");
    cprint("\n");
};

//
//  C H E C K  L E V E L
//
//  Check to see if we've found the next level in levels.cfg
//
void (float newlevel) console_check_level =
{
	// if elohim_levelcount == -1 then we haven't executed levels.cfg, so
	// change levels immediately.
	if (elohim_levelcount == -1)
	{
		nextmap = strings_get_mapname(newlevel);
		localcmd3("changelevel ", nextmap, "\n");
		return;
	}

    // To choose the next level, we should set nextmap when
    // elohim_levelcount == elohim_level.  If the current level is the
    // last one in the list then this will never occur, so we should also
    // set nextmap when we see the first level in the list.
    if (elohim_levelcount == 0 || elohim_levelcount == elohim_level)
    {
        nextmap = strings_get_mapname(newlevel);
        utils_set_cvar("scratch1", elohim_levelcount + 1);
    }

    elohim_levelcount = elohim_levelcount + 1;
};

//
//  G E T  U S E R  N E X T L E V E L
//
//  Check for a user-defined level sequence (dedicated only).
//
void () console_get_user_nextlevel =
{
    if (elohim_playmode & ELOHIM_DEDICATED_SERVER)
    {
        elohim_levelcount = 0;
        elohim_lastcount = 0;
        elohim_nextcheck = 0;
        localcmd("exec levels.cfg\n");
    }
};

//
//  G E T  O R I G I N
//
//  Return the vector 'scr_ofsx scr_ofsy scr_ofsz'
//
vector () console_get_origin =
{
    local vector v;

    v_x = cvar("scr_ofsx");
    v_y = cvar("scr_ofsy");
    v_z = cvar("scr_ofsz");
    return v;
};

//
//  G E T  A N G L E S
//
//  Return the angles vector 'v_ipitch_level v_iyaw_level v_iroll_level'
//
vector () console_get_angles =
{
    local vector v;

    v_x = cvar("v_ipitch_level");
    v_y = cvar("v_iyaw_level");
    v_z = cvar("v_iroll_level");
    return v;
};

//
//  M A K E  E N T I T Y
//
//  Create a new entity using the origin and angle specified in a
//  configuration file.
//
void (string name, float angleflags) console_make_entity =
{
    local entity newent;
    local string temp;

    // create entity
    newent = spawn();
    newent.owner = world;
    newent.solid = SOLID_NOT;
    newent.movetype = MOVETYPE_NONE;
    newent.takedamage = DAMAGE_NO;
    newent.fixangle = TRUE;
    newent.classname = name;
    newent.origin = console_get_origin();
    newent.angles = console_get_angles();
	newent.style = ELOHIM_MANUAL_SPAWN;
    if (!(angleflags & CONSOLE_ENT_PITCH))
        newent.angles_x = 0;
    if (!(angleflags & CONSOLE_ENT_YAW))
        newent.angles_y = 0;
    if (!(angleflags & CONSOLE_ENT_ROLL))
        newent.angles_z = 0;

    temp = vtos(newent.origin);
    cprint4(name, " created at ", temp, ", ");
    temp = vtos(newent.angles);
    localcmd2(temp, "\n");
    if (name == "elohim_camera")
    {
    	newent.nextthink = ELOHIM_NEGINF;
    	newent.think = auto_camera_think;
		newent.next_camera = elohim_sentinel.next_camera;
		elohim_sentinel.next_camera = newent;
    }
};

//
//  K I L L  E N T I T Y
//
//  Search for the entity of the given type at origin specified in the
//  configuration file; kill it if it exists.
//
void (string name) console_kill_entity =
{
    local vector location;
    local entity e;
    local string temp;

    location = console_get_origin();
    temp = vtos(location);

    e = find(world, classname, name);
    while (e)
    {
		if (e.style != ELOHIM_MANUAL_SPAWN)
		{
			local vector v;
			v = e.origin - location;
			if (vlen(v) < 20)
			{
				cprint5("removed ", name, " at ", temp, ", ");
				temp = vtos(e.angles);
				localcmd2(temp, "\n");

				remove(e);
				return;            
			}
		}
        e = find(e, classname, name);
    }
    cprint5("\"killentity: couldn't find ", name, " at ", temp, "\"\n");
};

//
//  K I L L  I T E M
//
//  Kill any respawnable item at the specified location.
//
void () console_kill_item = 
{
	local vector v;
	local string temp;
	local float dz;

	if (self.style == ELOHIM_MANUAL_SPAWN)
		return;

	v = self.origin - console_origin;
	dz = fabs(v_z);
	v_z = 0;
	if (vlen(v) < 20 && dz < 100)
	{
		temp = vtos(self.origin);
		cprint5("removed ", self.classname, " at ", temp, "\n");		
		remove(self);
	}
};

//
//  M A K E  I T E M
//
//  Create a new item, specified by skill
//
void () console_make_item = 
{
	local float item;
	local entity oself;
    local string temp;

	item = cvar("skill");
	oself = self;

    // create entity
    self = spawn();
    self.owner = world;
    self.takedamage = DAMAGE_NO;
    self.fixangle = TRUE;
    self.origin = console_origin;
    self.angles = '0 0 0';
	self.style = ELOHIM_MANUAL_SPAWN;

	if (item < 4)
	{
		self.classname = "item_health";
		if (item == 1)
			self.spawnflags = H_ROTTEN;
		else if (item == 3)
			self.spawnflags = H_MEGA;
		item_health();
	}
	else if (item == 4)
	{
		self.classname = "item_armor1";
		item_armor1();
	}
	else if (item == 5)
	{
		self.classname = "item_armor2";
		item_armor2();
	}
	else if (item == 6)
	{
		self.classname = "item_armorInv";
		item_armorInv();
	}
	else if (item >= 7 && item <= 14)
	{
		if (!(item & 1))
			self.spawnflags = WEAPON_BIG2;
		
		if (item < 9)
		{
			self.classname = "item_shells";
			item_shells();
		}
		else if (item < 11)
		{
			self.classname = "item_spikes";
			item_spikes();
		}
		else if (item < 13)
		{
			self.classname = "item_rockets";
			item_rockets();
		}
		else
		{
			self.classname = "item_cells";
			item_cells();
		}
	}
	else if (item == 15)
	{
		self.classname = "weapon_supershotgun";
		weapon_supershotgun();
	}
	else if (item == 16)
	{
		self.classname = "weapon_nailgun";
		weapon_nailgun();
	}
	else if (item == 17)
	{
		self.classname = "weapon_supernailgun";
		weapon_supernailgun();
	}
	else if (item == 18)
	{
		self.classname = "weapon_grenadelauncher";
		weapon_grenadelauncher();
	}
	else if (item == 19)
	{
		self.classname = "weapon_rocketlauncher";
		weapon_rocketlauncher();
	}
	else if (item == 20)
	{
		self.classname = "weapon_lightning";
		weapon_lightning();
	}
	else if (item == 21)
	{
		self.classname = "item_artifact_envirosuit";
		item_artifact_envirosuit();
	}
	else if (item == 22)
	{
		self.classname = "item_artifact_super_damage";
		item_artifact_super_damage();
	}
	else if (item == 23)
	{
		self.classname = "item_artifact_invulnerability";
		item_artifact_invulnerability();
	}
	else if (item == 24)
	{
		self.classname = "item_artifact_invisibility";
		item_artifact_invisibility();
	}
	else
	{
		remove(self);
		self = oself;
		return;
	}

    temp = vtos(self.origin);
    cprint4(self.classname, " created at ", temp, "\n");

	self = oself;
};

//
//  C H A N G E  I T E M
//
//  Kill any respawnable item at the specified location and make a new one
//  in its place.
//
void () console_change_item = 
{
	local vector v;
	local string temp;
	local float dz;

	if (self.style == ELOHIM_MANUAL_SPAWN)
		return;

	v = self.origin - console_origin;
	dz = fabs(v_z);
	v_z = 0;
	if (vlen(v) < 20 && dz < 100)
	{
		console_origin = self.origin;
		temp = vtos(console_origin);
		cprint5("removed ", self.classname, " at ", temp, "\n");		
		remove(self);
		console_make_item();
	}
};

//
//  O N O F F
//
void (float val) console_onoff = 
{
	if (val)
		localcmd("on\n");
	else
		localcmd("off\n");
};

//
//  S H O W  S E T T I N G S
//
void () console_show_settings = 
{
	local float temp;
	local string sz;

	cprint("\n");

    temp = options_get_mode();
    sz = strings_get_mode(temp);
    cprint2(sz, " mode\n");

	localcmd("timelimit\n");
	localcmd("fraglimit\n");
	localcmd("teamplay\n");
	localcmd("deathmatch\n");
	localcmd("pausable\n");
	localcmd("sys_ticrate\n");

	cprint("overtime: ");
	if (elohim_overtime == -1)
		localcmd("sudden death\n");
	else if (elohim_overtime == 0)
		localcmd("disabled\n");
	else 
	{
		sz = ftos(elohim_overtime);
		localcmd(sz);
		sz = strings_szplural(elohim_overtime);
		localcmd2(" minute", sz);
	}

	sz = ftos(elohim_maxteams);
	cprint3("maxteams: ", sz, "\n");

	cprint("gibs: ");
	if (elohim_playmode & ELOHIM_NO_GIBS)
		localcmd("off\n");
	else if (elohim_playmode & ELOHIM_LOW_GIBS)
		localcmd("low\n");
	else
		localcmd("high\n");

	cprint("safe practice: ");
	console_onoff(elohim_playmode & ELOHIM_NO_SPOOGE);

	cprint("quad: ");
	console_onoff(ELOHIM_NO_QUAD - (elohim_playmode & ELOHIM_NO_QUAD));
	cprint("pentagram: ");
	console_onoff(ELOHIM_NO_PENT - (elohim_playmode & ELOHIM_NO_PENT));
	cprint("ring: ");
	console_onoff(ELOHIM_NO_RING - (elohim_playmode & ELOHIM_NO_RING));

	cprint("mode voting: ");
	console_onoff(elohim_playmode & ELOHIM_MODE_VOTE);
	cprint("extended obituaries: ");
	console_onoff(elohim_playmode & ELOHIM_EXTENDED_OBITS);
	cprint("fast match starts: ");
	console_onoff(elohim_playmode & ELOHIM_FAST_START);
	cprint("fresh spawns: ");
	console_onoff(elohim_playmode & ELOHIM_FRESH_SPAWNS);
	cprint("autopausing: ");
	console_onoff(elohim_playmode & ELOHIM_AUTO_PAUSE);

	cprint("\n");
};

//
//  S E T  M A X  T E A M S
//
//  Set the maximum number of teams.
//
void (float maxteams) console_set_max_teams = 
{
	maxteams = floor(maxteams);
	if (maxteams >= 2 && maxteams <= 8)
		admin_set_maxteams(maxteams);
};

//
//  F R E S H  S P A W N S
//
void (float val) console_fresh_spawns = 
{
	if (val)
	{
		elohim_playmode = elohim_playmode | ELOHIM_FRESH_SPAWNS;
		cprint("Fresh spawns enabled\n");
	}
	else
	{
		elohim_playmode = elohim_playmode - (elohim_playmode & ELOHIM_FRESH_SPAWNS);
		cprint("Fresh spawns disabled\n");
	}
	utils_set_cvar("samelevel", elohim_playmode);
};

//
//  C O M M A N D
//
//  Interpret a console command.  Called from elohim_start_frame.
//
void (float command) console_command =
{
    local string temp;

	// immediate mode commands
    if (command == 1)
        console_ping();
    else if (command == 2)
        console_show_time();
    else if (command == 3)
        console_show_status();
    else if (command == 4)
        console_show_debug_info();
    else if (command == 5)
        console_show_score();
    else if (command == 6)
        console_list_ghosts();
    else if (command == 7)
        console_show_killstats();
    else if (command == 8)
        console_show_efficiency();
    else if (command == 9)
        console_show_stats();
    else if (command == 10)
        console_commands();
    else if (command == 11)
        console_version_info();
    else if (command >= 12 && command <= 15)
		votables_request_set_mode(command - 12);
	else if (command == 16)
		console_show_quadstats();
	else if (command == 17)
		console_show_settings();
	else if (command == 18)
		console_show_badstats();

	// config file commands
	else if (command >= 20 && command <= 44)
	{
		local float arg;

		arg = cvar("skill");
		cvar_set("skill", "0");

		if (elohim_state & ELOHIM_IGNORE_CONSOLE)
			return;

		if (command == 20 && !(elohim_playmode & ELOHIM_NO_SPOOGE))
			utils_toggle_sflag(ELOHIM_NO_SPOOGE, "Safe practice mode");
		else if (command == 21 && (elohim_playmode & ELOHIM_NO_SPOOGE))
			utils_toggle_sflag(ELOHIM_NO_SPOOGE, "Safe practice mode");
		else if (command >= 22 && command <= 24)
			votables_request_set_gibs(command - 22);
		else if (command == 25 && (elohim_playmode & ELOHIM_NO_QUAD))
			votables_set_quad();
		else if (command == 26 && !(elohim_playmode & ELOHIM_NO_QUAD))
			votables_set_quad();
		else if (command == 27 && (elohim_playmode & ELOHIM_NO_PENT))
			votables_set_pent();
		else if (command == 28 && !(elohim_playmode & ELOHIM_NO_PENT))
			votables_set_pent();
		else if (command == 29 && (elohim_playmode & ELOHIM_NO_RING))
			votables_set_ring();
		else if (command == 30 && !(elohim_playmode & ELOHIM_NO_RING))
			votables_set_ring();
		else if (command == 31 && !(elohim_playmode & ELOHIM_MODE_VOTE))
			utils_toggle_sflag(ELOHIM_MODE_VOTE, "Mode voting");
		else if (command == 32 && (elohim_playmode & ELOHIM_MODE_VOTE))
			utils_toggle_sflag(ELOHIM_MODE_VOTE, "Mode voting");
		else if (command == 33 && !(elohim_playmode & ELOHIM_EXTENDED_OBITS))
			utils_toggle_sflag(ELOHIM_EXTENDED_OBITS, "Extended obituaries");
		else if (command == 34 && (elohim_playmode & ELOHIM_EXTENDED_OBITS))
			utils_toggle_sflag(ELOHIM_EXTENDED_OBITS, "Extended obituaries");
		else if (command == 35)
		{
			elohim_password = arg;
			cprint("password set\n");
		}
		else if (command == 36)
			votables_request_set_overtime(arg);
		else if (command == 37)
			console_set_max_teams(arg);
		else if (command == 38 && !(elohim_playmode & ELOHIM_FAST_START))
			utils_toggle_sflag(ELOHIM_FAST_START, "Fast match starts");
		else if (command == 39 && (elohim_playmode & ELOHIM_FAST_START))
			utils_toggle_sflag(ELOHIM_FAST_START, "Fast match starts");
		else if (command >= 40 && command <= 41)
			console_fresh_spawns(41 - command);
		else if (command == 42)
		{
			elohim_state = elohim_state | ELOHIM_NO_PRACTICE;
			cprint("practice mode disabled\n");
		}
		else if (command == 43 && !(elohim_playmode & ELOHIM_AUTO_PAUSE))
			utils_toggle_sflag(ELOHIM_AUTO_PAUSE, "Automatic match pausing");
		else if (command == 44 && (elohim_playmode & ELOHIM_AUTO_PAUSE))
			utils_toggle_sflag(ELOHIM_AUTO_PAUSE, "Automatic match pausing");
	}
		
	// entity file commands
    else if (command == 50)
    {
        console_make_entity("info_player_deathmatch", CONSOLE_ENT_YAW);
        elohim_num_spawns = elohim_num_spawns + 1;
    }
    else if (command == 51)
    {
        console_make_entity("elohim_start_point", CONSOLE_ENT_YAW);
        elohim_num_starts = elohim_num_starts + 1;
    }
    else if (command == 52)
        console_kill_entity("info_player_deathmatch");
    else if (command == 53)
    {
        console_make_entity("elohim_camera", CONSOLE_ENT_PITCH | CONSOLE_ENT_YAW);
        elohim_num_cameras = elohim_num_cameras + 1;
    }
	else if (command >= 54 && command <= 56)
	{
		console_origin = console_get_origin();
		if (command == 54)
			utils_do_items(console_kill_item);
		else if (command == 55)
			console_make_item();
		else
			utils_do_items(console_change_item);
	}

	// control commands
	else if (command >= 60 && command <= 65)
	{
		if (elohim_state & ELOHIM_IGNORE_CONSOLE)
		{
			utils_set_cvar("deathmatch", console_deathmatch);
			utils_set_cvar("timelimit", console_timelimit);
			utils_set_cvar("fraglimit", console_fraglimit);
			utils_set_cvar("pausable", console_pausable);
			utils_set_cvar("noexit", console_noexit);
		}
		else
		{
			console_deathmatch = cvar("deathmatch");
			console_timelimit = cvar("timelimit");
			console_fraglimit = cvar("fraglimit");
			console_pausable = cvar("pausable");
			console_noexit = cvar("noexit");
		}

		if (command == 60)
		{
			if (elohim_playmode & ELOHIM_CONSOLE_INITIALIZED)
				elohim_state = elohim_state | ELOHIM_IGNORE_CONSOLE;
			else
			{
				elohim_playmode = elohim_playmode | ELOHIM_CONSOLE_INITIALIZED;
				utils_set_cvar("samelevel", elohim_playmode);
				elohim_state = elohim_state - (elohim_state & ELOHIM_IGNORE_CONSOLE);
			}
		}
		else if (command >= 61 && command <= 64)
		{
			if (command - 61 != options_get_mode())
				elohim_state = elohim_state | ELOHIM_IGNORE_CONSOLE;
			else
				elohim_state = elohim_state - (elohim_state & ELOHIM_IGNORE_CONSOLE);
		}
		else if (command == 65)
		{
			elohim_state = elohim_state - (elohim_state & ELOHIM_IGNORE_CONSOLE);
			admin_dmset(console_deathmatch);
			votables_request_set_timelimit(console_timelimit);
			elohim_set_fraglimit(console_fraglimit);
			utils_set_cvar("pausable", console_pausable);
			utils_set_cvar("noexit", console_noexit);
		}
	}

	// undocumented debug commands
    else if (command == 70)
        console_debug_client();
    else if (command == 71)
    {
        cprint("debugging off\n");
        elohim_debug_client = world;
    }
    else if (command == 72)
        console_stuff_impulse();
    else if (command == 73)
        console_stuff_colour();
    else if (command == 74)
        console_client_flags();
    else if (command == 75)
        console_server_flags();
	else if (command == 76)
		console_client_info();
	else if (command == 77)
		console_debug_help();

	// map aliases
    else if (command >= 100 && command < 170)
        console_check_level(command - 100);
    else
        cprint("unknown command\n");
};

