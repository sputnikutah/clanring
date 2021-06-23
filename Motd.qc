//
// Motd.qc
//
// Message of the day code.  I created a whole new file so that it would
// be easier to beef up the motd.
//
// All code by J.P. Grossman unless otherwise commented.
//

string motd_top1;
string motd_top2;

//
//  I N I T  W O R L D
//
//  Initialize the motd strings
//
void () motd_init_world =
{
    motd_top1 = "ClanRing CRMod++ v5.2 Quake Competition Server\n";
    motd_top2 = "\nWritten by J.P. Grossman and Paul Baker\n\bhttp://www.crmod.com\n\n\n";
};

void () motd_think =
{
	if (self.count == 0)
	{
		if (self.owner.style & ELOHIM_MOTD)
		{
			remove(self);
			return;
		}
		self.owner.button0 = 0;
	}

    self.owner.style = self.owner.style | ELOHIM_MOTD;
	// Remove the MOTD on fire or jump
	if (self.owner.button0 || self.owner.button2)
	{
		remove(self);
		return;	
	}

    if (self.count < 240)
    {	
		centerprint(self.owner, motd_top1,motd_top2);
		self.count = self.count + 1;
		self.nextthink = time + 0.1;
	}
	else
	{
		remove(self);
	}
};

//
//  C R E A T E
//
//  Create an entity to display the MOTD for 5 seconds (plus a bit).
//
void () motd_create =
{
    local entity intro;
	
	if (elohim_state & ELOHIM_MATCH_PAUSED)
		return;

    intro = utils_make_scheduled_event(motd_think, 0.5);
    intro.count = 0;
};


