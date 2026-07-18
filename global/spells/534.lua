-- Ring of lavastorm
function event_spell_effect(e)
  local client = eq.get_entity_list():GetClientByID(e.caster_id);
 
  if (client.valid) then
    client:MovePC(990, 1389, 1014, 131, 301) -- lavastorm_classic (always classic, any expansion)
  end

  return 1;
end
