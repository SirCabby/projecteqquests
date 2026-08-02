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
    --
    -- ERA GATE: hateplaneb (186) is a Legacy of Ykesha zone -- see migration
    -- 20260802210238, which sets zone.expansion = 5 on the 182-189 LoY block.
    -- The gate has to live here rather than on the door, because this one book
    -- also serves the CLASSIC plane and so must keep spawning at every era.
    -- MovePC bypasses the zoning expansion check entirely (ProcessMovePC has no
    -- such check), so without this the popup would teleport straight past it.
    if (eq.is_current_expansion_the_legacy_of_ykesha()) then
      e.self:Popup(
        "Planar Attunement",
        "This tome resonates with every age of the Plane of Hate. Which do you seek? (Close or ignore this window to remain.)",
        9018, 9019, 2, 30,
        "Original Plane", "Revamped Eras..."
      );
    else
      e.self:Popup(
        "Planar Attunement",
        "This tome resonates with the Plane of Hate. Only one age answers you. (Close or ignore this window to remain.)",
        9018, 0, 1, 30,
        "Original Plane"
      );
    end
  end
end

function event_popup_response(e)
  if (e.popup_id == 9018) then
    -- Original Plane of Hate: hateplane 76 (classic geometry + population),
    -- landing at its zone-in safe point.
    e.self:MovePC(76, -353, -375, 4, 0);
  elseif (e.popup_id == 9019 or e.popup_id == 9020 or e.popup_id == 9021) and
         (not eq.is_current_expansion_the_legacy_of_ykesha()) then
    -- Era gate, second line of defence: popup ids arrive from the client, so a
    -- replayed or hand-sent response must not walk past the check above.
    return;
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
