-- akk-stack: offers BOTH ages of the Ocean of Tears (same as the classic
-- freporte Setikan -- see that file for the full notes; the "revamped"
-- branch must be checked before the plain "ocean of tears" branch).
function event_say(e)
	if(e.message:findi("hail")) then
		e.self:Say("Hello there. There seem to be some strange problems with the boats in this area. The Academy of Arcane Sciences has sent a small team of us to investigate them. If you need to travel to the [" .. eq.say_link("Ocean of Tears",false,"Ocean of Tears") .. "] in the meantime, I can transport you to my companion there -- or brave the [" .. eq.say_link("revamped Ocean of Tears",false,"revamped Ocean of Tears") .. "] as it stands in a later age.");
	elseif(e.message:findi("revamped ocean of tears")) then
		e.self:Say("On your way");
		e.other:MovePC(409, -7945, 1670, -283, 225);
	elseif(e.message:findi("ocean of tears")) then
		e.self:Say("On your way");
		eq.SelfCast(2279);
	end
end
