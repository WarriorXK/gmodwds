AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(1,0,0)
ENT.ExplodeRadius	= 30
ENT.ChargeEffect	= ""
ENT.ShootEffect		= "wds_weapon_tankcannon_shot"
ENT.ChargeSound		= ""
ENT.ShootOffset		= 40
ENT.ReloadDelay		= 5
ENT.ReloadSound		= ""
ENT.ShootSound		= "wds/weapons/tankcannon/fire.wav"
ENT.Projectile		= "wds_projectile_tankshell"
ENT.ChargeTime		= 0
ENT.FireDelay		= 1.4
ENT.MaxAmmo			= 5
ENT.Damage			= 130
ENT.Model			= "models/wds/device02.mdl"
ENT.Class			= "wds_weapon_tankcannon"
ENT.Speed			= 3000

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.Class or "wds_weapon_base")
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end
