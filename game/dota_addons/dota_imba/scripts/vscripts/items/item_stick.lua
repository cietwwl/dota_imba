--[[	Author: d2imba
		Date:	16.08.2015	]]

function MagicStick( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast

	-- Parameters
	local restore_per_charge = ability:GetLevelSpecialValueFor("restore_per_charge", ability_level)

	-- Fetch current charges
	local current_charges = ability:GetCurrentCharges()

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local stick_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(stick_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(stick_pfx, 1, Vector(10,0,0))

	-- Restore health and mana to the caster
	caster:Heal(current_charges * restore_per_charge, ability)
	caster:GiveMana(current_charges * restore_per_charge)

	-- Set remaining charges to zero
	ability:SetCurrentCharges(0)
end

function MagicStickCharge( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local cast_ability = keys.event_ability

	-- Parameters
	local max_charges = ability:GetLevelSpecialValueFor("max_charges", ability_level)
	local current_charges = ability:GetCurrentCharges()

	-- Verify stick proc conditions
	local mana_spent = cast_ability:GetManaCost(cast_ability:GetLevel() - 1)
	local procs_stick = StickProcCheck(cast_ability)
	local caster_visible = caster:CanEntityBeSeenByMyTeam(target)

	-- If all conditions are met, increase stick charges
	if mana_spent > 0 and procs_stick and caster_visible then
		
		-- If the stick is not maxed yet, increase the amount of charges
		if current_charges < max_charges then
			ability:SetCurrentCharges(current_charges + 1)
		end
	end
end