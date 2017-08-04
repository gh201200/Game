AudioSource = {}
local CSAudioSource = CsFindType("UnityEngine.AudioSource")
AudioSource.GetType = function()
	return UnityEngine.AudioSource.GetClassType()
end