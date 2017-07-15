using System;
using Server.Server;
using Server.Tool;
using System.Text;
using Server.Controller;

class Program
{
    static void Main(string[] args)
    {
        Server.Server.Server server = new Server.Server.Server("127.0.0.1", 88);
        server.Start();

        ControllerManager.Instance.Init();

        Console.ReadKey();
    }
}
