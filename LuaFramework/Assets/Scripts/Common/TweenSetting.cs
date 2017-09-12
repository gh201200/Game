using System;
using UnityEngine;
using System.Collections;
using System.Runtime.Remoting.Messaging;
using DG.Tweening;
using DG.Tweening.Core;
using SLua;

[CustomLuaClass]
public class TweenSetting
{
    public static void OnComplete(Tweener t, Action callback)
    {
        t.OnComplete(() => callback());
    }

    public static void OnKill(Tweener t, Action callback)
    {
        t.OnKill(() => callback());
    }

    public static void OnPause(Tweener t, Action callback)
    {
        t.OnPause(() => callback());
    }

    public static void OnPlay(Tweener t, Action callback)
    {
        t.OnPlay(() => callback());
    }

    public static void OnRewind(Tweener t, Action callback)
    {
        t.OnRewind(() => callback());
    }

    public static void OnStart(Tweener t, Action callback)
    {
        t.OnStart(() => callback());
    }

    public static void OnStepComplete(Tweener t, Action callback)
    {
        t.OnStepComplete(() => callback());
    }

    public static void OnUpdate(Tweener t, Action callback)
    {
        t.OnUpdate(() => callback());
    }

    public static void SetAutoKill(Tweener t, bool autoKillOnCompletion)
    {
        t.SetAutoKill(autoKillOnCompletion);
    }

    public static void SetDelay(Tweener t, float delayTime)
    {
        t.SetDelay(delayTime);
    }

    public static void SetEase(Tweener t, Ease ease)
    {
        t.SetEase(ease);
    }

    public static void SetLoops(Tweener t, int loops, LoopType loopType)
    {
        t.SetLoops(loops, loopType);
    }

    public static void SetUpdate(Tweener t, bool isIndependentUpdate)
    {
        t.SetUpdate(isIndependentUpdate);
    }
}
