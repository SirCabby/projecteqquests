sub EVENT_ITEM {
  plugin::return_items(\%itemcount);
}

sub EVENT_SIGNAL {
  quest::say("What a glorious machine the cargo clockwork is!!");
  # The delivery clockwork is an era-split PAIR sharing spawngroup 10056105 (TAKP
  # import): #Cargo_Clockwork 10056009 runs Classic-Luclin, Cargo_Clockwork 56105
  # runs PoP+. Exactly one is ever in the zone, and signalling the absent one is a
  # no-op, so signal both rather than leaving the reply dead at half the eras.
  quest::signal(56105,1);    # NPC: Cargo_Clockwork  (expansion 4-99)
  quest::signal(10056009,1); # NPC: #Cargo_Clockwork (expansion 0-3)
}

