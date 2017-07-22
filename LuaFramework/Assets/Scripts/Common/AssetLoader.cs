using UnityEngine;
using System.Collections;

public class AssetLoader : MonoBehaviour
{
    private AssetLoader _instance;

    public AssetLoader Instance
    {
        get
        {
            if (_instance == null) _instance = Root.Instance.gameObject.AddComponent<AssetLoader>();
            return _instance;
        }
    }
}
