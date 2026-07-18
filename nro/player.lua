local expeditions = { takc = true, take = true, taka = true }

function event_click_door(e)
  local door_id = e.door:GetDoorID();

  if (door_id == 3) then
    local dz = e.self:GetExpedition()
    if dz.valid and expeditions[dz:GetZoneName()] then
      e.self:MovePCDynamicZone(dz:GetZoneID())
    end
  end

  -- PoK portal book (doorid 82, migration northro_portal_books): Yes/No confirm, then
  -- port to REVAMP North Ro 10 units south of the return book there.
  if (door_id == 82) then
    -- (title, text, popup_id, negative_id=0 => No is silent, button_type=1 => Yes/No,
    --  duration=0, "Yes","No", sound_controls=0 => NO replay/volume/mute widgets)
    e.self:Popup("Planar Attunement", "This tome resonates with the revamped North Ro. Do you wish to travel to the revamped version of the zone?", 9007, 0, 1, 0, "Yes", "No", 0)
  end
end

-- Only "Yes" (popup_id 9007) reaches this; "No" (negative_id 0) sends nothing.
function event_popup_response(e)
  if (e.popup_id == 9007) then
    -- Revamp North Ro (zone 392), 10 units south (-Y) of the revamp book at (-862,6738).
    e.self:MovePC(392, -862, 6728, 33, 0)
  end
end
