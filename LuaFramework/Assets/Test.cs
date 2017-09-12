using System;
using UnityEngine;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Debug = UnityEngine.Debug;
using DG.Tweening;

public class Test : MonoBehaviour
{
    void Start()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            var go = transform.GetChild(i).gameObject;
            var button = UIButton.Get(go);
            button.onDrop.AddListener(data =>
            {
                print(button.name + " on drop");
                if (data.pointerCurrentRaycast.gameObject != null) print(data.pointerCurrentRaycast.gameObject.name);
            });
            button.onDown.AddListener(data =>
            {
                print(button.name + " on down");
                if (data.pointerCurrentRaycast.gameObject != null) print(data.pointerCurrentRaycast.gameObject.name);
            });
            transform.DOScale(1f, 1f).SetEase(Ease.OutBack);
        }
    }
}
