using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

public class TimeManager : MonoBehaviour
{
    private int index = 0;
    private Dictionary<int, Timer> map = new Dictionary<int, Timer>();

    private static TimeManager _instance;

    public static TimeManager Instance
    {
        get
        {
            if (_instance == null) _instance = Root.Instance.gameObject.AddComponent<TimeManager>();
            return _instance;
        }
    }

    /// <summary>
    /// 单次延时执行
    /// </summary>
    /// <param name="delay">延迟时间（毫秒）</param>
    /// <param name="callback">回调方法</param>
    /// <returns>返回一个延时ID，用于删除延时器</returns>
    public int Add(double delay, Action callback)
    {
        return AddCycle(delay, 0, callback);
    }

    /// <summary>
    /// 循环执行
    /// </summary>
    /// <param name="delay">延迟时间（毫秒）</param>
    /// <param name="cycle">执行周期（毫秒）</param>
    /// <param name="callback">回调函数</param>
    /// <returns>返回一个延时ID，用于删除延时器</returns>
    public int AddCycle(double delay, double cycle, Action callback)
    {
        int id = ++index;
        if (map.ContainsKey(id))
        {
            Debug.LogError("has same TimeManager id!");
            return 0;
        }
        Timer t = new Timer();
        t.id = id;
        t.ready = true;
        t.delay = delay;
        t.cycle = cycle;
        t.nextInvokeTime = DateTime.Now.AddMilliseconds(delay);
        t.callback = callback;
        map.Add(id, t);
        return id;
    }

    /// <summary>
    /// 删除一个延时器
    /// 单次延时器执行完之后会自动删除
    /// </summary>
    /// <param name="id">创建延时器时返回的id</param>
    public void Delete(int id)
    {
        if (map.ContainsKey(id))
        {
            try
            {
                Timer t = map[id];
                StopCoroutine(t.coroutine);
                map.Remove(id);
            }
            catch (Exception e)
            {
                Debug.LogError(e);
            }
        }
    }

    /// <summary>
    /// 删除所有延时器
    /// </summary>
    public void DeleteAll()
    {
        StopAllCoroutines();
        map.Clear();
    }

    private void Update()
    {
        if (map.Count > 0)
        {
            foreach (var p in map)
            {
                if (p.Value.ready && DateTime.Now >= p.Value.nextInvokeTime)
                {
                    DoDelay(p.Value);
                }
            }
        }
    }

    private void DoDelay(Timer timer)
    {
        timer.ready = false;
        timer.coroutine = StartCoroutine(_DoDelay(timer));
    }

    private IEnumerator _DoDelay(Timer timer)
    {
        float second = (float)((timer.delay - Time.deltaTime * 1000) / 1000f);
        timer.delay = 0f;
        yield return new WaitForSeconds(second);
        timer.callback();
        if (timer.cycle > 0)
        {
            timer.nextInvokeTime = DateTime.Now.AddMilliseconds(timer.cycle - Time.deltaTime * 1000);
            timer.ready = true;
        }
        else
        {
            Delete(timer.id);
        }
    }

    class Timer
    {
        /// <summary>
        /// 延时器id
        /// </summary>
        public int id;
        /// <summary>
        /// 是否可以立即调用
        /// </summary>
        public bool ready;
        /// <summary>
        /// 延时单位（毫秒）
        /// </summary>
        public double delay;
        /// <summary>
        /// 执行周期（毫秒）
        /// </summary>
        public double cycle;
        /// <summary>
        /// 下次调用的时间
        /// </summary>
        public DateTime nextInvokeTime;
        /// <summary>
        /// 回调方法
        /// </summary>
        public Action callback;
        public Coroutine coroutine;
    }
}
