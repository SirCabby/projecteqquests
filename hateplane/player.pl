# Classic Plane of Hate exit book -> back to Oasis.
# Clicking the POKTELE500 book statue at the zone-in (doorid 1, inserted by
# dbmate migration hateplane_exit_book) offers a Yes/No confirmation and, on
# Yes, returns the player to Oasis 10 units south of the Plane of Hate entry
# book there (oasis doorid 21), facing north toward it.

sub EVENT_CLICKDOOR {
    if ($doorid == 1) {
        # (title, text, popup_id, buttons=1 => Yes/No). Only "Yes" fires
        # EVENT_POPUPRESPONSE; "No" / the titlebar X / ESC all decline.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the sands of Oasis. Do you wish to leave the Plane of Hate?",
            9022, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9022) {
        # Oasis (37), 10 south of the entry book at (-185, -216).
        $client->MovePC(37, -185, -226, -1, 0);
    }
}
