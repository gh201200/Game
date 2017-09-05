using UnityEngine;
using System.Collections;
using SLua;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System;

[CustomLuaClass]
public class UIButton : Selectable, IPointerClickHandler, IDropHandler
{
    public OnPointerDownEvent onDown;
    public OnPointerUpEvent onUp;
    public OnPointerEnterEvent onEnter;
    public OnPointerExitEvent onExit;
    public OnPointerClickEvent onClick;
    public OnPointerDropEvent onDrop;

    public UIButton()
    {
        onDown = new OnPointerDownEvent();
        onUp = new OnPointerUpEvent();
        onEnter = new OnPointerEnterEvent();
        onExit = new OnPointerExitEvent();
        onClick = new OnPointerClickEvent();
        onDrop = new OnPointerDropEvent();
    }

    [System.Serializable]
    [CustomLuaClass]
    public class OnPointerDownEvent : UnityEvent<PointerEventData> { }

    [System.Serializable]
    [CustomLuaClass]
    public class OnPointerUpEvent : UnityEvent<PointerEventData> { }

    [System.Serializable]
    [CustomLuaClass]
    public class OnPointerEnterEvent : UnityEvent<PointerEventData> { }

    [System.Serializable]
    [CustomLuaClass]
    public class OnPointerExitEvent : UnityEvent<PointerEventData> { }

    [System.Serializable]
    [CustomLuaClass]
    public class OnPointerClickEvent : UnityEvent<PointerEventData> { }

    [System.Serializable]
    [CustomLuaClass]
    public class OnPointerDropEvent : UnityEvent<PointerEventData> { }

    public override void OnPointerDown(PointerEventData eventData)
    {
        base.OnPointerDown(eventData);
        if (onDown != null) onDown.Invoke(eventData);
    }

    public override void OnPointerUp(PointerEventData eventData)
    {
        base.OnPointerUp(eventData);
        if (onUp != null) onUp.Invoke(eventData);
    }

    public override void OnPointerEnter(PointerEventData eventData)
    {
        base.OnPointerEnter(eventData);
        if (onEnter != null) onEnter.Invoke(eventData);
    }

    public override void OnPointerExit(PointerEventData eventData)
    {
        base.OnPointerExit(eventData);
        if (onExit != null) onExit.Invoke(eventData);
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (onClick != null) onClick.Invoke(eventData);
    }

    public void OnDrop(PointerEventData eventData)
    {
        if (onDrop != null) onDrop.Invoke(eventData);
    }

    public static UIButton Get(GameObject go)
    {
        var res = go.GetComponent<UIButton>();
        if (res == null) res = go.AddComponent<UIButton>();
        return res;
    }
}
