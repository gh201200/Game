﻿using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
/**

namespace Hugula.UGUIExtend
{
    /// <summary>
    /// 事件接受并抛给lua
    /// </summary>
    [SLua.CustomLuaClass]
    public class CEventReceive : MonoBehaviour//, ISelectHandler//,IPointerClickHandler, IPointerDownHandler, IPointerUpHandler, IBeginDragHandler, IDragHandler, IDropHandler, ICancelHandler
    {

        public void OnPointerDown(BaseEventData eventData)
        {
            var g = eventData.selectedObject;
            UGUIEvent.onPressHandle(g, eventData);
        }

        public void OnPointerUp(BaseEventData eventData)
        {
            var g = eventData.selectedObject;
            UGUIEvent.onPressHandle(g, eventData);
        }

        //public void OnBeginDrag(BaseEventData eventData)
        //{
        //    var g = EventSystem.current.currentSelectedGameObject;
        //    UGUIEvent.onCancelHandle(g, eventData);
        //}

        public void OnDrag(BaseEventData eventData)
        {
            var g = eventData.selectedObject;
            PointerEventData ped = eventData as PointerEventData;
            UGUIEvent.onDragHandle(g, ped.delta);
        }

        public void OnDrop(BaseEventData eventData)
        {
            var g = eventData.selectedObject;
            UGUIEvent.onDropHandle(g, eventData);
        }

        public void OnPointerClick(BaseEventData eventData)
        {
            //PointerEventData ped = eventData as PointerEventData;
            var g = eventData.selectedObject;
            UGUIEvent.onClickHandle(g, eventData);
        }

        public void OnSelect(BaseEventData eventData)
        {
            var g = eventData.selectedObject;
            UGUIEvent.onSelectHandle(g, eventData);
        }

        public void OnCancel(BaseEventData eventData)
        {
            var g = eventData.selectedObject;
            UGUIEvent.onCancelHandle(g, eventData);
        }

        public void OnButtonClick(MonoBehaviour arg)
        {
            var g = EventSystem.current.currentSelectedGameObject;
            UGUIEvent.onClickHandle(g, arg); //Debug.Log("you are click "+g);
        }

        public void OnButtonClick(Object arg)
        {
            var g = EventSystem.current.currentSelectedGameObject;
            UGUIEvent.onClickHandle(g, arg); //Debug.Log("you are click "+g);
        }


        public void OnCustomerEvent(MonoBehaviour arg)
        {
            var g = EventSystem.current.currentSelectedGameObject;
            UGUIEvent.onCustomerHandle(g, arg); //Debug.Log("you are click "+g);
        }

        public void OnCustomerEvent(Object arg)
        {
            var g = EventSystem.current.currentSelectedGameObject;
            UGUIEvent.onCustomerHandle(g, arg); //Debug.Log("you are click "+g);
        }
    }
}