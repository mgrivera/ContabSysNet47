using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using ContabSysNet_Web.ModelosDatos;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Data.Common;
using System.Data.SqlClient;

namespace ContabSysNet_Web.webServices
{
    /// <summary>
    /// Summary description for Select2_GetData
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Select2_GetData : System.Web.Services.WebService
    {
        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        public class Select2DTO // as select2 is formed like id and text so we used DTO
        {
            public string id { get; set; }
            public string text { get; set; }
        }

        public class Select2DTO_paginate // as select2 is formed like id and text so we used DTO
        {
            public List<Select2DTO> items { get; set; }
            public Select2DTO_paginate_results resultParams { get; set; }
        }

        public class Select2DTO_paginate_results // as select2 is formed like id and text so we used DTO
        {
            public int page { get; set; }
            public int count_filtered { get; set; }
        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json)]
        public void AccessRemoteData(string search, int page, int cia)
        {
            try
            {
                dbContab_Contab_Entities dbContab = new dbContab_Contab_Entities();

                // 1) leemos la página de items seleccionados 
                var query =
                    "Select Cuenta as id, Descripcion as text From CuentasContables " +
                    "Where (Cuenta Like '%' + @search + '%' Or Descripcion Like '%' + @search + '%') And Cia = @cia " +
                    "Order by Cuenta, Descripcion Offset @offset Rows Fetch Next 20 Rows Only"; 

                var args = new DbParameter[] { new SqlParameter { ParameterName = "cia", Value = cia },
                                               new SqlParameter { ParameterName = "search", Value = search },
                                               new SqlParameter { ParameterName = "offset", Value = ((page - 1) * 20) },
                };

                var cuentasContables = dbContab.ExecuteStoreQuery<Select2DTO>(query, args).ToList();

                // 2) leemos la cantidad de registros que corresonden a la selección 
                query =
                    "Select Count(*) as count_filtered From CuentasContables " +
                    "Where (Cuenta Like '%' + @search + '%' Or Descripcion Like '%' + @search + '%') And Cia = @cia ";

                args = new DbParameter[] { new SqlParameter { ParameterName = "cia", Value = cia },
                                               new SqlParameter { ParameterName = "search", Value = search }
                };

                Int32 count_filtered = dbContab.ExecuteStoreQuery<int>(query, args).First();
 
                var r = new Select2DTO_paginate { items = cuentasContables,
                                                  resultParams = new Select2DTO_paginate_results { page = page, count_filtered = count_filtered } };





                JavaScriptSerializer js = new JavaScriptSerializer();
                var sResult = js.Serialize(r);

                Context.Response.Write(sResult);
            }
            catch (Exception ex)
            {
                Context.Response.Write(ex.Message.ToString());
            }
        }
    }
}
    
