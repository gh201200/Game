using UnityEngine;
using System.Collections;
using SLua;
using DG.Tweening;

public static class Extension
{
    public static void FixedPositionInCanvas(this RectTransform _source, RectTransform _canvas)
    {
        Rect rect = new Rect(Vector2.zero, _canvas.sizeDelta);
        _source.FixedPositionInCanvas(_canvas, rect);
    }

    public static void FixedPositionInCanvas(this RectTransform _source, RectTransform _canvas, Rect _rect)
    {
        Bounds bounds = RectTransformUtility.CalculateRelativeRectTransformBounds(_canvas, _source);
        Vector2 zero = Vector2.zero;
        Vector3 center = bounds.center;
        center.x += _canvas.sizeDelta.x * 0.5f;
        center.y += _canvas.sizeDelta.y * 0.5f;
        bounds.center = center;
        if ((bounds.center.x - bounds.extents.x) < _rect.x)
        {
            zero.x += Mathf.Abs((float)((bounds.center.x - bounds.extents.x) - _rect.x));
        }
        else if ((bounds.center.x + bounds.extents.x) > _rect.width)
        {
            zero.x -= Mathf.Abs((float)((bounds.center.x + bounds.extents.x) - _rect.width));
        }
        if ((bounds.center.y - bounds.extents.y) < _rect.y)
        {
            zero.y += Mathf.Abs((float)((bounds.center.y - bounds.extents.y) - _rect.y));
        }
        else if ((bounds.center.y + bounds.extents.y) > _rect.height)
        {
            zero.y -= Mathf.Abs((float)((bounds.center.y + bounds.extents.y) - _rect.height));
        }
        _source.anchoredPosition += zero;
    }
}
