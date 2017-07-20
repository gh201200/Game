using System;
using UnityEngine;
using System.Collections;
using System.IO;
using System.Net;
using System.Diagnostics;

public class Test : MonoBehaviour
{
    void Start()
    {
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E)) TimeManager.Instance.DeleteAll();
        if (Input.GetKeyDown(KeyCode.Q))
        {
            TimeManager.Instance.Add(1000, () => print("test delay 1000"));
            TimeManager.Instance.AddCycle(500, 100, () => print("test cycle delay 100 -> " + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss fff")));
            TimeManager.Instance.AddCycle(0, 200, () => print("frame count -> " + Time.time / Time.frameCount));
        }
    }
}
