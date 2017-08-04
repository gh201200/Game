local Camera,AudioSource,AudioListener,Resources,AssetPath,print,require,os,GameObject,GetComponent = 
Camera,AudioSource,AudioListener,Resources,AssetPath,print,require,os,GameObject,GetComponent
local CsAudioStop,CsAudioPlayOneShot,CsAudioPlayLoop,CsAudioStopLoop,CsSetAudioListenerEnabled =
CsAudioStop,CsAudioPlayOneShot,CsAudioPlayLoop,CsAudioStopLoop,CsSetAudioListenerEnabled
local AssetType = AssetType
module("LuaScript.Control.System.AudioManager")
local mCsAudioSource = nil
local mCsLoopAudioSource = nil
local mCsAudioListener = nil
local mSetManager = nil
local mAssetManager = nil
function Init()
	mSetManager = require "LuaScript.Control.System.SetManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	
	local csAudioSource = GameObject.Find("AudioSource")
	local csLoopAudioSource = GameObject.Find("LoopAudioSource")
	mCsAudioSource = GetComponent(csAudioSource,AudioSource.GetType())
	mCsLoopAudioSource = GetComponent(csLoopAudioSource,AudioSource.GetType())
	mCsAudioListener = GetComponent(Camera.mainCamera.gameObject,AudioListener.GetType())
end

function SetVolume(volume)
	mCsAudioListener.volume = volume
end

function StartAudio()
	-- print("StartAudio")
	if CsSetAudioListenerEnabled then
		CsSetAudioListenerEnabled(mCsAudioListener, true)
	else
		mCsAudioListener.enabled = true
	end
end

function StopAudio()
	-- print("StopAudio")
	if CsSetAudioListenerEnabled then
		CsSetAudioListenerEnabled(mCsAudioListener, false)
	else
		mCsAudioListener.enabled = false
	end
	
	if CsAudioStop then
		CsAudioStop(mCsAudioSource)
		CsAudioStop(mCsLoopAudioSource)
	else
		mCsAudioSource:Stop()
		mCsLoopAudioSource:Stop()
	end
end

function PlayAudioOneShot(audio, volumeScale)
	-- print(audio.path,os.clock())
	if not mSetManager.GetAudio() then
		return
	end
	
	-- local audioUrl = AssetPath.AudioPath .. audio.path
	-- local audioClip = Resources.Load(audioUrl)
	
	function completeFunc()
		local audioClip = mAssetManager.GetAsset(audio.path, AssetType.Audio)
		-- print(audio.path,audioClip)
		volumeScale = volumeScale or audio.volumeScale
		if CsAudioPlayOneShot then
			CsAudioPlayOneShot(mCsAudioSource, audioClip, volumeScale)
		else
			mCsAudioSource:PlayOneShot(audioClip, volumeScale)
		end
	end
	-- print(audio.path)
	local audioClip =mAssetManager.GetAsset(audio.path, AssetType.Audio, completeFunc)
	if audioClip then
		completeFunc()
	end
end

function PlayAuidioLoop(audio)
	-- print(audio.path,os.clock())
	if not mSetManager.GetAudio() then
		return
	end
	-- local audioUrl = AssetPath.AudioPath .. audio.path
	local audioClip = Resources.Load(audio.path)
	if CsAudioPlayLoop then
		CsAudioPlayLoop(mCsLoopAudioSource, audioClip, 0.5)
	else
		mCsLoopAudioSource.volume = 0.5
		mCsLoopAudioSource.clip = audioClip
		mCsLoopAudioSource:Play()
	end
	
end


function StopAuidioLoop()
	if CsAudioStopLoop then
		CsAudioStopLoop(mCsLoopAudioSource)
	else
		mCsLoopAudioSource.clip = nil
	end
end
