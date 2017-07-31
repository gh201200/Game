using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common
{
    public enum OperationCode
    {
        None = 0,
        
        /// <summary>
        /// 检测文件是否存在
        /// </summary>
        CheckUpdate,

        /// <summary>
        /// 上传文件
        /// reponse: 服务端已写入的文件长度
        /// </summary>
        UploadFile,
    }
}
