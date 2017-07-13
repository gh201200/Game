using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace MySQL
{
    class Program
    {
        static void Main(string[] args)
        {
            string conStr = @"database=user;datasource=localhost;port=3306;userid=root;password=123456";
            MySqlConnection con = new MySqlConnection(conStr);
            con.Open();

            #region 查询
            //MySqlCommand cmd = new MySqlCommand("select * from user;", con);
            ////MySqlCommand addcmd = new MySqlCommand("insert user (user, password) values ('赵云', 'zy123456')", con);

            ////int returnCode = addcmd.ExecuteNonQuery();
            ////Console.WriteLine("returen code " + returnCode);
            //MySqlDataReader reader = cmd.ExecuteReader();

            //if (!reader.HasRows) return;

            //while (reader.Read())
            //{
            //    int id = reader.GetInt32("id");
            //    string userName = reader.GetString("user");
            //    string passwd = reader.GetString("password");
            //    Console.Write(id + "\t" + userName + "\t" + passwd);
            //    Console.WriteLine();
            //}
            //reader.Close();
            #endregion

            #region 插入
            //string userName = "shabi";
            //string passwd = "123456";

            //MySqlCommand cmd = new MySqlCommand("insert user set user = @user, password = @passwd", con);
            //cmd.Parameters.AddWithValue("user", userName);
            //cmd.Parameters.AddWithValue("passwd", passwd);
            //cmd.ExecuteNonQuery();
            #endregion

            #region 是否包含记录
            //string userName = "曹操";
            //MySqlCommand cmd = new MySqlCommand("select * from user where user = @userName;", con);
            //cmd.Parameters.AddWithValue("userName", userName);
            //MySqlDataReader reader = cmd.ExecuteReader();

            //bool exists = reader.HasRows;

            //if (reader.Read())
            //{
            //    object[] values = new object[10];
            //    int count = reader.GetValues(values);
            //    for (int i = 0; i < count; i++)
            //    {
            //        Console.WriteLine("read data: " + values[i]);
            //    }
            //    reader.Close();
            //}

            //Console.WriteLine("exists; " + exists);
            #endregion

            #region 删除
            //MySqlCommand cmd = new MySqlCommand("delete from user where id = @id;", con);
            //cmd.Parameters.AddWithValue("id", 7);
            //cmd.ExecuteNonQuery();
            #endregion

            #region 更新
            //MySqlCommand cmd = new MySqlCommand("update user set password = @pwd where user = 'gaoheng';", con);
            //cmd.Parameters.AddWithValue("pwd", "modifiered password");
            //cmd.ExecuteNonQuery();
            #endregion

            #region 测试
            //MySqlCommand cmd = new MySqlCommand("select * from user;", con);
            //MySqlDataReader reader = cmd.ExecuteReader();
            //if (reader.HasRows)
            //{
            //    while (reader.Read())
            //    {
            //        object[] values = new object[3];
            //        reader.GetValues(values);
            //        foreach (object o in values)
            //        {
            //            Console.Write(o + "\t");
            //        }
            //        Console.WriteLine();
            //    }
            //    con.Close();
            //}
            #endregion

            Console.ReadKey();
        }
    }
}
