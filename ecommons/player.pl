# Classic East Commonlands (ecommons / zone 22) portal book.
# Clicking the POKTELE500 book statue (doorid 82, inserted by dbmate migration
# commonlands_portal_books) opens a Yes/No confirmation and, on Yes, instantly ports
# the player to REVAMP The Commonlands, landing 10 units south of the return book.

sub EVENT_CLICKDOOR {
    if ($doorid == 82) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the revamped Commonlands. Do you wish to travel to the revamped version of the zone?",
            9005, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9005) {
        # Revamp The Commonlands (zone 408), 10 units south (-Y) of the revamp book
        # at (-2723,-1839), facing north toward it.
        $client->MovePC(408, -2723, -1849, 34, 0);
    }
}
