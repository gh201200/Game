AudioListener = {}
local CSAudioListener = CsFindType("UnityEngine.AudioListener")
AudioListener.GetType = function()
	return UnityEngine.AudioListener.GetClassType()
end