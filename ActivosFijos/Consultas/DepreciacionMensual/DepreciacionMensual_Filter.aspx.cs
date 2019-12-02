using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.ActivosFijos;
using ContabSysNet_Web.Clases;

namespace ContabSysNet_Web.ActivosFijos.Consultas.DepreciacionMensual
{
    public partial class DepreciacionMensual_Filter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
             Master.Page.Title = "... defina un filtro y haga un click en Aplicar Filtro para aplicarlo";

             if (!User.Identity.IsAuthenticated)
             {
                 FormsAuthentication.SignOut();
                 return;
             }

             if (!Page.IsPostBack)
             {
                 // usamos una clase para construir una lista con las compañías (Contab) que se han asignado al usuario 
                 ConstruirListaCompaniasAsignadas listaCiasContabAsignadas = new ConstruirListaCompaniasAsignadas();
                 this.Sql_it_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                 //  pareciera que si no hacemos el databind para los listboxes aquí, la clase que regresa el state 
                 //  encuentra estos controles sin sus datos 
                 this.Sql_it_Cia_Numeric.DataBind();
                this.Sql_it_Moneda_Numeric.DataBind(); 
                 this.Sql_it_Proveedor_Numeric.DataBind();
                 this.Sql_it_Departamento_Numeric.DataBind();
                 this.Sql_it_Tipo_Numeric.DataBind();
                 this.lst_Atributos.DataBind(); 

                 //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

                 if (!(Membership.GetUser().UserName == null))
                 {
                     KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                     MyKeepPageState.ReadStateFromFile(this, this.Controls);
                     MyKeepPageState = null;
                 }

                 this.AplicarFiltro_Button.Focus(); 
             }
        }

        protected void LimpiarFiltro_Button_Click(object sender, EventArgs e)
        {
            LimpiarFiltro MyLimpiarFiltro = new LimpiarFiltro(this);
            MyLimpiarFiltro.LimpiarControlesPagina();
            MyLimpiarFiltro = null;
        }

        protected void AplicarFiltro_Button_Click(object sender, EventArgs e)
        {
            // nótese como excluímos el item dPagos.FechaPago, que tratamos en forma separada más adelante 
            BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
            MyConstruirCriterioSql.LinqToEntities = true;       // para que regrese un filtro apropiado para linq to entities ... 
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;

            // las fechas no tienen un nombre adecuado para que la clase anterior las incluya al filtro; preferimos hacerlo aquí, de esta forma
            if (!String.IsNullOrEmpty(this.fCompra_desde.Text))
            {
                if (!String.IsNullOrEmpty(this.fCompra_hasta.Text))
                {
                    // el usuario usó ambas fechas para indicar un período 
                    sSqlSelectString = sSqlSelectString + " And (it.FechaCompra Between DateTime'" + Convert.ToDateTime(this.fCompra_desde.Text).ToString("yyyy-MM-dd H:m:s") + "'";
                    sSqlSelectString = sSqlSelectString + " And DateTime'" + Convert.ToDateTime(this.fCompra_hasta.Text).ToString("yyyy-MM-dd H:m:s") + "')";
                }
                else
                {
                    // el usuario usó solo la fecha de inicio para buscar solo para esa fecha 
                    sSqlSelectString = sSqlSelectString + " And (it.FechaCompra = DateTime'" + Convert.ToDateTime(this.fCompra_desde.Text).ToString("yyyy-MM-dd H:m:s") + "'";
                }
            }

            if (!String.IsNullOrEmpty(this.fDesincorporacion_desde.Text))
            {
                if (!String.IsNullOrEmpty(this.fDesincorporacion_hasta.Text))
                {
                    // el usuario usó ambas fechas para indicar un período 
                    sSqlSelectString = sSqlSelectString + " And (it.FechaDesincorporacion Between DateTime'" + Convert.ToDateTime(this.fDesincorporacion_desde.Text).ToString("yyyy-MM-dd H:m:s") + "'";
                    sSqlSelectString = sSqlSelectString + " And DateTime'" + Convert.ToDateTime(this.fDesincorporacion_hasta.Text).ToString("yyyy-MM-dd H:m:s") + "')";
                }
                else
                {
                    // el usuario usó solo la fecha de inicio para buscar solo para esa fecha 
                    sSqlSelectString = sSqlSelectString + " And (it.FechaDesincorporacion = DateTime'" + Convert.ToDateTime(this.fDesincorporacion_desde.Text).ToString("yyyy-MM-dd H:m:s") + "'";
                }
            }



            // ---------------------------------------------------------------------------------------------------------------------
            // si el usuario seleccionó uno o varios atributos, agregamos el criterio en forma separada aquí ... 
            var selectedItems = from ListItem i in this.lst_Atributos.Items where i.Selected select i;

            string filtroAtributos = ""; 

            foreach (var selectedItem in selectedItems) 
            {
                // buscamos el registro en la tabla AtributosAsignados y construimos el criterio 
                if (filtroAtributos == "")
                    filtroAtributos = "it.AtributoID IN {" + selectedItem.Value.ToString(); 
                else
                    filtroAtributos += ", " + selectedItem.Value.ToString(); 
            }

            // si el usuario seleccionó atributos, buscamos los ID de activos fijos en la tabla AtributosAsignados ... 
            if (filtroAtributos != "")
            {
                filtroAtributos += "}"; 

                dbContab_ActFijos_Entities actFijos_context = new dbContab_ActFijos_Entities();

                string filtroAtributosActivosFijos = "";

                var queryAtributosAsignados = (from a in actFijos_context.AtributosAsignados.Where(filtroAtributos)
                                               select a.ActivoFijoID).Distinct();

                foreach (int a in queryAtributosAsignados)
                {
                    if (filtroAtributosActivosFijos == "")
                        filtroAtributosActivosFijos = "it.ClaveUnica IN {" + a.ToString(); 
                    else
                        filtroAtributosActivosFijos += ", " + a.ToString(); 
                }

                if (filtroAtributosActivosFijos != "")
                {
                    filtroAtributosActivosFijos += "}";
                    sSqlSelectString += " And (" + filtroAtributosActivosFijos + ")"; 
                }
            }
            // ---------------------------------------------------------------------------------------------------------------------
            Session["FiltroForma"] = sSqlSelectString;

            // ------------------------------------------------------------------------------------------------
            // guardamos las fechas del período para posterior referencia
            Session["ActFijos_Consulta_Mes"] = Convert.ToInt16(this.drpdwn_MesConsulta.SelectedValue);
            Session["ActFijos_Consulta_Ano"] = Convert.ToInt16(this.txt_AnoConsulta.Text);
            Session["ActFijos_ExcluirDepreciadosAnosAnteriores"] = Convert.ToBoolean(this.ckh_ExcluirDepreciadosAnosAnteriores.Checked);
            Session["ActFijos_AplicarInfoDesincorporacion"] = Convert.ToBoolean(this.chk_AplicarInfoDesincorporacion.Checked);

            // mostramos el nombre del mes de la consulta en el encabezado de la lista que ve el usuario 
            Session["ActFijos_Consulta_NombreMes"] = this.drpdwn_MesConsulta.SelectedItem.Text; 

            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;

            // ------------------------------------------------------------------------------------------------------
            // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false);
        }
    }
}