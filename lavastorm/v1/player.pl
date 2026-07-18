sub EVENT_TASK_STAGE_COMPLETE {
  if($task_id == 1947 && $activity_id == 4) {
    $client->Message(15,"You really didn't know those who you were forced to slay, did you? No matter, they needed to go anyway, and you just happened to be the object of their demise. You did a clean, thorough job and you should be proud of the work you did. Here's a bit of a reward for the nightmares you're bound to have from this. Try to sleep soundly.");
  }
}

# Revamp Lavastorm (lavastorm / zone 27, v1) portal book.
# Clicking the POKTELE500 book statue (doorid 22, inserted by dbmate migration
# lavastorm_portal_books) opens a Yes/No confirmation and, on Yes, instantly
# ports the player to CLASSIC Lavastorm (the lavastorm_classic clone, zone 990),
# landing 5 units south of the return book there.
sub EVENT_CLICKDOOR {
    if ($doorid == 22) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with classic Lavastorm. Do you wish to travel to the classic version of the zone?",
            9002, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9002) {
        # Classic Lavastorm clone (zone 990), 10 units south (-Y) of the classic
        # book at (1279,1263), facing north toward it.
        $client->MovePC(990, 1279, 1253, 57, 0);
    }
}