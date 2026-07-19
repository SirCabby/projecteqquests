# Frontier Mountains portal books -> the REVAMP versions of Droga and Nurga.
# Clicking a POKTELE500 book statue (doorids 13/14, inserted by the dbmate
# migrations frontiermtns_droga_revamp_book / frontiermtns_nurga_revamp_book)
# opens a Yes/No confirmation and, on Yes, ports the player into the revamped
# mine -- zone version 1, served by its stock global static instance (droga=8,
# nurga=7). FindZone cannot route there (the v1 zone rows are content-flag-gated
# so classic stays the default), so these use MovePCInstance rather than MovePC.
# Arrival = the stock zone-in spot from Frontier Mountains; walking back out the
# entrance returns to normal Frontier Mountains (the v1 exit lines carry
# target_instance 0).

sub EVENT_CLICKDOOR {
    # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
    # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
    if ($doorid == 13) {
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the goblin warrens as they stand in a later age. Do you wish to travel to the revamped version of Droga?",
            9009, 1
        );
    }
    elsif ($doorid == 14) {
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the goblin mines as they stand in a later age. Do you wish to travel to the revamped version of Nurga?",
            9010, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9009) {
        # Revamp Droga: zone 81, global static instance 8, stock zone-in
        # coords/heading from the frontiermtns #5 zone point target.
        $client->MovePCInstance(81, 8, 376, 1412, 4, 300);
    }
    elsif ($popupid == 9010) {
        # Revamp Nurga: zone 107, global static instance 7, stock zone-in
        # coords/heading from the frontiermtns #4 zone point target.
        $client->MovePCInstance(107, 7, -1799, -2227, 4, 0);
    }
}
