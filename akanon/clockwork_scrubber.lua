-- ATTACHED TO TWO NPCs. Ak'Anon has five scrubbers on four points: clockwork_scrubber
-- 10055035 / 10055349 (spawngroup 10055035) and a fifth, #clockwork_scrubber 10055010,
-- alone on spawngroup 10224174 at (-397, 776, -26). All five are the same creature --
-- level 4, race 36, 80hp, loottable 10005192 -- but EQEmu builds a quest filename from
-- npc_types.name verbatim and does NOT strip the '#' (quest_parser_collection.cpp
-- GetQIByNPCQuest), so the fifth had no handler and could never roll miner628 or take
-- the Scrubber Key. '#clockwork_scrubber.lua' beside it is a relative symlink to this
-- file. Each scrubber rolls its own 5% miner628 chance in event_spawn, so this adds one
-- more candidate rather than changing anyone's odds.

-- Converted to .lua by Speedz
-- items: 12164, 12162, 12167

local miner628 = 0;

function event_spawn(e)
	local random_result = math.random(100);
	if(random_result <= 5) then
		miner628 = 1;
	end
end

function event_say(e)
	if (e.message:findi("628") and miner628 == 1) then
		e.self:Emote(".wizz.click.628.");
	end
end

function event_trade(e)
	local item_lib = require("items");
	if (miner628 == 1 and item_lib.check_turn_in(e.trade, {item1 = 12164})) then -- Scrubber Key
		e.self:Emote(".wizz.click.628.");
		e.other:Faction(695,-10,0); -- Clockwork Gnome
		e.other:Ding();
		e.other:AddEXP(500);
		e.other:SummonItem(eq.ChooseRandom(12162,12167)); -- Gnome Take (Good or Bad)
	end
	item_lib.return_items(e.self, e.other, e.trade)
end
