//
// Stats.qc
//
// Various routines for displaying statistics.
//
// All code by J.P. Grossman unless otherwise commented.
//

//
//  P R O T O T Y P E S
//
void (float frac, float tot) stats_print_percent3;


//
//  R E S E T  P L A Y E R
//
void () stats_reset_player =
{
    self.dest1 = self.dest2 = self.dest = self.mangle = '0 0 0';
	self.crmod_qdwep = self.crmod_qdkill = self.crmod_badstats = '0 0 0';
    self.crmod_did_damage = 0; // CRMOD moved here from put_client_in_server
};

//
//  R E S E T  T E A M
//
void (entity pteam) stats_reset_team = 
{
	pteam.dest = pteam.dest1 = pteam.dest2 = pteam.pos1 = pteam.mangle = '0 0 0';
};

//
//  S H O W  B A D S T A T S
//
void () stats_show_badstats =
{
    local entity player;
	local float tot_enemy, tot_done;

	if (!(elohim_playmode & ELOHIM_MATCH_MODE) || !teamplay)
	{
		sprint(self, "badstats valid in match mode only\n");
		return;
	}

    sprint(self, "paks - number of RL paks given away\n");
    sprint(self, "self - percent damage done to self\n");
    sprint(self, "team - percent damage done to team\n");
    sprint(self, "\n");
    sprint(self, " paks ü self ü team ü      name\n");
    sprint(self, "­­­­­­«­­­­­­«­­­­­­«­­­­­­­­­­­­­­­­\n");

    player = elohim_sentinel.next_player;
    while (player)
    {
        tot_enemy = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
		tot_done = tot_enemy + player.crmod_badstats_y + player.crmod_badstats_z;
        if (player == self)
        {
            sprint(self, " ");
            utils_print_int3(player.crmod_badstats_x);
            sprint(self, "‘ü ");
			stats_print_percent3(player.crmod_badstats_y, tot_done);
            sprint(self, "‘ü ");
			stats_print_percent3(player.crmod_badstats_z, tot_done);
            sprint(self, "‘ü ");
        }
        else
        {
            sprint(self, "  ");
            utils_print_int3(player.crmod_badstats_x);
            sprint(self, " ü  ");
			stats_print_percent3(player.crmod_badstats_y, tot_done);
            sprint(self, " ü  ");
			stats_print_percent3(player.crmod_badstats_z, tot_done);
            sprint(self, " ü ");
        }
        sprint(self, player.netname, "\n");
        player = player.next_player;
    }
};

//
//  S H O W  Q U A D S T A T S
//
void () stats_show_quadstats =
{
    local entity player, pteam;
	local float useteams;
	//local string teamname;

	if ((elohim_state & (ELOHIM_MATCH_STARTED | ELOHIM_MATCH_OVER)) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;

    sprint(self, "quads - quads picked up\n");
    sprint(self, "eff   - quad weapon efficiency\n");
    sprint(self, "opp   - number of opponents killed\n");
    sprint(self, "slf   - number of times killed self\n");
    sprint(self, "tm    - number of teammates killed\n");
    sprint(self, "\n");
    sprint(self, "quadsüeffüoppüslfütm ü     name\n");
    sprint(self, "­­­­­«­­­«­­­«­­­«­­­«­­­­­­­­­­­­­­­\n");

    player = elohim_sentinel.next_player;
	pteam = player.next_team;
	/*todo group quadstats by team
            if (useteams)
		{
			teamname = strings_get_teamname3(player.height);
            sprint(self, teamname, "ü");
		}
    */
    while (player)
    {
        if (player == self)
        {
            sprint(self, "");
            utils_print_int3(player.crmod_qdwep_z);
            sprint(self, "‘ü");
        }
        else
        {
            sprint(self, " ");
            utils_print_int3(player.crmod_qdwep_z);
            sprint(self, " ü");
        }
        stats_print_percent3(player.crmod_qdwep_x, player.crmod_qdwep_y);
        sprint(self, "ü");
        utils_print_int3(player.crmod_qdkill_x);
        sprint(self, "ü");
        utils_print_int3(player.crmod_qdkill_z);
        sprint(self, "ü");
        utils_print_int3(player.crmod_qdkill_y);
        sprint(self, "ü", player.netname, "\n");
        player = player.next_player;
		if (useteams && (player.next_team != pteam))
		{
			sprint(self, " ");
			utils_print_int3_gold(pteam.crmod_qdwep_z);
			sprint(self, " ü   ü   ü   ü   ü", pteam.mdl, "\n");
			pteam = player.next_team;
		}
    }
};

//
//  S H O W  K I L L S T A T S
//
void () stats_show_killstats =
{
    local entity player;

    sprint(self, "opp - number of opponents killed\n");
    sprint(self, "slf - number of times killed self\n");
    sprint(self, "tm  - number of teammates killed\n");
    sprint(self, "kld - number of times killed by enemy\n");
    sprint(self, "\n");
    sprint(self, "fragsüoppüslfütm ükldü     name\n");
    sprint(self, "­­­­­«­­­«­­­«­­­«­­­«­­­­­­­­­­­­­­­\n");

    player = elohim_sentinel.next_player;
    while (player)
    {
        if (player == self)
        {
            sprint(self, "");
            utils_print_int3(player.frags);
            sprint(self, "‘ü");
        }
        else
        {
            sprint(self, " ");
            utils_print_int3(player.frags);
            sprint(self, " ü");
        }
        utils_print_int3(player.frags + player.mangle_x + player.mangle_y);
        sprint(self, "ü");
        utils_print_int3(player.mangle_x);
        sprint(self, "ü");
        utils_print_int3(player.mangle_y);
        sprint(self, "ü");
        utils_print_int3(player.mangle_z);
        sprint(self, "ü", player.netname, "\n");
        player = player.next_player;
    }
};

//
//  P R I N T  P E R C E N T 3
//
//  Helper function for stats_show_efficiency.  Prints the percentage
//  100 * (frac / tot) as a 3 character integer, or N/A if tot = 0.
//
void (float frac, float tot) stats_print_percent3 =
{
    if (tot)
    {
        local float n;
        local string temp;

        n = floor(100 * frac / tot);
        if (n < 10)
            sprint(self, " ");
        temp = ftos(n);
        sprint(self, temp);
        if (n < 100)
            sprint(self, "%");
    }
    else
        sprint(self, "N/A");
};

//
//  S H O W  E F F I C I E N C Y
//
//  Show the weapon efficiency for each player.
//
void () stats_show_efficiency =
{
    local entity player;
    local float tot_fired, tot_done;

    sprint(self, "bul - bullet efficiency\n");
    sprint(self, "nls - nail efficiency\n");
    sprint(self, "rox - rocket efficiency\n");
    sprint(self, "lg  - lightning gun efficiency\n");
    sprint(self, "\n");
    sprint(self, "bulünlsüroxülg ütotalü     name\n");
    sprint(self, "­­­«­­­«­­­«­­­«­­­­­«­­­­­­­­­­­­­­­\n");

    player = elohim_sentinel.next_player;
    while (player)
    {
        stats_print_percent3(player.dest2_x, player.dest1_x);
        sprint(self, "ü");
        stats_print_percent3(player.dest2_y, player.dest1_y);
        sprint(self, "ü");
        stats_print_percent3(player.dest_y, player.dest_x);
        sprint(self, "ü");
        stats_print_percent3(player.dest2_z, player.dest1_z);
        sprint(self, "ü");

        tot_fired = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
        tot_done = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
        if (player == self)
        {
            sprint(self, "");
            stats_print_percent3(tot_done, tot_fired);
            sprint(self, "‘ü");
        }
        else
        {
            sprint(self, " ");
            stats_print_percent3(tot_done, tot_fired);
            sprint(self, " ü");
        }
        sprint(self, player.netname, "\n");
        player = player.next_player;
    }
};

//
//  S H O W  S U M M A R Y
//
//  Show kill and weapon efficiency for each player.
//
void () stats_show_summary =
{
    local entity player;
    local float wfrac, wtot, kfrac, ktot, useteams;
	local string teamname;

	if ((elohim_state & ELOHIM_MATCH_STARTED) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;

    sprint(self, "kill  - kill efficiency\n");
    sprint(self, "weapn - weapon efficiency\n");
    sprint(self, "\n");
    if (useteams)
    {
        sprint(self, "   team  ükill üweapnü     name\n");
        sprint(self, "­­­­­­­­­«­­­­­«­­­­­«­­­­­­­­­­­­­­­\n");
    }
    else
    {
        sprint(self, "kill üweapnü     name\n");
        sprint(self, "­­­­­«­­­­­«­­­­­­­­­­­­­­­\n");
    }
	player = elohim_sentinel.next_player;

    while (player)
    {
        if (useteams)
		{
			teamname = strings_get_teamname3(player.height);
            sprint(self, teamname, "ü");
		}

        kfrac = player.frags + player.mangle_x + player.mangle_y;
        ktot = kfrac + player.mangle_x + player.mangle_y + player.mangle_z;
        wtot = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
        wfrac = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
        if (player == self)
        {
            sprint(self, "");
            stats_print_percent3(kfrac, ktot);
            sprint(self, "‘ü");
            stats_print_percent3(wfrac, wtot);
            sprint(self, "‘ü");
        }
        else
        {
            sprint(self, " ");
            stats_print_percent3(kfrac, ktot);
            sprint(self, " ü ");
            stats_print_percent3(wfrac, wtot);
            sprint(self, " ü");
        }
        sprint(self, player.netname, "\n");
		player = player.next_player;
    }
};

//
//  A U T O D U M P
//
//  Dump statistics if player has autostats enabled.
//
void () stats_autodump = 
{
	if (self.style & ELOHIM_AUTOSTATS)
	{
		sprint(self, "\n");
		sprint(self, "ãòíïä íáôãè óôáôéóôéãóŸ\n");
		sprint(self, "\n");
		stats_show_summary();
		sprint(self, "\n");
		stats_show_quadstats();
		sprint(self, "\n");
		if ((elohim_playmode & ELOHIM_MATCH_MODE) && teamplay)
		{
			stats_show_badstats();
			sprint(self, "\n");
		}
		stats_show_efficiency();
		sprint(self, "\n");
		stats_show_killstats();
	}
};

//
//  H E L P
//
void () stats_help = 
{
	sprint(self, "Statistics commands:\n");
    sprint(self, " stats      - summarize statistics\n");
    sprint(self, " killstats  - list player kill stats\n");
    sprint(self, " efficiency - list player efficiency\n");
	sprint(self, " quadstats  - list player quad stats\n");
	sprint(self, " badstats   - team game blunders\n");
	sprint(self, " autostats - automatically dump stats\n");
	sprint(self, "             at the end of matches\n");
};	

//
//  I M P U L S E
//
void () stats_impulse = 
{
    if (self.impulse == 170) 
		stats_show_killstats();
    else if (self.impulse == 171)
		stats_show_efficiency();
    else if (self.impulse == 172)
		stats_show_summary();
    else if (self.impulse == 173)
		stats_show_quadstats();
    else if (self.impulse == 174)
		stats_show_badstats();
	else if (self.impulse == 178)
		utils_toggle_flag(ELOHIM_AUTOSTATS, "Autostats");
	else if (self.impulse == 179)
		stats_help();
};

