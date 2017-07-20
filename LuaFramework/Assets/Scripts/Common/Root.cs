using UnityEngine;
using System.Collections;

public class Root : MonoBehaviour
{
    private static Root _instance;

    public static Root Instance
    {
        get
        {
            if (_instance == null) _instance = new GameObject("Singleton").AddComponent<Root>();
            return _instance;
        }
    }

    private void Start()
    {
        DontDestroyOnLoad(gameObject);
    }
}
