
GameObject = {}

GameObject.Find = function(name)
	return RunStaticFunc("UnityEngine.GameObject", "Find", name)
end

GameObject.FindGameObjectsWithTag = function(name)
	return RunStaticFunc("UnityEngine.GameObject", "FindGameObjectsWithTag", name)
end

GameObject.FindGameObjectWithTag = function(name)
	return RunStaticFunc("UnityEngine.GameObject", "FindGameObjectWithTag", name)
end