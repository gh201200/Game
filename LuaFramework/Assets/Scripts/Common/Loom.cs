using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Threading;
using System.Linq;

public class Loom : MonoBehaviour
{
    public static int maxThreads = 8;
    static int numThreads;

    private static Loom _instance;

    private List<Action> actions = new List<Action>();
    private List<Action> currentActions = new List<Action>();

    private int _count;

    public static Loom Instance
    {
        get
        {
            if (!_instance)
            {

                if (!Application.isPlaying) return null;
                _instance = Root.Instance.gameObject.AddComponent<Loom>();

            }
            return _instance;
        }
    }

    public struct DelayedQueueItem
    {
        public float time;
        public Action action;
    }
    private List<DelayedQueueItem> delayed = new List<DelayedQueueItem>();

    List<DelayedQueueItem> currentDelayed = new List<DelayedQueueItem>();

    public static void QueueOnMainThread(Action action)
    {
        QueueOnMainThread(action, 0f);
    }
    public static void QueueOnMainThread(Action action, float time)
    {
        if (time != 0)
        {
            lock (Instance.delayed)
            {
                Instance.delayed.Add(new DelayedQueueItem { time = Time.time + time, action = action });
            }
        }
        else
        {
            lock (Instance.actions)
            {
                Instance.actions.Add(action);
            }
        }
    }

    public void RunAsync(Action a)
    {
        while (numThreads >= maxThreads)
        {
            Thread.Sleep(1);
        }
        Interlocked.Increment(ref numThreads);
        ThreadPool.QueueUserWorkItem(RunAction, a);
    }

    private void RunAction(object action)
    {
        try
        {
            ((Action)action)();
        }
        catch
        {
        }
        finally
        {
            Interlocked.Decrement(ref numThreads);
        }

    }


    private void OnDisable()
    {
        if (_instance == this)
        {

            _instance = null;
        }
    }

    private void Update()
    {
        lock (actions)
        {
            currentActions.Clear();
            currentActions.AddRange(actions);
            actions.Clear();
        }
        foreach (var a in currentActions)
        {
            a();
        }
        lock (delayed)
        {
            currentDelayed.Clear();
            currentDelayed.AddRange(delayed.Where(d => d.time <= Time.time));
            foreach (var item in currentDelayed)
                delayed.Remove(item);
        }
        foreach (var temp in currentDelayed)
        {
            temp.action();
        }
    }
}
