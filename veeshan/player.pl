# Veeshan's Peak player handlers (shared by v0 classic VP 1.0 and the parked
# v1 revamp instance -- quest scripts are per zone NAME, not per version).
#
# Doors 56/57: Phara Dar's sealed lair -- opens only once the five wing
# dragons are dead. The stock script checked only the VP 2.0 npc ids (108xxx);
# those spawn2 rows now live on version 1, so in classic v0 it always read
# "all dragons dead" and the seal was permanently open. Check BOTH id sets:
# the TAKP classic 1.0 imports (90000xx, spawn only in v0) and the VP 2.0 ids
# (108xxx, spawn only in the v1 instance) -- whichever version this zone
# process is running, only its own dragons can be up.
#
# Door 240: click-to-activate exit pad at the zone-in (added by dbmate
# migration veeshan_entrance_exit_pad) -- instant return to Skyfire Mountains
# beside the VP entry ring. No popup; pads act immediately.

sub EVENT_CLICKDOOR {
  my $dragonsup = 0;
  # (classic 1.0 id, revamp 2.0 id, hard-retune id) per dragon. Only one era's
  # set can spawn in any given version (v0 classic / v1 = 2.0 / v2 = hard) --
  # NOTE the stock 1080xx ids are the LEVEL-70 HARD variants; 2.0 is 1085xx.
  my @dragons = (
    [9000028, 108511, 108053], # Xygoz
    [9000029, 108512, 108040], # Druushk
    [9000030, 108513, 108047], # Nexona
    [9000031, 108517, 108043], # Hoshkar
    [9000026, 108509, 108050], # Silverwing
  );
  foreach my $d (@dragons) {
    if ($entity_list->IsMobSpawnedByNpcTypeID($d->[0]) || $entity_list->IsMobSpawnedByNpcTypeID($d->[1]) || $entity_list->IsMobSpawnedByNpcTypeID($d->[2])) {
      $dragonsup++;
    }
  }
  if ($doorid == 56 || $doorid == 57) {
    if ($dragonsup == 0) {
      $client->Message(0,"You got the door open.");
      quest::forcedooropen(56);
      quest::forcedooropen(57);
    }
    else {
      $client->Message(0,"A seal has been placed on this door by Phara Dar. Perhaps there is a way to remove it.");
    }
  }
  elsif ($doorid == 240) {
    # Entrance exit pad -> Skyfire Mountains beside the VP entry ring.
    $client->MovePC(91, 2978.9, 2763.75, -77, 0);
  }
}
