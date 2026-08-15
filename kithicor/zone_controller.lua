-- Kithicor day/night spawn-condition controller.
--
-- Kithicor gates its daytime fauna behind spawn condition 2 (KithicorDay) and its
-- undead army behind condition 1 (KithicorNight) -- 309 of the zone's 485 live spawn
-- points sit behind one or the other. The four `spawn_events` rows flip those
-- conditions at 05:01/18:00 and 19:01/04:00, but only while the zone is already up.
--
-- On boot, SpawnConditionManager::LoadSpawnConditions (code/zone/spawn2.cpp) resets
-- every condition to the value persisted in `spawn_condition_values`, then replays
-- only the events whose scheduled `next` time has already passed. A zone that boots
-- between two events replays nothing and inherits the stale persisted value -- which
-- is how Kithicor ended up with day AND night both disabled, leaving only the 176
-- unconditional points up.
--
-- PEQ ships quests/global/DayNight.pl for exactly this ("This workarounds the problem
-- when booted zone is already in-sync with spawn_events, and since no time updates
-- occur the spawn_condition is defaulted to 0"), but the quest loader resolves NPC
-- scripts by the raw npc_types.name and nothing is named "DayNight" -- npc 50336 is
-- "#DayNight" and has no spawn point anywhere. That script has never bound to an NPC.
--
-- Thresholds match DayNight.pl: night is zone_time < 600 or > 1999, where zone_time is
-- (hour * 100 + minute) on a 0-23 clock.

local CONDITION_NIGHT = 1 -- spawn_conditions.id 1, KithicorNight
local CONDITION_DAY   = 2 -- spawn_conditions.id 2, KithicorDay

local RESYNC_MS = 60 * 1000

local bootstrapped = false;

local function sync()
	local zone     = eq.get_zone_short_name();
	local instance = eq.get_zone_instance_id();
	local now      = eq.get_zone_time().zone_time;

	-- Both conditions carry onchange = 2 (DoRepop), so a real change repops the
	-- affected points immediately. Re-setting a value the condition already holds
	-- returns early inside SetCondition, so re-syncing costs nothing between
	-- transitions and never churns spawns.
	if (now < 600 or now > 1999) then
		eq.spawn_condition(zone, instance, CONDITION_DAY, 0);
		eq.spawn_condition(zone, instance, CONDITION_NIGHT, 1);
	else
		eq.spawn_condition(zone, instance, CONDITION_DAY, 1);
		eq.spawn_condition(zone, instance, CONDITION_NIGHT, 0);
	end
end

-- EVENT_SPAWN_ZONE, not EVENT_SPAWN. NPC::SpawnZoneController() runs inside
-- PopulateZoneSpawnList while the zone is still loading, and the parser does not yet
-- answer HasQuestSub for npc id 10 at that point, so the controller's own EVENT_SPAWN
-- is never dispatched (verified on dev: the script loaded but never fired). Every NPC
-- that spawns in the zone dispatches EVENT_SPAWN_ZONE to the controller, and the 176
-- unconditional spawn points guarantee one arrives right after boot.
function event_spawn_zone(e)
	if (not bootstrapped) then
		bootstrapped = true;
		eq.set_timer("daynight", RESYNC_MS);
	end

	sync();
end

-- The timer carries the day/night boundary when no NPC happens to spawn across it,
-- and covers zones whose `spawn_events` rows have drifted out of the current game
-- year and so no longer fire at all.
function event_timer(e)
	if (e.timer == "daynight") then
		sync();
	end
end
