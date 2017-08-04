ParticleEmitter = {}
local CSParticleEmitter = CsFindType("UnityEngine.ParticleEmitter")
ParticleEmitter.GetType = function()
	return UnityEngine.ParticleEmitter.GetClassType()
end