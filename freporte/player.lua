function event_enter_zone(e)
	local level = e.self:GetLevel();
	local zoneid = eq.get_zone_id();
	local qglobals = eq.get_qglobals(e.self);

  	if(level >= 15 and qglobals.Wayfarer == nil and e.self:GetStartZone() == zoneid and eq.is_lost_dungeons_of_norrath_enabled()) then
    		e.self:Message(MT.Yellow, "A mysterious voice whispers to you, 'Miocaei Herlsas has just joined the Wayfarers Brotherhood and has some information about them, and how you can start doing odd jobs for them. You looked like the heroic sort, so I wanted to contact you . . . discreetly.'");
  	end
end

-- Portal book -> Plane of Sky (doorid 102, dbmate migration
-- freporte_plane_of_sky_book). Lands at the authentic Alter Plane: Sky
-- arrival on the base island; falling off Sky already returns to Freeport,
-- so there is no exit book.
function event_click_door(e)
	if (e.door:GetDoorID() == 102) then
		-- (title, text, popup_id, negative_id, buttons=1 => Yes/No). Only
		-- "Yes" fires event_popup_response; No / titlebar X / ESC decline.
		e.self:Popup(
			"Planar Attunement",
			"This tome resonates with the endless isles above. Do you wish to travel to the Plane of Sky?",
			9024, 0, 1, 0
		);
	end
end

function event_popup_response(e)
	if (e.popup_id == 9024) then
		e.self:MovePC(71, 539, 1384, -664, 0);
	end
end