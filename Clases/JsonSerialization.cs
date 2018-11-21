using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization.Json;
using System.IO;
using System.Text;

namespace ContabSysNet_Web.Clases
{
    public class JSONHelper
    {
        // helpers to serialize y deserialize objects to string using json serialization 

        public static string Serialize<T>(T obj)
        {
            DataContractJsonSerializer serializer = new DataContractJsonSerializer(obj.GetType());
            MemoryStream ms = new MemoryStream();
            serializer.WriteObject(ms, obj);

            //string retVal = ms.ToString();
            //ms.Dispose();
            //return retVal;


            byte[] bytes = ms.ToArray();
            ms.Close();

            return System.Text.Encoding.UTF8.GetString(bytes, 0, bytes.Length);
        }

        public static T Deserialize<T>(string json)
        {
            T obj = Activator.CreateInstance<T>();
            MemoryStream ms = new MemoryStream(Encoding.Unicode.GetBytes(json));
            DataContractJsonSerializer serializer = new DataContractJsonSerializer(obj.GetType());
            obj = (T)serializer.ReadObject(ms);
            ms.Close();
            ms.Dispose();
            return obj;
        }
    }
}