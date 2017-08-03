//using System;
//using MySql.Data.MySqlClient;

//namespace TcpServer
//{
//    public class ConnHelper
//    {
//        private const string conStr = "datasource=localhost;port=3306;database=game;user=root;password=123456";

//        public static MySqlConnection Connect()
//        {
//            try
//            {
//                MySqlConnection con = new MySqlConnection(conStr);
//                if (con.Ping())
//                {
//                    con.Open();
//                    return con;
//                }
//                Console.WriteLine("failed to connect to mysql database!");
//                return null;
//            }
//            catch (Exception e)
//            {
//                Console.WriteLine(e);
//                return null;
//            }
//        }

//        public static void Close(MySqlConnection con)
//        {
//            if (con == null)
//            {
//                Console.WriteLine("the MySqlConnection you want to close is null!");
//                return;
//            }
//            con.Close();
//        }
//    }
//}
