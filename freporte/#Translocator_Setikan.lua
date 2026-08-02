-- akk-stack: offers BOTH ages of the Ocean of Tears.
--  * classic (oot 69): stock behavior -- SelfCast 2279 "Portal to Ocean"
--    (spell teleport, lands at the classic dock).
--  * revamped (oceanoftears 409): direct MovePC beside #Translocator_Narrik
--    on his dock (-7951,1677,-283) -- no spell targets 409. Narrik's stock
--    script returns players to classic Freeport (spell 2283, retargeted by
--    the ports_target_classic_zones migration), closing the round trip.
-- NOTE: the "revamped" branch MUST be checked before the plain "ocean of
-- tears" branch -- findi("ocean of tears") also matches the longer phrase.
-- ERA GATE: oceanoftears (409) is a Serpent's Spine zone. MovePC bypasses the
-- zoning expansion check entirely (ProcessMovePC has no such check), so without
-- this the revamped branch would teleport a Classic character straight into TSS.
-- See migration 20260802210238, which closes the same hole on the zone lines and
-- the portal-book doors. The classic branch is always offered.
function event_say(e)
	local revamp_era = eq.is_current_expansion_the_serpents_spine();
	if(e.message:findi("hail")) then
		local hail = "Hello there. There seem to be some strange problems with the boats in this area. The Academy of Arcane Sciences has sent a small team of us to investigate them. If you need to travel to the [" .. eq.say_link("Ocean of Tears",false,"Ocean of Tears") .. "] in the meantime, I can transport you to my companion there";
		if(revamp_era) then
			hail = hail .. " -- or brave the [" .. eq.say_link("revamped Ocean of Tears",false,"revamped Ocean of Tears") .. "] as it stands in a later age.";
		else
			hail = hail .. ".";
		end
		e.self:Say(hail);
	elseif(e.message:findi("revamped ocean of tears")) then
		if(not revamp_era) then
			return;
		end
		e.self:Say("On your way");
		e.other:MovePC(409, -7945, 1670, -283, 225);
	elseif(e.message:findi("ocean of tears")) then
		e.self:Say("On your way");
		eq.SelfCast(2279);
	end
end
