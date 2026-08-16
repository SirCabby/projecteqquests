-- Day/night spawn-condition controller.
--
-- Zones that swap their spawns on a day/night cycle drive it through
-- `spawn_conditions`, flipped by rows in `spawn_events`. Those events only fire while
-- the zone is already booted. On boot, SpawnConditionManager::LoadSpawnConditions
-- (code/zone/spawn2.cpp) resets every condition to the value persisted in
-- `spawn_condition_values` and then replays only the events whose scheduled `next` has
-- already passed -- and it replays them in TABLE ORDER, so the last-listed event per
-- condition wins regardless of the actual time. For most of these zones the last-listed
-- is the "Disable" one, so they boot with day AND night both off and only the
-- unconditional spawn points come up. `SetCondition` then persists that, making it
-- stick. It looks intermittent because a zone that stays booted behaves correctly.
--
-- PEQ ships quests/global/DayNight.pl for this ("This workarounds the problem when
-- booted zone is already in-sync with spawn_events, and since no time updates occur the
-- spawn_condition is defaulted to 0"), but the quest loader resolves NPC scripts by the
-- raw npc_types.name and nothing is named "DayNight" -- npc 50336 is "#DayNight" and has
-- no spawn point anywhere, so it has never bound to an NPC. DayNight.pl also applies one
-- hardcoded 06:00/20:00 threshold to every zone, which contradicts most of their actual
-- `spawn_events` rows and makes the script fight the server (in Kithicor it holds the
-- undead army up until 06:00 when the events disable it at 03:00).
--
-- So this replays each zone's OWN schedule instead. SCHEDULE below is generated from
-- `spawn_events` WHERE period = 1440 AND enabled = 1 AND action = 0 (ActionSet) -- only
-- once-per-EQ-day ActionSet events have a stable time-of-day meaning. Boat rotations and
-- named-mob timers on 240/360/480-minute periods are deliberately NOT handled here;
-- their phase is not derivable from the clock alone.
--
-- Times are `zone_time` = (hour * 100 + minute) on a 0-23 clock, matching
-- eq.get_zone_time().zone_time. spawn_events.next_hour is on the raw 1-24
-- TimeOfDay_Struct scale, so each entry below is (next_hour - 1) * 100 + next_minute.
--
-- Migration 20260816015158 closed the dawn/dusk gaps: PEQ had each condition enabling an
-- hour (sometimes a minute) AFTER its partner disabled, leaving a window with neither on
-- and only unconditional spawns up. Each pair below is now a strict complement -- exactly
-- one condition on at any time. `eastwastes` is the one exception: it has a Night
-- condition and no day partner, so it keeps a genuine daytime-off window.
--
-- REGENERATE with (must stay in sync with `spawn_events`):
--   SELECT zone, cond_id, (next_hour-1)*100+next_minute AS t, argument
--   FROM spawn_events WHERE period=1440 AND enabled=1 AND action=0 AND cond_id IN (1,2)
--   ORDER BY zone, cond_id, t;

-- [zone] = { [condition_id] = { {zone_time, value}, ... } }  -- transitions ascending
local SCHEDULE = {
	["cabeast"]        = { [1] = {{600,0},{1800,1}}, [2] = {{600,1},{1800,0}} },
	["commons"]        = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["eastwastes"]     = { [1] = {{600,0},{2001,1}} },
	["erudnint"]       = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["everfrost"]      = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["fieldofbone"]    = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["firiona"]        = { [1] = {{500,1},{2000,0}}, [2] = {{500,0},{2000,1}} },
	["freporte"]       = { [1] = {{800,0},{2200,1}}, [2] = {{800,1},{2200,0}} },
	["gfaydark"]       = { [1] = {{600,0},{1800,1}}, [2] = {{600,1},{1800,0}} },
	["highpass"]       = { [1] = {{700,0},{1900,1}}, [2] = {{700,1},{1900,0}} },
	["kaladima"]       = { [1] = {{600,0},{1800,1}}, [2] = {{600,1},{1800,0}} },
	["katta"]          = { [1] = {{600,0},{1800,1}}, [2] = {{600,1},{1800,0}} },
	["kithicor"]       = { [1] = {{600,0},{1900,1}}, [2] = {{600,1},{1900,0}} },
	["lakeofillomen"]  = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["lakerathe"]      = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["lfaydark"]       = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["neriakb"]        = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["northkarana"]    = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["oggok"]          = { [1] = {{600,0},{1800,1}}, [2] = {{600,1},{1800,0}} },
	["overthere"]      = { [1] = {{400,0},{1800,1}}, [2] = {{400,1},{1800,0}} },
	["qey2hh1"]        = { [1] = {{600,0},{1900,1}}, [2] = {{600,1},{1900,0}} },
	["qeynos"]         = { [1] = {{600,0},{1800,1}}, [2] = {{600,1},{1800,0}} },
	["qeynos2"]        = { [1] = {{600,0},{1800,1}}, [2] = {{600,1},{1800,0}} },
	["qeytoqrg"]       = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["rathemtn"]       = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["riwwi"]          = { [1] = {{600,1},{2000,0}}, [2] = {{600,0},{2000,1}} },
	["soltemple"]      = { [1] = {{800,0},{2000,1}}, [2] = {{800,1},{2000,0}} },
	["southkarana"]    = { [1] = {{600,0},{2000,1}}, [2] = {{600,1},{2000,0}} },
	["sro"]            = { [1] = {{500,0},{1900,1}}, [2] = {{500,1},{1900,0}} },
	["tenebrous"]      = { [1] = {{600,0},{1800,1}}, [2] = {{600,1},{1800,0}} },
	["thurgadinb"]     = { [1] = {{600,0},{1500,1}}, [2] = {{600,1},{1500,0}} },
};

local schedule = nil;
local resolved = false;

-- Value of a condition at `now`: the argument of the latest transition at or before
-- `now`. Before the first transition of the day the previous day's last one still
-- applies, so seed with it.
local function value_at(transitions, now)
	local value = transitions[#transitions][2];

	for i = 1, #transitions do
		if (transitions[i][1] > now) then
			break;
		end

		value = transitions[i][2];
	end

	return value;
end

local function sync()
	if (schedule == nil) then
		return;
	end

	local zone     = eq.get_zone_short_name();
	local instance = eq.get_zone_instance_id();
	local now      = eq.get_zone_time().zone_time;

	-- These conditions carry onchange = 2 (DoRepop), so a real change repops the
	-- affected points immediately. Re-setting a value the condition already holds
	-- returns early inside SetCondition, so a steady-state tick costs nothing and
	-- never churns spawns.
	for condition_id, transitions in pairs(schedule) do
		eq.spawn_condition(zone, instance, condition_id, value_at(transitions, now));
	end
end

-- EVENT_TICK, deliberately. It is dispatched from `NPC::Process` off `Mob::tic_timer`
-- (6000ms, `mob.cpp`) with no guard beyond `p_depop`, so the zone controller fires it
-- every 6 seconds for as long as the zone is loaded. That makes it the only hook here
-- that does not depend on something else happening:
--
--   * EVENT_SPAWN never arrives at all -- NPC::SpawnZoneController() runs inside
--     PopulateZoneSpawnList while the zone is still loading, before the parser answers
--     HasQuestSub for npc id 10 (verified on dev: the script loaded but never fired).
--   * EVENT_SPAWN_ZONE / EVENT_DESPAWN_ZONE need an NPC to spawn or die, which is not
--     guaranteed -- a zone whose players are idle, or camping without killing, produces
--     neither.
--   * A quest timer is not safe either: `Zone::Repop` and
--     `QuestParserCollection::ReloadQuests(reset_timers)` both call
--     `quest_manager.ClearAllTimers()`, and neither necessarily reloads the Lua chunk.
--
-- Keying the wake-up on spawns alone deadlocked Kithicor on live: a quest reload killed
-- the resync timer while the night points were disabled, so nothing spawned, so nothing
-- re-armed the timer, so the conditions were never corrected -- the zone sat on the
-- values computed at zone_time 0814 while the clock ran on past midnight and the undead
-- never came up. A tick cannot be starved that way and cannot be cleared.
--
-- Syncing every 6s is cheap: SetCondition early-returns when the value is unchanged, so
-- between transitions this is two map lookups and an int compare.
function event_tick(e)
	if (not resolved) then
		resolved = true;
		schedule = SCHEDULE[eq.get_zone_short_name()];
	end

	sync();
end
