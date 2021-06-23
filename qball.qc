void (float qt) StartQballSpawn;
void () StartQItem;
void () vote_impulse;

void () item_qball =
{
	self.classname = "IT_QBALL";
	
	if (maphasqball == TRUE)
		remove(self);
};

/*
============
PlaceItem

plants the object on the floor
============
*/
void() PlaceQItem =
{
	local float	oldz;

	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity -= self.velocity; //'0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;

	if (!(droptofloor()))
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}
};

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartQItem =
{
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceQItem;
};

entity() FindQballSpawnPoint =
{
	if (qballspawn == world)
	qballspawn = spawn();

	//R00k: hardcoded spawns should go here!!, not in spawns.qc
	if (world.model == "maps/ctf8.bsp")
	{
		qballspawn.origin = '95.4 217.9 260';
		maphasqball = TRUE;
		return qballspawn;
	}

	if (world.model == "maps/dm6.bsp")
	{
		qballspawn.origin = '1029 -1091 358';
		maphasqball = TRUE;
		return qballspawn;
	}

	if (world.model == "maps/dm3.bsp")
	{
		qballspawn.origin = '580.6 -44.1 -170';
		maphasqball = TRUE;
		return qballspawn;
	}

	if (world.model == "maps/wet3.bsp")
	{
		qballspawn.origin = '408 14 24';
		maphasqball = TRUE;
		return qballspawn;
	}

	if (world.model == "maps/elder.bsp")
	{
		qballspawn.origin = '6 10 42';
		maphasqball = TRUE;
		return qballspawn;
	}

	qballspawn = find(world, classname, "item_qball");//check for old map support
	if (qballspawn != world) return qballspawn;

	qballspawn = find(world, classname, "item_artifact_super_damage");
	if (qballspawn != world) return qballspawn;

	if (qballspawn == world)
	qballspawn = find (world, classname, "item_artifact_invulnerability");
	if (qballspawn != world) return qballspawn;

	if (qballspawn == world)
	qballspawn = find (world, classname, "item_artifact_invisibility");
	if (qballspawn != world) return qballspawn;

	if (qballspawn == world)
	qballspawn = find (world, classname, "item_artifact_envirosuit");
	if (qballspawn != world) return qballspawn;

	if (qballspawn == world)
	qballspawn = find (world, classname, "info_player_deathmatch");
	if (qballspawn != world) return qballspawn;

	if (qballspawn == world)
	error("no info_player_deathmatch to spawn qball");

	if (qballspawn != world) return qballspawn;

	return world;
};

void() s_explode1;

void() KillQball =
{
	local entity ballboom,tmp;

	ballboom = find(world,classname,"IT_QBALL");

	if (ballboom != world)
	{
		ballboom.movetype = MOVETYPE_NONE;
		ballboom.velocity = '0 0 0';
		ballboom.touch = SUB_Null;
		ballboom.solid = SOLID_NOT;

		tmp=self;
		self=ballboom;
		remove(self);
		self=tmp;
	}
	StartQballSpawn(5);
};

void() QballRespawn;

void() QballTouch =
{
	//self is the ball
	//other is the person picking it up

	//local float dir;

	if (!(elohim_state & ELOHIM_MATCH_STARTED))
		return;

	if ((other == self.owner) && ((self.nextthink - time) > 29.75)) //This delays the touch if we JUST tossed it, though an exploit is to face a wall and u can pass the ball thru the player :O
	return;

	if (other.classname == "player")
	{
		if (!other.health) return;

		if (other.weapon != IT_AXE)
		{
			if (other.qball_times_touched < 5 )
			centerprint(other,"\bselect\b axe \bto take the\b ball");
			return;
		}
	}

	if (!(other.flags & FL_CLIENT)) return;

	if (other.classname != "player") return;

	sound (other, CHAN_WEAPON, "misc/medkey.wav", 0.8, ATTN_NORM);	//take sound

	other.qball_times_touched = other.qball_times_touched + 1;

	
	other.weapon      = IT_AXE;
	other.currentammo = 0;
	other.weaponmodel = "progs/v_axe.mdl";
	other.weaponframe = 0;
	//********************************************
	other.style = (other.style | SPEEDBALL_CARRIER);

	other.effects = (other.effects | EF_BRIGHTFIELD);// give them glowing dots

	//--------------update some messages
	if (self.owner != other)
	{
		if (self.owner.next_team == other.next_team)
		{
			if (self.lip==1) bprint(self.owner.netname," passes the \bball\b to ",other.netname,"\n");
			if (self.lip==2) bprint(other.netname," recovered the \bball\b!\n");
		}
		else
		{
			if (self.lip==1)
			{
				bprint(other.netname," stole the \bball\b from ",self.owner.netname,"!\n");
			}

			if (self.lip==2)
			{
				bprint(other.netname," takes the \bball\b from ",self.owner.netname,"\n");
			}
		}
	}
	//--------------
	remove(self);// remove the entity of the qball

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() Do_PlaceQball;

void() QballRespawn =
{
	local entity oself;

	if (gameover) return;

	if ((self.owner == world) && (self.lip == 0)) return;//at base

	oself = self;
	self = FindQballSpawnPoint();
	Do_PlaceQball();

	remove(oself);
};


void(entity whotoss) TossQball =
{
	local entity	item;
	local string temp;

	if (self.health<1) return;

	self.effects = self.effects - (self.effects & EF_BRIGHTFIELD);
	self.style = (self.style - (self.style & SPEEDBALL_CARRIER));

	item           	= spawn();
	item.classname	= "IT_QBALL";
	item.owner	= whotoss;
	item.solid	= SOLID_TRIGGER;
	item.movetype  	= MOVETYPE_BOUNCE;

	sound (self, CHAN_BODY, "hknight/hit.wav", 1, ATTN_NORM);	// play respawn sound

	makevectors (self.v_angle);

	item.velocity = whotoss.velocity;
	item.velocity = aim(self, 10000);

	if ((whotoss.button0) || (whotoss.button2))//fire or jump
	item.velocity = item.velocity * 800;//<-- power toss speed
	else
	item.velocity = item.velocity * 525;//<-- normal toss speed

	//setorigin(item, self.origin + (v_forward*16) + '0 0 16'); //wallpass
	setorigin(item, self.origin +'0 0 16');//no wallpass
	item.angles   = vectoangles(item.velocity);
	item.effects  = (item.effects | EF_BRIGHTFIELD);
	item.flags    = FL_ITEM;
	item.weapon   = IT_AXE;
	item.lip      = 1.00;//this is a flag for tossed not dropped
	item.touch     = QballTouch;
	item.think     = QballRespawn;
	item.nextthink = time + 30;
	setsize (item, '-16 -16 -24', '16 16 32');
	setmodel (item, "progs/s_light.spr");

	temp       = ftos(whotoss.height);
	msg_entity = whotoss;

	WriteByte(MSG_ONE, SVC_STUFFCMD);
	WriteString(MSG_ONE, "color ");
	WriteByte(MSG_ONE, SVC_STUFFCMD);
	WriteString(MSG_ONE, temp);
	WriteByte(MSG_ONE, SVC_STUFFCMD);
	WriteString(MSG_ONE, "\n");

};

void (entity whodrop, float kick) Do_DropQball =
{
	local entity	item;

	item = spawn();
	item.owner=whodrop;

	if (kick == 0) item.owner = item;

	item.classname="IT_QBALL";
	setorigin(item, self.origin + '0 0 16');

	makevectors (self.v_angle);

	item.velocity = aim(self,1000);
	item.velocity = (item.velocity * (500+kick));
	item.angles = vectoangles(item.velocity);
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
	item.effects = (item.effects | EF_BRIGHTFIELD);
	item.weapon = IT_AXE;
	item.lip = 2;//ball was dropped

	setsize (self, '-16 -16 -24', '16 16 32');
	setmodel (item, "progs/s_light.spr");
	item.touch = QballTouch;
	item.nextthink = time + 30;
	item.think = QballRespawn;
};

void () Do_PlaceQball =
{
	local entity	item;
	item = spawn();
	item.owner = world;
	item.origin = self.origin;
	item.origin_z = item.origin_z + 24;
	item.velocity = '0 0 0';
	item.classname="IT_QBALL";
	item.effects = (item.effects | EF_DIMLIGHT);
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.weapon = IT_AXE;
	item.lip = 0.00; //ball respawned to primary
	setsize (self, '-16 -16 -24', '16 16 32');
	setmodel (item, "progs/s_light.spr");
	item.touch = QballTouch;
	item.nextthink = time + 30;
	item.think = QballRespawn;
	bprint("the \bball\b has spawned.\n");
};

void(float kval) DropQball =
{
	local string temp;
	self.effects = self.effects - (self.effects & EF_BRIGHTFIELD);
	self.style = (self.style - (self.style & SPEEDBALL_CARRIER));

	temp = ftos(self.height);
	msg_entity=self;
	WriteByte(MSG_ONE, SVC_STUFFCMD);
	WriteString(MSG_ONE, "color ");
	WriteByte(MSG_ONE, SVC_STUFFCMD);
	WriteString(MSG_ONE, temp);
	WriteByte(MSG_ONE, SVC_STUFFCMD);
	WriteString(MSG_ONE, "\n");

	Do_DropQball(self,kval);
};

void() SpawnQball =
{
	local entity oself;

	oself = self;
	self = FindQballSpawnPoint();
	Do_PlaceQball();

	remove(oself);
};

void(float qt) StartQballSpawn =
{
	local entity ball;

	ball = spawn();

	ball.nextthink = time + qt;

	ball.think = SpawnQball;
};

void() WhereBall =
{
	local entity ballat;

	ballat = world;

	ballat = find (world,classname, "IT_QBALL");

	if (ballat != world)
	{
		if (ballat.lip==0) sprint(self,"The \bball\b is at spawnpoint.\n");

		if (ballat.lip==1)
		{
			if (ballat.velocity=='0 0 0') sprint(self,"The \bball\b has landed elsewhere.\n");
			if (ballat.velocity) sprint(self,"The \bball\b is hurling through space.\n");
		}

		if (ballat.lip==2)
		{
			if (ballat.velocity=='0 0 0') sprint(self,"The \bball\b has been dropped.\n");
			if (ballat.velocity) sprint(self,"The \bball\b is bouncing around.\n");
		}
	}
	else
	if (ballat == world)
	{
		ballat = find (world,classname, "player");
		while (ballat !=world)//found a player
		{
			if (ballat.style & SPEEDBALL_CARRIER)//does player have the ball?
			{
				sprint(self, ballat.netname);
				sprint(self, " has the \bball\b.\n");
				//return;//found him, print, now exit the loop
			}
			ballat = find (ballat,classname, "player");//look again for ball carrier
		}
	}
	else
	sprint (self, " the world ate the ball.\n");

};

void (entity client, float fragval) client_frag; // ELOHIM_MOD

void () GoalTouch =
{
	local string temp;

	if (!(other.style & SPEEDBALL_CARRIER)) return; // that should take care of every thing else
	else
	{
		if (other.height == self.height) //check for opposite team
		{
			centerprint(other,"\bWRONG GOAL!\b\ntake the ball to the opponent's base!");
			return;
		}

		if (other.height != self.height)
		{
			sound (world, CHAN_AUTO, self.noise, 1, ATTN_NONE);

			if (other.height == 3)
			{
				bprint(other.netname," scores for the \bRED\b team!\n");
			}
			else
			{
				bprint(other.netname," scores for the BLUE team!\n");
			}

			//--remove qball ownership
			other.effects = other.effects - (other.effects & EF_BRIGHTFIELD);
			other.style = (other.style - (other.style & SPEEDBALL_CARRIER));

			temp = ftos(other.height);
			msg_entity=other;
			WriteByte(MSG_ONE, SVC_STUFFCMD);
			WriteString(MSG_ONE, "color ");
			WriteByte(MSG_ONE, SVC_STUFFCMD);
			WriteString(MSG_ONE, temp);
			WriteByte(MSG_ONE, SVC_STUFFCMD);
			WriteString(MSG_ONE, "\n");

			//reward the team
			client_frag(other, 10);
			KillQball();
		}
	}
};

//Use CTF spawnpoints

void() item_flag_team1 =
{
	if (mode_speedball())
	{
		self.height = 3;

		self.origin_z = self.origin_z + 24;

		self.touch = GoalTouch;
		precache_sound ("items/protect2.wav");
		self.noise = "items/protect2.wav";
		precache_model ("progs/invulner.mdl");
		setmodel (self, "progs/invulner.mdl");
		self.effects = self.effects | EF_DIMLIGHT;
		self.effects = self.effects | EF_RED;
		self.items = IT_INVULNERABILITY;
		setsize (self, '-16 -16 -24', '16 16 32');
		StartQItem ();
	}
};

void() item_flag_team2 =
{
	if (mode_speedball())
	{
		self.height = 12;

		self.origin_z = self.origin_z + 24;

		self.touch = GoalTouch;
		self.effects = self.effects | EF_DIMLIGHT;
		self.effects = self.effects | EF_BLUE;
		precache_sound ("items/damage2.wav");
		self.noise = "items/damage2.wav";
		precache_model ("progs/quaddama.mdl");
		setmodel (self, "progs/quaddama.mdl");
		self.items = IT_QUAD;
		setsize (self, '-16 -16 -24', '16 16 32');
		StartQItem ();
	}
};
