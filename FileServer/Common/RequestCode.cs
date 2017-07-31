using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public enum RequestCode
{
    None = 0,

    /// <summary>
    /// 文件操作相关
    /// </summary>
    File,
}

public enum ActionCode
{
    None = 0,

    /// <summary>
    /// 检查文件更新
    /// </summary>
    CheckUpdateFile,

    /// <summary>
    /// 上传文件
    /// </summary>
    UploadFile,
}
