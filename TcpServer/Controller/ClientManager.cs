using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace TcpServer.Controller
{
    public class ClientManager
    {
        static Dictionary<string, Client> clientMap = new Dictionary<string, Client>();

        public static void AddClient(string adress, Client client)
        {
            if (clientMap.ContainsKey(adress))
            {
                Console.WriteLine("clientMap is aready contains the key: " + adress);
                return;
            }
            clientMap.Add(adress, client);
        }

        public static void RemoveClient(string adress)
        {
            if (!clientMap.ContainsKey(adress))
            {
                StackTrace st = new StackTrace(false);
                Console.WriteLine("the key {0} is not in clientMap!\n{1}", adress, st);
                return;
            }
            if (clientMap[adress] != null) clientMap[adress].Close();
            clientMap.Remove(adress);
        }

        public static Client Get(string adress)
        {
            if (!clientMap.ContainsKey(adress))
            {
                Console.WriteLine("client {0} is not in clientMap!", adress);
                return null;
            }
            return clientMap[adress];
        }

        public static Dictionary<string, Client> GetClientMap()
        {
            return clientMap;
        }
    }
}
