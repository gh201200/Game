using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace Server.Tool
{
    public class ConnHelper
    {
        private const string conStr = "datasource=localhost;port=3306;database=game;user=root;password=123456";

        public static MySqlConnection Connect()
        {
            try
            {
                MySqlConnection con = new MySqlConnection(conStr);
                con.Open();
                return con;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return null;
            }
        }

        public static void Close(MySqlConnection con)
        {
            if (con == null)
            {
                Console.WriteLine("the MySqlConnection you want to close is null!");
                return;
            }
            con.Close();
        }
    }
}
