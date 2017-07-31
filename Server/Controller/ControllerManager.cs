using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common;
using System.Reflection;

namespace Server.Controller
{
    public class ControllerManager
    {
        private static ControllerManager _instance;
        private Dictionary<OperationCode, BaseController> controllerDic = new Dictionary<OperationCode, BaseController>();

        public static ControllerManager Instance
        {
            get
            {
                if (_instance == null) _instance = new ControllerManager();
                //_instance.Init();
                return _instance;
            }
        }

        public void Init()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            Type[] ts = assembly.GetTypes();
            foreach (Type t in ts)
            {
                if (t.IsSubclassOf(typeof(BaseController)))
                {
                    BaseController co = Activator.CreateInstance(t) as BaseController;
                    if (!controllerDic.ContainsKey(co.RequestCode))
                    {
                        controllerDic.Add(co.RequestCode, co);
                    }
                }
            }
        }

        public BaseController GetController(OperationCode requestCode)
        {
            return controllerDic[requestCode];
        }
    }
}
