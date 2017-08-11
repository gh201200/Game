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
            string conStr = @"database=mydb;datasource=localhost;port=3306;userid=root;password=123456";
            MySqlConnection con = new MySqlConnection(conStr);
            con.Open();

            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "select * from item";
            MySqlDataReader reader = cmd.ExecuteReader();
            HashSet<object[]> list = new HashSet<object[]>();
            HashSet<int> deleteList = new HashSet<int>();
            Dictionary<object, object[]> newList = new Dictionary<object, object[]>();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    object[] res = new object[3];
                    reader.GetValues(res);
                    list.Add(res);
                    //foreach (var obj in res)
                    //{
                    //    Console.Write(obj + "     ");
                    //}
                    //Console.WriteLine();
                }
                reader.Close();
            }

            foreach (var array1 in list)
            {
                foreach (var array2 in list)
                {
                    if (array1[0] == array2[0] && array1[1] == array2[1])
                    {
                        int sum = int.Parse(array1[2].ToString()) + int.Parse(array2[2].ToString());
                        if (!deleteList.Contains(int.Parse(array1[0].ToString()))) deleteList.Add(int.Parse(array1[0].ToString()));
                        object[] obj = { array1[0], array1[1], sum };
                        if (!newList.ContainsKey(array1[0])) newList.Add(array1[0], obj);
                    }
                }
            }

            foreach (var id in deleteList)
            {
                MySqlCommand deleteCmd = new MySqlCommand("delete from item where heroid = @value;", con);
                deleteCmd.Parameters.AddWithValue("value", id);
                deleteCmd.ExecuteNonQuery();
            }

            foreach (var temp in newList)
            {
                MySqlCommand addCmd = new MySqlCommand("insert item values(@heroid, @itemid, @num);", con);
                addCmd.Parameters.AddWithValue("heroid", temp.Value[0]);
                addCmd.Parameters.AddWithValue("itemid", temp.Value[1]);
                addCmd.Parameters.AddWithValue("num", temp.Value[2]);
                addCmd.ExecuteNonQuery();
            }

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
            //}

            #endregion


            //new MySqlCommand("delete from user;", con).ExecuteNonQuery();

            //for (int i = 0; i < 10; i++)
            //{
            //    string user = "user" + i;
            //    if (!ContainsData(con, user))
            //    {
            //        MySqlCommand c = new MySqlCommand("insert user set user = @user, password = '123456';", con);
            //        c.Parameters.AddWithValue("user", user);
            //        c.ExecuteNonQuery();
            //    }
            //}

            //MySqlCommand cmd = new MySqlCommand();
            //cmd.Connection = con;
            //cmd.CommandText = "select * from user;";
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
            //}
            //reader.Close();

            con.Close();
            Console.ReadKey();
        }

        /// <summary>
        /// 是否包含表
        /// </summary>
        /// <param name="con"></param>
        /// <param name="tableName"></param>
        /// <returns></returns>
        static bool ContainsTable(MySqlConnection con, string tableName)
        {
            bool exists = false;
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "select table_name from information_schema where table_schema = 'user' and table_name = @tablename;";
            cmd.Parameters.AddWithValue("tablename", tableName);
            MySqlDataReader reader = cmd.ExecuteReader();
            exists = reader.HasRows;
            reader.Close();
            return exists;
        }

        /// <summary>
        /// 表中是否包含某列
        /// </summary>
        /// <param name="con"></param>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        static bool ContainsColumn(MySqlConnection con, string tableName, string columnName)
        {
            bool exists = false;
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "select column_name from information_schema.columns where table_name = @tablename and column_name = @columnname;";
            cmd.Parameters.AddWithValue("tablename", tableName);
            cmd.Parameters.AddWithValue("columnname", columnName);
            MySqlDataReader reader = cmd.ExecuteReader();
            exists = reader.HasRows;
            reader.Close();
            return exists;
        }

        /// <summary>
        /// 查询是否包含某个具体的值
        /// </summary>
        /// <param name="con">mysql连接</param>
        /// <param name="tableName">表名</param>
        /// <param name="columnName">列名</param>
        /// <param name="data">查询的数据</param>
        /// <returns></returns>
        static bool ContainsData(MySqlConnection con, string data)
        {
            //if (!ContainsTable(con, tableName))
            //{
            //    Console.WriteLine("table {0} is not exists", tableName);
            //    return false;
            //}
            //if (!ContainsColumn(con, tableName, columnName))
            //{
            //    Console.WriteLine("table {0} column {1} is not exists", tableName, columnName);
            //    return false;
            //}
            bool exists = false;
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "select user from user where user = @data;";
            cmd.Parameters.AddWithValue("data", data);
            MySqlDataReader reader = cmd.ExecuteReader();
            exists = reader.HasRows;
            reader.Close();
            return exists;
        }
    }
}
