function event_click_door(e)
  local door_id = e.door:GetDoorID();
  if (door_id == 20) then
    -- stock rogue epic 1.5 tower door -> the player's "Innoruuk's Realm" DZ
    e.self:MovePCDynamicZone("hateplaneb")
  elseif (door_id == 21) then
    -- Portal book -> the three ages of the Plane of Hate (doorid 21, dbmate
    -- migration oasis_plane_of_hate_book). The popup window caps at 2
    -- buttons, so this is a two-level button menu (no saylinks). Decline =
    -- titlebar X / ESC (client EQUI_LargeDialogWnd.xml) or the 30s expiry.
    e.self:Popup(
      "Planar Attunement",
      "This tome resonates with every age of the Plane of Hate. Which do you seek? (Close or ignore this window to remain.)",
      9018, 9019, 2, 30,
      "Original Plane", "Revamped Eras..."
    );
  end
end

function event_popup_response(e)
  if (e.popup_id == 9018) then
    -- Original Plane of Hate: hateplane 76 (classic geometry + population),
    -- landing at its zone-in safe point.
    e.self:MovePC(76, -353, -375, 4, 0);
  elseif (e.popup_id == 9019) then
    -- second menu level: the two hateplaneb eras
    e.self:Popup(
      "Planar Attunement",
      "The later ages of the Plane of Hate. Which do you seek? (Close or ignore this window to remain.)",
      9020, 9021, 2, 30,
      "Revamped Plane", "Hardened Plane"
    );
  elseif (e.popup_id == 9020) then
    -- Revamped Plane of Hate: hateplaneb 186 v0 (default boot), safe point.
    e.self:MovePC(186, -393, 656, 3, 0);
  elseif (e.popup_id == 9021) then
    -- Hardened Plane: hateplaneb VERSION 1 (the level-64 hate elites) via
    -- global static instance 27. Same zone-in safe point as the Revamped
    -- choice (beside the exit book) -- the epic expedition's own zonein
    -- (-389.93,-853.94) is deep in the plane and reserved for the epic.
    e.self:MovePCInstance(186, 27, -393, 656, 3, 0);
  end
end
