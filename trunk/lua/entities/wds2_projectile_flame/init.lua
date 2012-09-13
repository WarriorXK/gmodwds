AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.NextDamage = 0

function ENT:Initialize()
	self:SetModel("models/wds/pball.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetVelocityInstantaneous(self:GetForward() * (2000 + math.random(-50, 50)))
	end
	local Rand = math.Rand(0.6,0.8)
	local ed = EffectData()
		ed:SetEntity(self)
	util.Effect("wds2_flamethrower_flame",ed,true,true)
	self.DeathTime = CurTime() + Rand
	self.CreationTime = CurTime()
	self.ImmuneToFire = true
end

function ENT:Think()
	if self.NextDamage <= CurTime() then
		local Rad = (CurTime() - self.CreationTime) * 300
		if Rad < 35 then Rad = 35 end
		
		local Pos = self:GetPos()
		local Dmg = 20

		local DmgInfo = DamageInfo()
		DmgInfo:SetAttacker(self.WDSO)
		DmgInfo:SetInflictor(self.Cannon)
		DmgInfo:SetDamageType(DMG_BURN)
		
		for _,v in pairs(ents.FindInSphere(self:GetPos(), Rad)) do
			if v != self then
				if !v.ImmuneToFire then
					if (v:IsPlayer() and v:Alive()) or v:IsNPC() then
						DmgInfo:SetDamage(Dmg * math.Clamp(-((Pos:Distance(v:GetPos())/Rad)-1),0.2,1))
						//v:TakeDamageInfo(DmgInfo)
					else
						// Entitys take damage here.
					end
				end
			end
		end
		self.NextDamage = CurTime() + 0.1
	end
	
	if self.DeathTime < CurTime() then
		self:Die()
		return
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:Touch(ent)
	if IsValid(ent) and ent:GetClass() == "shield" then // Stargate shield Support
		self:Die()
	end
end

function ENT:PhysicsCollide(data,physobj)
	self:Die(data.HitEntity)
	return
end

function ENT:Die(ent)
	if IsValid(ent) then
		local DmgInfo = DamageInfo()
		DmgInfo:SetAttacker(IsValid(self.WDSO) and self.WDSO or self)
		DmgInfo:SetInflictor(IsValid(self.Cannon) and self.Cannon or self)
		DmgInfo:SetDamageType(DMG_BURN)
		DmgInfo:SetDamage(math.random(40,60))
		ent:TakeDamageInfo(DmgInfo)
	end
	local ed = EffectData()
		ed:SetOrigin(self:GetPos())
	util.Effect("wds2_flamethrower_death",ed)
	self:Remove()
end
