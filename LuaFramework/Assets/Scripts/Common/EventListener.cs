using System;
using UnityEngine;
using System.Collections;
using SLua;
using UnityEngine.EventSystems;

[CustomLuaClass]
public class EventListener : UIBehaviour, IPointerClickHandler, IPointerDownHandler, IPointerUpHandler, IPointerEnterHandler, IPointerExitHandler, IBeginDragHandler, IDragHandler, IEndDragHandler, IDropHandler, IScrollHandler
{
    public Action<PointerEventData> onClick;
    public Action<PointerEventData> onDown;
    public Action<PointerEventData> onUp;
    public Action<PointerEventData> onEnter;
    public Action<PointerEventData> onExit;
    public Action<PointerEventData> onBeginDrag;
    public Action<PointerEventData> onDrag;
    public Action<PointerEventData> onEndDrag;
    public Action<PointerEventData> onDrop;
    public Action<PointerEventData> onScroll;

    public void OnPointerClick(PointerEventData eventData)
    {
        if (onClick != null)
            onClick(eventData);
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (onDown != null)
            onDown(eventData);
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if (onUp != null)
            onUp(eventData);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        if (onEnter != null)
            onEnter(eventData);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        if (onExit != null)
            onExit(eventData);
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        if (onBeginDrag != null)
            onBeginDrag(eventData);
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (onDrag != null)
            onDrag(eventData);
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        if (onEndDrag != null)
            onEndDrag(eventData);
    }

    public void OnDrop(PointerEventData eventData)
    {
        if (onDrop != null)
            onDrop(eventData);
    }

    public void OnScroll(PointerEventData eventData)
    {
        if (onScroll != null)
            onScroll(eventData);
    }

    public static EventListener Get(GameObject go)
    {
        var res = go.GetComponent<EventListener>();
        if (res == null) res = go.AddComponent<EventListener>();
        return res;
    }
}
