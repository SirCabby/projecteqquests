# Dawnshroud Peaks portal book -> REVAMP Grieg's End.
# Clicking the POKTELE500 book statue by the Grieg's End zone line (doorid 14,
# inserted by dbmate migration dawnshroud_griegsend_revamp_book) opens a Yes/No
# confirmation and, on Yes, ports the player into the REVAMPED Grieg's End --
# zone 163 version 1, served by the stock global static instance 9. FindZone
# cannot route there (the v1 zone row is content-flag-gated so classic stays
# the default), so this uses MovePCInstance rather than MovePC. Arrival = the
# stock zone-in spot from Dawnshroud; walking back out returns to the normal
# outdoor zones (griegsend v1's exit lines carry target_instance 0).

sub EVENT_CLICKDOOR {
    if ($doorid == 14) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the sorcerer's maze as it stands in a later age. Do you wish to travel to the revamped version of Grieg's End?",
            9012, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9012) {
        # Revamp Grieg's End: zone 163, global static instance 9, stock
        # zone-in coords/heading from the dawnshroud #3 zone point target.
        $client->MovePCInstance(163, 9, 3502, -1.9, -6.1, 380);
    }
}
