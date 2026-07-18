sub EVENT_TASK_STAGE_COMPLETE {
  if (($task_id == 154) && ($activity_id == 2)) { #Black Eggs for Breakfast Step 2
    $client->Message(15, "It looks like you made an impression on the other hunters and you won! They're more than excited about asking you along for their next hunt. Here is your prize!");
  }
}

# Revamp Nektulos (nektulos / zone 25, v1) portal book.
# Clicking the POKTELE500 book statue (doorid 82, inserted by dbmate migration
# nektulos_portal_books) opens a Yes/No confirmation and, on Yes, instantly ports
# the player to CLASSIC Nektulos (the nektulos_classic clone, zone 991), landing
# 10 units south of the return book there.
sub EVENT_CLICKDOOR {
    if ($doorid == 82) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with classic Nektulos Forest. Do you wish to travel to the classic version of the zone?",
            9004, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9004) {
        # Classic Nektulos clone (zone 991), 10 units south (-Y) of the classic
        # book at (399,-1086), facing north toward it.
        $client->MovePC(991, 399, -1096, -5, 0);
    }
}