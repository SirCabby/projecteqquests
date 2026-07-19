# Cobalt Scar portal book -> REVAMP Siren's Grotto.
# Clicking the POKTELE500 book statue by the Siren's Grotto cave (doorid 42,
# inserted by dbmate migration cobaltscar_sirens_revamp_book) opens a Yes/No
# confirmation and, on Yes, ports the player into the REVAMPED Siren's Grotto
# -- zone 125 version 1, served by the stock global static instance 11.
# FindZone cannot route there (the v1 zone row is content-flag-gated so
# classic stays the default), so this uses MovePCInstance rather than MovePC.
# Arrival = the stock zone-in spot from Cobalt Scar; walking back out returns
# to the normal outdoor zones (sirens v1's exit lines carry target_instance 0).

sub EVENT_CLICKDOOR {
    if ($doorid == 42) {
        # (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
        # Clicking "No" sends nothing (silent cancel); only "Yes" fires EVENT_POPUPRESPONSE.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with the grotto as it stands in a later age. Do you wish to travel to the revamped version of Siren's Grotto?",
            9013, 1
        );
    }
    elsif ($doorid == 43) {
        # Skyshrine book (dbmate migration skyshrine_modern_instance_and_book).
        # NOTE inverted skyshrine versioning: walk-ins already get the CLASSIC
        # population (version 1 / instance 4); this book reaches the MODERN
        # v0 set (awakening event chain, elder drakes) via instance 28.
        quest::popup(
            "Planar Attunement",
            "This tome resonates with Skyshrine as it stands in a later age. Do you wish to travel to the revamped version of Skyshrine?",
            9025, 1
        );
    }
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 9013) {
        # Revamp Siren's Grotto: zone 125, global static instance 11, stock
        # zone-in coords/heading from the cobaltscar #1 zone point target.
        $client->MovePCInstance(125, 11, 70, -598, -93, 510);
    }
    elsif ($popupid == 9025) {
        # Modern Skyshrine: zone 114 version 0, global static instance 28,
        # stock zone-in coords from the cobaltscar #10 zone point target.
        $client->MovePCInstance(114, 28, -328, 449, 43.72, 0);
    }
}
