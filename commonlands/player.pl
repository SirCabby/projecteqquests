# Revamp The Commonlands (commonlands / zone 408) portal book.
# Clicking the POKTELE500 book statue (doorid 82, inserted by dbmate migration
# commonlands_portal_books) opens a Yes/No confirmation and, on Yes, instantly ports
# the player to CLASSIC East Commonlands (ecommons, zone 22), landing 10 units south
# of the return book.

sub EVENT_CLICKDOOR {
    if ($doorid == 82) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with classic East Commonlands. Do you wish to travel to classic East Commonlands?",
            9006, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9006) {
        # Classic East Commonlands (zone 22), 10 units south (-Y) of the classic book
        # at (-330,-1801), facing north toward it.
        $client->MovePC(22, -330, -1811, 4, 0);
    }
}
