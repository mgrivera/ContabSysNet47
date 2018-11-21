using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Clases
{
    public class WriteStringToFile
    {
        // recibe un string simple y lo escribe a un archivo en el servidor ... 

        private string _filePathName;

        public WriteStringToFile(string filePathName)
        {
            _filePathName = filePathName;
        }

        public bool WriteToDisk(string stringBytes, out string errorMessage) 
        {
            errorMessage = "";

            try
            {
                File.WriteAllText(_filePathName, stringBytes);
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                return false; 
            }

            return true; 
        }
    }

    public class ReadStringFromFile
    {
        // lee un string simple de un archivo en el servidor ... 
        private string _filePathName;

        public ReadStringFromFile(string fileName)
        {
            _filePathName = fileName;
        }

        public bool ReadFromDisk(out string stringFileContent, out string errorMessage) 
        {
            errorMessage = "";
            stringFileContent = "";
            try
            {
                stringFileContent = File.ReadAllText(_filePathName);
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                return false; 
            }

            if (stringFileContent == "")
            {
                errorMessage = "Error: aunque, aparentemente, el archivo (json) que contiene el objeto 'json' se ha leído con éxito, " + 
                    "su contenido es vacío. Por favor revise."; 
                return false;
            }

            return true; 
        }
    }
}