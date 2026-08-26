# Steamfont delivery run: the cargo clockwork walks grid 177 to the windmills at 8am
# game time and is ambushed at waypoint 10 by Hector/Renaldo/Jerald, whose severed
# heads (85055-85057) are Jarah Reskan's turn-in in Ak'Anon for the Highway
# Protectors Mask. The bandits have NO spawnentry row -- this script is the only
# thing that puts them in the world, so if it does not run they are unobtainable.
#
# ATTACHED TO TWO NPCs. The TAKP spawn import (20260720000001/4) turned the clockwork
# into an era-split PAIR sharing spawngroup 10056105 -- one point, 100 weight each:
#
#   #Cargo_Clockwork 10056009   spawnentry min/max_expansion 0/3     800hp  AC 108
#    Cargo_Clockwork    56105   spawnentry min/max_expansion 4/99   1200hp  AC 127
#
# EQEmu builds a quest filename from npc_types.name verbatim -- the '#' is NOT
# stripped (quest_parser_collection.cpp GetQIByNPCQuest) -- so this file only ever
# reached 56105 and the whole event was dead below Planes of Power. The sibling
# '#Cargo_Clockwork.pl' is a relative symlink to this file; that is what makes the
# run work at Classic. Keep both rows: retiring either would drag the other era's
# stats and loottable (sprockets/scrap vs gizmos/Clockwork Oil Extract) across the
# era line.

  my $delivery = 0;
  my $bandit1id = 56178;
  my $bandit2id = 56179;
  my $bandit3id = 56180;

sub EVENT_SPAWN {
  quest::settimer("CargoTimer",5);
}

sub EVENT_SIGNAL {
  quest::emote("Chuga.. Chug..Chug..");
  quest::say("This unit requires maintenance.");
}

sub EVENT_TIMER {
  if (!quest::get_data("CargoClockwork") && ($zonehour == 8)) {
    quest::set_data("CargoClockwork", "1", "H2");
    quest::start(177); #Path to windmills
  }
  if ($npc->GetTarget() && ($targetname=~/highway_bandit/i)) {
    $npc->WipeHateList();
  }
}

sub EVENT_WAYPOINT_ARRIVE {
  if ($wp == 1 && $delivery == 1) {
    quest::stop();
    $delivery = 0;
  }
  if ($wp == 8) {
    quest::say("kachunk .. kachunk..");
    quest::signal(56066,1); #Watchman Grep
  }
  if ($wp == 10 && $delivery == 0) {
    $delivery = 1;
    quest::emote("Chuga.. Chug..Chug..");
    quest::emote("The chugging of the Cargo Clockwork comes to a halt.");

    $bandit1 = quest::spawn2($bandit1id,0,0,30,-700,-109,124); #Hector
    $bandit1obj = $entity_list->GetMobID($bandit1);
    $bandit1npc = $bandit1obj->CastToNPC();
    $bandit1npc->AddToHateList($npc,1);

    $bandit2 = quest::spawn2($bandit2id,0,0,95,-732,-108,480); #Renaldo
    $bandit2obj = $entity_list->GetMobID($bandit2);
    $bandit2npc = $bandit2obj->CastToNPC();
    $bandit2npc->AddToHateList($npc,1);

    $bandit3 = quest::spawn2($bandit3id,0,0,53,-615,-107,226); #Jerald
    $bandit3obj = $entity_list->GetMobID($bandit3);
    $bandit3npc = $bandit3obj->CastToNPC();
    $bandit3npc->AddToHateList($npc,1);

    quest::say("This is highway robbery.");
  }
}

sub EVENT_DEATH_COMPLETE {
  quest::stoptimer("CargoTimer");
  $delivery = 0;
  quest::signal($bandit1id,0); #Hector
  quest::signal($bandit2id,0); #Renaldo
  quest::signal($bandit3id,0); #Jerald
}
