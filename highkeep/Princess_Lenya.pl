#Princess_Lenya.pl
#Thex Dagger quest (High Keep) -- Princess Lenya, the imprisoned princess.
#Two turn-ins, matching the classic EQMac chain (adapted to route both through
#this persistent NPC rather than a second spawn):
#  * Tearon's Bracer (13108)      -> upgraded Tearon's Bracer (13112). Return to Tearon.
#  * Royal Amulet of Thex (13109) -> Sealed Letter (18841), gated by the
#    Classic_OldWorldDrops legacy toggle. Take the letter to Tolon Nurbyte in
#    North Felwithe (ask Inkeeper Freegraze for him).
#These do not interfere with the separate Silent Watch Shield quest, which uses
#the same amulet + the Highkeep Royal Suite key at Tearon.
# items: 13108, 13112, 13109, 18841
sub EVENT_SAY {
  if ($text =~/hail/i) {
    quest::say("Are not you a little short for a Highpass Guard? If Tearon of the Silent Watch sent you, show me his bracer and I may yet trust you.");
  }
}

sub EVENT_ITEM {
  # Bracer upgrade (proof of the Silent Watch) -- always available
  if (plugin::check_handin(\%itemcount, 13108 => 1)) { # Tearon's Bracer
    quest::say("So you are of the Silent Watch. They accept anyone these days. Here is the bracer, prepared -- take it back to Tearon. Thank you for unlocking the door.");
    quest::summonitem(13112); # Tearon's Bracer (upgraded)
    quest::ding();
  }
  # Amulet -> Sealed Letter (Thex Dagger path; legacy toggle)
  elsif (quest::is_content_flag_enabled("Classic_OldWorldDrops") && plugin::check_handin(\%itemcount, 13109 => 1)) { # Royal Amulet of Thex
    quest::say("The Royal Amulet of Thex!! I had feared it lost. Take this sealed letter as proof of my rescue, and bear it to Tolon Nurbyte at the Traveler's Home in North Felwithe -- the innkeeper will point you to him.");
    quest::summonitem(18841); # Sealed Letter
    quest::ding();
    quest::faction(226,10); # Clerics of Tunare
    quest::faction(279,10); # King Tearis Thex
  }
  plugin::return_items(\%itemcount);
}
#END of FILE Zone:highkeep  ID:10006006 -- Princess_Lenya
