using System;
using Server.Server;
using Server.Tool;
using System.Text;
using Server.Controller;
using Server.Tool;
using MySql.Data.MySqlClient;

class Program
{
    static void Main(string[] args)
    {
        Server.Server.Server server = new Server.Server.Server("127.0.0.1", 88);
        server.Start();

        ControllerManager.Instance.Init();

        //MySqlConnection con = ConnHelper.Connect();
        //MySqlCommand cmd = new MySqlCommand();
        //cmd.CommandText = "select username from user;";
        //cmd.Connection = con;
        //MySqlDataReader reader = cmd.ExecuteReader();
        //if (reader.HasRows)
        //{
        //    while (reader.Read())
        //    {
        //        Console.WriteLine(reader.GetValue(0));
        //    }
        //}

        Console.ReadKey();
    }
}
