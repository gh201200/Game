using UnityEngine;
using System.Collections;
using System.IO;
using SLua;

public class Init : MonoBehaviour
{
    private int index = 10;
    public float angle = 10;
    private Sprite image = null;

    private void Start()
    {
        LuaManager.Instance.Init(p =>
        {
            Debug.Log("lua init -> " + p + "%");
        }, instance =>
        {
            instance.DoFile("Main");
        });

        //AssetLoader.Instance.LoadAsync("Textures/UI/Common/Loading2.png", AssetType.Sprite, arg =>
        //{
        //    image = arg as Sprite;
        //});
    }

    //private void OnGUI()
    //{
    //    if (image == null) return;
    //    GUIUtility.RotateAroundPivot(Time.time * angle, new Vector2(Screen.width / 2f, Screen.height / 2f));
    //    GUI.DrawTexture(new Rect(new Vector2(Screen.width / 2f - 50, Screen.height / 2f - 50), new Vector2(100, 100)), image.texture);
    //}
}
