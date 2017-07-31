using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;

namespace FileServer.Controller
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
                Console.WriteLine("the key {0} is not in clientMap!", adress);
                return;
            }
            if (clientMap[adress] != null) clientMap[adress].Socket.Close();
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
