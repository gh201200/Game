using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common;

namespace TcpServer
{
    public class Config
    {
        public int Port { get; private set; }

        public int ReceiveLength_EachTime { get; private set; }

        public string SaveDirectory { get; private set; }

        private Dictionary<string, object> dic;

        public Config(string config)
        {
            if (!File.Exists(config))
            {
                Console.WriteLine("Config.json is not found!");
                return;
            }
            StreamReader sr = File.OpenText(config);
            dic = Json.Deserialize(sr.ReadToEnd()) as Dictionary<string, object>;
            sr.Close();
            if (dic == null || dic.Count <= 0)
            {
                Console.WriteLine("failed to read 'Config.json'");
                return;
            }
            Port = int.Parse(dic["Port"].ToString());
            ReceiveLength_EachTime = int.Parse(dic["ReceiveLength_EachTime"].ToString());
            SaveDirectory = dic["SaveDirectory"].ToString();
        }
    }
}
