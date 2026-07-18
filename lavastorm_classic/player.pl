# Classic Lavastorm (lavastorm_classic / zone 990) portal book.
# Clicking the POKTELE500 book statue (doorid 5, inserted by dbmate migration
# lavastorm_portal_books) opens a Yes/No confirmation and, on Yes, instantly
# ports the player to REVAMP Lavastorm, landing 5 units south of the return book
# there so they arrive beside the portal back.

sub EVENT_CLICKDOOR {
    if ($doorid == 5) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the overhauled Lavastorm. Do you wish to travel to the revamped version of the zone?",
            9001, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9001) {
        # Revamp Lavastorm (base zone 27 -> v1 static instance via FindZone),
        # 10 units south (-Y) of the revamp book at (620,371), facing north toward it.
        $client->MovePC(27, 620, 361, -29, 0);
    }
}
