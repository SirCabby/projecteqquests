-- Circle of Lavastorm
function event_spell_effect(e)
  local mob = e.target;
  
  if (mob.valid and mob:IsClient()) then
    local client = mob:CastToClient();
    if (client.valid) then
      client:MovePC(990, 1389, 1014, 131, 301) -- lavastorm_classic (always classic, any expansion)
    end
  end

  return 1;
end
