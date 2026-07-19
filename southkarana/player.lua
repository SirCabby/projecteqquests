-- BeginFile: southkarana\player.lua
-- Quest file for South Karana: Paladin message during Necromancer Epic 1.5 (Soulwhisper)

function event_loot(e)
	if e.item:GetID() == 22892 and e.self:HasItem(26896) and e.self:HasItem(14344) and e.self:HasItem(11430) then -- All 4 Paladin Heads
		e.self:Message(MT.Yellow, "With his last breath, the paladin says, 'You are too late. The last paladin has fled to Natimbi with the staff and is on his way to destroy it!'");
	end
end

-- Portal book on the Splitpaw pit floor -> REVAMP paw ("Paw V2", LDoN era).
-- doorid 3, inserted by dbmate migration southkarana_paw_revamp_book_and_exit_fix.
-- The v1 zone row is content-flag-gated so FindZone keeps classic paw the
-- default; this ports directly into the stock global static instance 6.
-- Arrival = the stock zone-in spot; walking back out of revamp paw lands
-- beside this book (the paw exit was retargeted by the same migration).
function event_click_door(e)
	if e.door:GetDoorID() == 3 then
		-- (title, text, popup_id, buttons=1 => Yes/No). No duration => no auto-port.
		-- Clicking "No" sends nothing (silent cancel); only "Yes" fires event_popup_response.
		eq.popup(
			"Planar Attunement",
			"This tome resonates with the gnoll warrens as they stand in a later age. Do you wish to travel to the revamped version of the Lair of the Splitpaw?",
			9015, 1
		);
	end
end

function event_popup_response(e)
	if e.popup_id == 9015 then
		-- Revamp paw: zone 18, global static instance 6, stock zone-in
		-- coords/heading from the southkarana #2 zone point target.
		e.self:MovePCInstance(18, 6, -7.9, -79.3, 4, 1);
	end
end

-- EndFile: southkarana\player.lua