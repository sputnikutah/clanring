//
// quaketv.qc
//
// Handles running commentary.
//

//
//  S O U N D
//
//  Send a sound to all observers with commentary enabled
//
void (string soundname) quaketv_sound = 
{
	local entity o;

	o = find(world, classname, "player");
	while (o)
	{
		if ((o.style & ELOHIM_CONNECTED) && (o.style & ELOHIM_OBSERVER) && (o.oflags & OBSERVER_COMMENTARY))
		{
			stuffcmd(o, "play ");
			stuffcmd(o, soundname);
			stuffcmd(o, "\n");
		}
		o = find(o, classname, "player");
	}
};

//
//  S T U F F C M D
//
//  Stuff a command to all observers with commentary enabled
//
void (string cmd) quaketv_stuffcmd = 
{
	local entity o;

	o = find(world, classname, "player");
	while (o)
	{
		if ((o.style & ELOHIM_CONNECTED) && (o.style & ELOHIM_OBSERVER) && (o.oflags & OBSERVER_COMMENTARY))
			stuffcmd(o, cmd);
		o = find(o, classname, "player");
	}
};

//
//  A N N O U N C E 2
//
//  Print a string to all observers with commentary enabled
//
void (string s1, string s2) quaketv_announce2 = 
{
	local entity o;

	o = find(world, classname, "player");
	while (o)
	{
		if ((o.style & ELOHIM_CONNECTED) && (o.style & ELOHIM_OBSERVER) && (o.oflags & OBSERVER_COMMENTARY))
			sprint(o, s1, s2);
		o = find(o, classname, "player");
	}
};

//
//  A N N O U N C E 3
//
//  Print a string to all observers with commentary enabled
//
void (string s1, string s2, string s3) quaketv_announce3 = 
{
	local entity o;

	o = find(world, classname, "player");
	while (o)
	{
		if ((o.style & ELOHIM_CONNECTED) && (o.style & ELOHIM_OBSERVER) && (o.oflags & OBSERVER_COMMENTARY))
			sprint(o, s1, s2, s3);
		o = find(o, classname, "player");
	}
};

//
//  A N N O U N C E 4
//
//  Print a string to all observers with commentary enabled
//
void (string s1, string s2, string s3, string s4) quaketv_announce4 = 
{
	local entity o;

	o = find(world, classname, "player");
	while (o)
	{
		if ((o.style & ELOHIM_CONNECTED) && (o.style & ELOHIM_OBSERVER) && (o.oflags & OBSERVER_COMMENTARY))
			sprint(o, s1, s2, s3, s4);
		o = find(o, classname, "player");
	}
};

//
//  A N N O U N C E 6
//
//  Print a string to all observers with commentary enabled
//
void (string s1, string s2, string s3, string s4, string s5, string s6) quaketv_announce6 = 
{
	local entity o;

	o = find(world, classname, "player");
	while (o)
	{
		if ((o.style & ELOHIM_CONNECTED) && (o.style & ELOHIM_OBSERVER) && (o.oflags & OBSERVER_COMMENTARY))
			sprint(o, s1, s2, s3, s4, s5, s6);
		o = find(o, classname, "player");
	}
};

//
//  A N N O U N C E  C O N T R O L
//
void (string teamname) quaketv_announce_control = 
{
	quaketv_announce3("The ", teamname, " has control\n");
	quaketv_stuffcmd("playctrl\n");
};

//
//  C H E C K  C O N T R O L
//
//  Check to see if one team has control.
// 
void () quaketv_check_control = 
{
	local entity pteam;

	pteam = elohim_sentinel.next_team;
	while (pteam)
	{
		if (pteam.ammo_rockets > 1)
		{
			if (pteam.ammo_rockets == pteam.count)
			{
				if (pteam.ammo_rockets == elohim_sentinel.ammo_rockets)
					quaketv_announce_control(pteam.netname);
			}
			return;
		}
		pteam = pteam.next_team;
	}
};

//
//  O B T A I N E D  R L
//
void (entity player) quaketv_obtained_rl = 
{
	if (teamplay && (elohim_playmode & ELOHIM_MATCH_MODE))
	{
		player.next_team.ammo_rockets = player.next_team.ammo_rockets + 1;
		elohim_sentinel.ammo_rockets = elohim_sentinel.ammo_rockets + 1;
		if ((player.next_team.ammo_rockets == 1) && (elohim_sentinel.ammo_rockets > 2))
			quaketv_announce2(player.netname, " got a rocket launcher!\n");
		else if (player.next_team.ammo_rockets == elohim_sentinel.ammo_rockets)
		{
			if (player.next_team.count > 1)
			{
				if (player.next_team.count == player.next_team.ammo_rockets)
					quaketv_announce_control(player.next_team.netname);
			}
		}
	}
};

//
//  L O S T  R L
//
void (entity player) quaketv_lost_rl = 
{
	if (teamplay && (elohim_playmode & ELOHIM_MATCH_MODE))
	{
		player.next_team.ammo_rockets = player.next_team.ammo_rockets - 1;
		elohim_sentinel.ammo_rockets = elohim_sentinel.ammo_rockets - 1;
		if (!player.next_team.ammo_rockets && (elohim_sentinel.ammo_rockets > 1))
			quaketv_check_control();
	}
};

//
//  P O W E R U P  O B T A I N E D
//
//  'self' is the powerup;  'other' is the player that got it.
//
void () quaketv_powerup_obtained = 
{
	quaketv_announce2(other.netname, self.noise4);
	quaketv_sound(self.noise);

	if (self.items == IT_INVISIBILITY)
		return;

	// quad and pent only
	if (!(self.owner))
	{
		self.cnt = 1;
		self.count = 1;
	}
	else if (self.owner == other)
	{
		self.cnt = self.cnt + 1;
		self.count = self.count + 1;
	}
	else
	{
		self.count = 1;
		if (teamplay && (elohim_state & ELOHIM_MATCH_STARTED))
		{
			if (other.height == self.height)
				self.cnt = self.cnt + 1;
			else
				self.cnt = 1;
		}
		else
			self.cnt = 1;
	}
	self.owner = other;
	self.height = other.height;

	if (self.cnt > 1)
	{
		local string snum, srd, sthe, sname;
		local float num;
		if (self.count > 1)
		{
			num = self.count;
			sthe = "";
			sname = other.netname;
		}
		else
		{
			num = self.cnt;
			sthe = "the ";
			sname = other.next_team.netname;
		}
		snum = ftos(num);
		if (num > 3)
			srd = "th";
		else if (num == 3)
			srd = "rd";
		else
			srd = "nd";
		quaketv_announce6(snum, srd, " time in a row for ", sthe, sname, "\n");
	}
};