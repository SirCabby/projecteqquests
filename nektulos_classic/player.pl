# Classic Nektulos (nektulos_classic / zone 991) portal book.
# Clicking the POKTELE500 book statue (doorid 82, inserted by dbmate migration
# nektulos_portal_books) opens a Yes/No confirmation and, on Yes, instantly ports
# the player to REVAMP Nektulos, landing 10 units south of the return book there.

sub EVENT_CLICKDOOR {
    if ($doorid == 82) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the overhauled Nektulos Forest. Do you wish to travel to the revamped version of the zone?",
            9003, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9003) {
        # Revamp Nektulos (base zone 25 -> v1 static instance via FindZone),
        # 10 units south (-Y) of the revamp book at (394,-1160), facing north toward it.
        $client->MovePC(25, 394, -1170, 4, 0);
    }
}
