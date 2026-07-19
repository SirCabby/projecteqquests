# Feerrott portal book -> REVAMP Cazic-Thule ("Accursed Temple").
# Clicking the POKTELE500 book statue on the temple ledge (doorid 78, inserted
# by dbmate migration feerrott_cazicthule_revamp_book) opens a Yes/No
# confirmation and, on Yes, ports the player into the REVAMPED Cazic-Thule --
# zone 48 version 1, served by global static instance 25. FindZone cannot
# route there (the v1 zone row is content-flag-gated so classic CT stays the
# default), so this uses MovePCInstance rather than MovePC. Arrival = the
# stock zone-in spot inside the temple; walking back out returns to normal
# Feerrott (CT v1's exit zone point carries target_instance 0), landing beside
# this book.

sub EVENT_CLICKDOOR {
    if ($doorid == 78) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the temple as it stands in a later age. Do you wish to travel to the Accursed Temple of Cazic-Thule?",
            9016, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9016) {
        # Revamp CT: zone 48, global static instance 25, stock zone-in
        # coords/heading from the feerrott #3 zone point target.
        $client->MovePCInstance(48, 25, -38.1, 71.4, 1.9, 122);
    }
}
