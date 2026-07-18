# Revamp North Ro (northro / zone 392) portal book.
# Clicking the POKTELE500 book statue (doorid 82, inserted by dbmate migration
# northro_portal_books) opens a Yes/No confirmation and, on Yes, instantly ports the
# player to CLASSIC North Ro (nro, zone 34), landing 10 units south of the return book.

sub EVENT_CLICKDOOR {
    if ($doorid == 82) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with classic North Ro. Do you wish to travel to the classic version of the zone?",
            9008, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9008) {
        # Classic North Ro (zone 34), 10 units south (-Y) of the classic book at (928,1546).
        $client->MovePC(34, 928, 1536, 5, 0);
    }
}
