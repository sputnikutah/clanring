float (string s1, string s2, void() accept) vote_init;
void () votables_request_change_level;
void () client_select_warp;

void () warp_menu_top =
{
	sprint (self, "\n");
	sprint (self, " \b1\b  Doomed Dimension     \bepisode 1\n");
	sprint (self, " \b2\b  Realm of Black Magic \bepisode 2\n");
	sprint (self, " \b3\b  Netherworld          \bepisode 3\n");
	sprint (self, " \b4\b  Elder World          \bepisode 4\n");
	sprint (self, " \b5\b  ID Deathmatch Arenas \bdm1 - dm6\n");
	sprint (self, " \b6\b  Custom Maps A-C\n");
	sprint (self, " \b7\b  Custom Maps D-P\n");
	sprint (self, " \b8\b  Custom Maps Q-S\n");
	sprint (self, " \b9\b  Custom Maps T-Z\n");
	sprint (self, " \b10\b Rocket Arena Maps    \btop 9   \n");
	sprint (self, " \b11\b Local Server Maps\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map category\n");

};
void () warp_menu_one =
{
	sprint (self, "\n");
	sprint (self, " \b1\b Slipgate Complex      \be1m1\n");
	sprint (self, " \b2\b Castle of the Damned  \be1m2\n");
	sprint (self, " \b3\b Necropolis            \be1m3\n");
	sprint (self, " \b4\b Grisly Grotto         \be1m4\n");
	sprint (self, " \b5\b Gloom Keep            \be1m5\n");
	sprint (self, " \b6\b Door To Chthon        \be1m6\n");
	sprint (self, " \b7\b House of Chthon       \be1m7\n");
	sprint (self, " \b8\b Ziggurat Vertigo      \be1m8\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};
void () warp_menu_two=
{
	sprint (self, "\n");
	sprint (self, " \b1\b Installation            \be2m1\n");
	sprint (self, " \b2\b Ogre Citadel            \be2m2\n");
	sprint (self, " \b3\b Crypt of Decay          \be2m3\n");
	sprint (self, " \b4\b Ebon Fortress           \be2m4\n");
	sprint (self, " \b5\b Wizard's Manse          \be2m5\n");
	sprint (self, " \b6\b Dismal Oubliette        \be2m6\n");
	sprint (self, " \b7\b Underearth              \be2m7\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");

	sprint (self, "select map\n");
};
void () warp_menu_three=
{
	sprint (self, "\n");
	sprint (self, " \b1\b Termination Central     \be3m1\n");
	sprint (self, " \b2\b Vaults of Zin           \be3m2\n");
	sprint (self, " \b3\b Tomb of Terror          \be3m3\n");
	sprint (self, " \b4\b Satan's Dark Delight    \be3m4\n");
	sprint (self, " \b5\b Wind Tunnels            \be3m5\n");
	sprint (self, " \b6\b Chambers of Torment     \be3m6\n");
	sprint (self, " \b7\b Haunted Halls           \be3m7\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};
void () warp_menu_four=
{
	sprint (self, "\n");
	sprint (self, " \b1\b Sewage System           \be4m1\n");
	sprint (self, " \b2\b Tower of Despair        \be4m2\n");
	sprint (self, " \b3\b Elder God Shrine        \be4m3\n");
	sprint (self, " \b4\b Palace of Hate          \be4m4\n");
	sprint (self, " \b5\b Hell's Atrium           \be4m5\n");
	sprint (self, " \b6\b Pain Maze               \be4m6\n");
	sprint (self, " \b7\b Azure Agony             \be4m7\n");
	sprint (self, " \b8\b Nameless City           \be4m8\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};
void () warp_menu_five=
{
	sprint (self,"\n");	
	sprint (self, " \b1\b Place of Two Deaths     \bdm1\n");
	sprint (self, " \b2\b Claustrophobopolis      \bdm2\n");
	sprint (self, " \b3\b Abandoned Base          \bdm3\n");
	sprint (self, " \b4\b Bad Place               \bdm4\n");
	sprint (self, " \b5\b Cistern                 \bdm5\n");
	sprint (self, " \b6\b Dark Zone               \bdm6\n");
	sprint (self, " \b7\b Introduction            \bstart\n");
	sprint (self, " \b8\b Shub-Niggurath's Pit    \bend\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};
void () warp_menu_six =
{
	sprint (self,"\n");
	sprint (self, " \b1\b a2        \bReturn to Atlantis\n");
	sprint (self, " \b2\b aerowalk  \bAerowalk\n");
	sprint (self, " \b3\b agent     \bAgent Orange\n");
	sprint (self, " \b4\b alk08dm   \bCharmhood\n");
	sprint (self, " \b5\b auhdm2    \bPainful Memories\n");
	sprint (self, " \b6\b baldm6    \bScrap Metal\n");
	sprint (self, " \b7\b baldm8    \bDying Embers\n");
	sprint (self, " \b8\b bomberman \bBizarro Bomberman\n");
	sprint (self, " \b9\b bsp       \bBlood, Sweat and Piss\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};

void () warp_menu_seven =
{
	sprint (self, "\n");
	sprint (self, " \b1\b dranzdm8   \bTeardrop\n");
	sprint (self, " \b2\b endif      \bEndif\n");
	sprint (self, " \b3\b factory3   \bBajunin's Place\n");
	sprint (self, " \b4\b fragtwn7   \bFragtown 7 - Chicago\n");
	sprint (self, " \b5\b hipdm1     \bThe Edge of Oblivion\n");
	sprint (self, " \b6\b lacrima    \bLacrima Christi\n");
	//sprint (self, " \b7\b nindm3v2   \bDeja Vu\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};

void () warp_menu_eight =
{
	sprint (self, "\n");
	sprint (self, " \b1\b q1dm17     \bThe Longest Yard\n");
	sprint (self, " \b2\b q1edge     \bThe Edge Conversion\n");
	sprint (self, " \b3\b q3dm6qw    \bThe Campgrounds\n");
	sprint (self, " \b4\b rf2        \bRusted Factory\n");
	sprint (self, " \b5\b rm         \bRuby Midnight\n");
	sprint (self, " \b6\b sanity     \bWhen Sanity Ends\n");
	sprint (self, " \b7\b schloss    \bSchloss Adler\n");
	sprint (self, " \b8\b skull      \bSkull Hunt\n");
	sprint (self, " \b9\b sofdm1     \bSoldier of Fortune DM1\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};

void () warp_menu_nine =
{
	sprint (self,"\n");
	sprint (self, " \b1\b toilet4    \bSani-Flush\n");
	sprint (self, " \b2\b ultrav     \bUltraviolence\n");
	sprint (self, " \b3\b xntrick    \bTrick or Treat!\n");
	sprint (self, " \b4\b zed2       \bMetalWare\n");
	sprint (self, " \b5\b ztndm3     \bBlood Run\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self,"\n");
	sprint (self, "select map\n");
};

void () warp_menu_ten =
{
	sprint (self, "\n");
	sprint (self, " \b1\b terrain2 \b\n");
	sprint (self, " \b2\b arenax   \b\n");
	sprint (self, " \b3\b yard1    \b\n");
	sprint (self, " \b4\b uarena1  \b\n");
	sprint (self, " \b5\b arenazap \b\n");
	sprint (self, " \b6\b arma4    \b\n");
	sprint (self, " \b7\b bunski   \b\n");
	sprint (self, " \b8\b arenarg4 \b\n");
	sprint (self, " \b9\b basarena \b\n");
	sprint (self, " ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};

void () warp_menu_eleven=
{
	local float index;
	local string name,number;

	sprint (self,"\n");
	index = 0;
	while ((index < 10))
	{
		name = array_get_user_map (index);
		number = strings_ftos_gold((index+1));
		if ((name != ""))
		{
			//sprint (self, " ", name, "\n");
			sprint(self," ",number," ",name,"\n");
		}
		index = (index + 1);
	}

	sprint (self," ’ \bEXIT\n");
	sprint (self, "\n");
	sprint (self, "select map\n");
};

/*
void () warp_menu_ten=
{
sprint (self,"\n");
sprint (self," “ \n");
sprint (self," ” \n");
sprint (self," • \n");
sprint (self," – \n");
sprint (self," — \n");
sprint (self," ˜ \n");
sprint (self," ™ \n");
sprint (self," š \n");
sprint (self," › \n");
sprint (self," ’ \bEXIT\n");
sprint (self, "\n");
sprint (self, "select map\n");
};

void () warp_menu_eleven=
{
sprint (self,"\n");
sprint (self," “ \n");
sprint (self," ” \n");
sprint (self," • \n");
sprint (self," – \n");
sprint (self," — \n");
sprint (self," ˜ \n");
sprint (self," ™ \n");
sprint (self," š \n");
sprint (self," › \n");
sprint (self," ’ \bEXIT\n");
sprint (self, "\n");
sprint (self, "select map\n");
};
*/

void () select_map =

{
	if (!(self.impulse >= 230) && (self.impulse <= 245)) return;


	if ((self.finaldest_z==0)&&(self.warp_map==0))
	{
		sprint (self,"\bCanceled\n");
		self.use=SUB_Null;
		self.warp_map=0;
		self.warp_episode=0;
	}
	else
	{
		if (self.finaldest_z==1)
		{
			self.warp_map=1;
			client_select_warp();
		}
		else
		{
			if (self.finaldest_z==2)
			{
				self.warp_map=2;
				client_select_warp();
			}
			else
			{
				if (self.finaldest_z==3)
				{
					self.warp_map=3;
					client_select_warp();
				}
				else
				{
					if (self.finaldest_z==4)
					{
						self.warp_map=4;
						client_select_warp();
					}
					else
					{
						if (self.finaldest_z==5)
						{
							self.warp_map=5;
							client_select_warp();
						}
						else
						{
							if (self.finaldest_z==6)
							{
								self.warp_map=6;
								client_select_warp();
							}
							else
							{
								if (self.finaldest_z==7)
								{
									self.warp_map=7;
									client_select_warp();
								}
								else
								{
									if (self.finaldest_z==8)
									{
										self.warp_map=8;
										client_select_warp();
									}
									else
									{
										if (self.finaldest_z==9)
										{
											self.warp_map=9;
											client_select_warp();
										}
										else
										{
											if (self.finaldest_z==10)
											{
												self.warp_map=10;
												client_select_warp();
											}
											else
											{
												if (self.finaldest_z==11)
												{
													self.warp_map=11;
													client_select_warp();
												}
												else
												{
													sprint (self,"\bcanceled\n");
													self.use=SUB_Null;
													self.warp_map=0;
													self.warp_episode=0;
												}
											}//11
										}//10
									}//9
								}//8
							}//7
						}//6
					}//5
				}//4
			}//3
		}//2
	}//1
	self.use=SUB_Null;
};

void () select_episode =

{
	if ((self.finaldest_z==0)&&(self.warp_episode==0))
	{
		sprint (self,"\bCanceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}

	else
	{
		if (self.finaldest_z==1)
		{
			warp_menu_one();
			self.warp_episode=1;
			self.use=select_map;
		}

		else
		{
			if (self.finaldest_z==2)
			{
				warp_menu_two();
				self.warp_episode=2;
				self.use=select_map;
			}

			else
			{
				if (self.finaldest_z==3)
				{
					warp_menu_three();
					self.warp_episode=3;
					self.use=select_map;
				}

				else
				{
					if (self.finaldest_z==4)
					{
						warp_menu_four();
						self.warp_episode=4;
						self.use=select_map;
					}

					else
					{
						if (self.finaldest_z==5)
						{
							warp_menu_five();
							self.warp_episode=5;
							self.use=select_map;
						}

						else
						{
							if (self.finaldest_z==6)
							{
								warp_menu_six();
								self.warp_episode=6;
								self.use=select_map;
							}
							else
							{
								if (self.finaldest_z==7)
								{
									warp_menu_seven();
									self.warp_episode=7;
									self.use=select_map;
								}
								else
								{
									if (self.finaldest_z==8)
									{
										warp_menu_eight();
										self.warp_episode=8;
										self.use=select_map;
									}
									else
									{
										if (self.finaldest_z==9)
										{
											warp_menu_nine();
											self.warp_episode=9;
											self.use=select_map;
										}
										else
										{
											if (self.finaldest_z==10)
											{
												warp_menu_ten();
												self.warp_episode=10;
												self.use=select_map;
											}
											else
											{
												if (self.finaldest_z==11)
												{
													warp_menu_eleven();
													self.warp_episode=11;
													self.use=select_map;
												}
												else
												{	
													sprint (self,"canceled\n");
													self.use=SUB_Null;
													self.warp_episode=0;
													return;
												}
											}
										}
									}//1
								}//2
							}//3
						}//4
					}//5
				}//6
			}//7
		}//8
	}//9
};


void () client_select_warp =
{
	if (elohim_levelcount != CONTENT_EMPTY)
	{
		sprint(self, "Wait for map to initialize\n");
		sprint (self,"\bcanceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}
	if (elohim_state & ELOHIM_MATCH_STARTED)
	{
		sprint(self, "Cannot change level while match is in progress.\n");
		sprint (self,"\bcanceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}

	if (!self.warp_episode)
	{
		warp_menu_top();
		self.use=select_episode;
	}

	if (self.warp_map)
	{
		self.warp_map=(self.finaldest_z);
		votables_request_change_level();
	}
};
