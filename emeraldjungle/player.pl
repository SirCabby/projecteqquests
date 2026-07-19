# Emerald Jungle portal book -> REVAMP City of Mist.
# Clicking the POKTELE500 book statue between the City of Mist zone lines
# (doorid 4, inserted by dbmate migration emeraldjungle_citymist_revamp_book)
# opens a Yes/No confirmation and, on Yes, ports the player into the REVAMPED
# City of Mist -- zone 90 version 1, served by the stock global static
# instance 10. FindZone cannot route there (the v1 zone row is
# content-flag-gated so classic stays the default), so this uses MovePCInstance
# rather than MovePC. Arrival = the stock zone-in spot from Emerald Jungle;
# walking back out the gate returns to normal Emerald Jungle (citymist v1's
# exit lines carry target_instance 0).

sub EVENT_CLICKDOOR {
    if ($doorid == 4) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the drowned city as it stands in a later age. Do you wish to travel to the revamped version of the City of Mist?",
            9011, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9011) {
        # Revamp City of Mist: zone 90, global static instance 10, stock
        # zone-in coords/heading from the emeraldjungle #2 zone point target.
        $client->MovePCInstance(90, 10, -886, -26, 5, 128);
    }
}
