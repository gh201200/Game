using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common
{
    public enum OperationType
    {
        Request,

        Response,
    }

    public enum OperationCode
    {
        None = 0,

        /// <summary>
        /// 显示文字消息
        /// </summary>
        ShowMessage,

        /// <summary>
        /// 上传文件
        /// </summary>
        UploadFile,
    }
}
