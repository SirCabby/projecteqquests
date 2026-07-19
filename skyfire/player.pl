sub EVENT_CLICKDOOR {
  if(($doorid == 1) && !defined $qglobals{dragon_not_ready}) {
    quest::setglobal("door_two",1,3,"S60");
    $client->Message(4,"The globe begins to spin faster and faster...");
  }
  if(($doorid == 2) && !defined $qglobals{dragon_not_ready}) {
    quest::setglobal("door_three",1,3,"S60");
    $client->Message(4,"The globe begins to spin faster and faster...");
  }
  if(($doorid == 3) && !defined $qglobals{dragon_not_ready}) {
    quest::setglobal("door_four",1,3,"S60");
    $client->Message(4,"The globe begins to spin faster and faster...");
  }
  if(($doorid == 232) && !defined $qglobals{dragon_not_ready}) {
    quest::setglobal("door_one",1,3,"S60");
    $client->Message(4,"The globe begins to spin faster and faster...");
  }
  if(($doorid == 1) && $dragon_not_ready == 1) {
    $client->Message(4,"The globe does not seem to do anything");
  }
  if(($doorid == 2) && $dragon_not_ready == 1) {
    $client->Message(4,"The globe does not seem to do anything");
  }
  if(($doorid == 3) && $dragon_not_ready == 1) {
    $client->Message(4,"The globe does not seem to do anything");
  }
  if(($doorid == 232) && $dragon_not_ready == 1) {
    $client->Message(4,"The globe does not seem to do anything");
  }
  if($doorid == 135) {
    if(plugin::check_hasitem($client, 69311) && !$client->KeyRingCheck(69311)) {
      $client->KeyRingAdd(69311);
    }
    if(plugin::check_hasitem($client, 69312) && !$client->KeyRingCheck(69312)) {
      $client->KeyRingAdd(69312);
    }
    if($client->KeyRingCheck(69311) || $client->KeyRingCheck(69312) || ($status > 99)) {
      quest::movepc(108,1682,41,25.9); # Zone: veeshan
    }
    else {
      $client->Message(13, "You lack the will to use this object!");
    }
  }
  # Portal book -> the two LATER eras of Veeshan's Peak. doorid 233, inserted
  # by dbmate migration skyfire_veeshan_revamp_book; hard mode added by
  # veeshan_hard_mode_instance (both instances are zone version 1, eras chosen
  # by per-instance spawn_condition_values: 24 = VP 2.0, 26 = hard re-tune).
  # UX: two-button Popup2 (SendFullPopup) -- button 0 fires
  # EVENT_POPUPRESPONSE with popup_id 9014, button 1 with negative_id 9017.
  # The decline path is the window's titlebar close box (X), enabled
  # CLIENT-SIDE in uifiles/default/EQUI_LargeDialogWindow.xml -- closing via
  # the X sends no response packet. Return = the exit pads (entrance pad
  # doorid 240 + the four wing pads).
  if($doorid == 233) {
    # duration 30 = the window auto-expires after 30s, so ignoring it is
    # always a valid decline even if a client build ignores the closebox/ESC
    # styles from the UI template.
    $client->Popup2(
      "Planar Attunement",
      "This tome resonates with two later ages of Veeshan's Peak. Which do you wish to enter? (Close or ignore this window to remain in the present age.)",
      9014, 9017, 2, 30,
      "Restored Peak", "Hardened Peak"
    );
  }
}

sub EVENT_POPUPRESPONSE {
  if($popupid == 9014) {
    # VP 2.0: zone 108, global static instance 24, stock ring-in arrival
    # (same coords as the doorid-135 key entry).
    $client->MovePCInstance(108, 24, 1682, 41, 25.9, 0);
  }
  elsif($popupid == 9017) {
    # VP hard re-tune: zone 108, global static instance 26.
    $client->MovePCInstance(108, 26, 1682, 41, 25.9, 0);
  }
}