using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.Entity;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Web.ModelBinding;
using AjaxControlToolkit;
using ContabSysNet_Web.Clases;

namespace ContabSysNet_Web.Bancos.ConciliacionBancaria
{
    public partial class ConciliacionBancaria_Criterios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
             Master.Page.Title = "... defina un filtro y haga un click en Aplicar Filtro para aplicarlo";

             ErrMessage_Span.InnerHtml = "";
             ErrMessage_Span.Style["display"] = "none";

             if (!User.Identity.IsAuthenticated)
             {
                 FormsAuthentication.SignOut();
                 return;
             }

             if (!Page.IsPostBack)
             {
             }
        }

        public IQueryable<ConciliacionesBancaria> ConciliacionesBancarias_GridView_GetData()
        {
            BancosEntities db = new BancosEntities(); 
            var query = db.ConciliacionesBancarias.Include("Compania").Include("CuentasBancaria").Include("CuentasContable").OrderByDescending(c => c.ID);
            return query;
        }

        public void ConciliacionesBancarias_FormView_InsertItem()
        {
            var item = new ContabSysNet_Web.ModelosDatos_EF.Bancos.ConciliacionesBancaria();
            TryUpdateModel(item);
            if (ModelState.IsValid)
            {
                // Save changes here
                BancosEntities db = new BancosEntities();
                db.ConciliacionesBancarias.AddObject(item);

                try
                {
                    db.SaveChanges();
                }
                catch (Exception ex)
                {
                    string errorMessage = ex.Message;
                    if (ex.InnerException != null)
                        errorMessage += ex.InnerException.Message;

                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = errorMessage;
                }
            }
        }

        // The id parameter should match the DataKeyNames value set on the control
        // or be decorated with a value provider attribute, e.g. [QueryString]int id
        public ConciliacionesBancaria ConciliacionesBancarias_FormView_GetItem ([Control("ConciliacionesBancarias_GridView")]int? id)
        {
            if (ConciliacionesBancarias_GridView.SelectedValue != null) 
                // ésto no debería ser necesario; por alguna razón no encuentro como hacer funcionar el atributo Control para que traiga el 
                // selectedValue del GridView (???!!!) ... 
                id = Convert.ToInt32(ConciliacionesBancarias_GridView.SelectedValue.ToString());        // ésto funciona (aunque deberíamos usar [Control] (!!!) 

            using (BancosEntities db = new BancosEntities())
            {
                ConciliacionesBancaria item = db.ConciliacionesBancarias.
                    Include("Compania").
                    Include("CuentasBancaria").
                    Include("CuentasContable").
                    Include("CuentasBancaria.Moneda1").
                    Include("CuentasBancaria.Agencia1").
                    Include("CuentasBancaria.Agencia1.Banco1").
                    Where(c => c.ID == id).
                    FirstOrDefault();

                return item;
            }
        }

        protected void ConciliacionesBancarias_GridView_SelectedIndexChanged(object sender, EventArgs e)
        {
            // nótese que usamos DataBind para 'refrescar' el FormView; la idea es que ejecute su método GetData para que lea el registro 
            // seleccionado por el usuario en el GridView ... 

            ConciliacionesBancarias_FormView.ChangeMode(FormViewMode.ReadOnly);
            ConciliacionesBancarias_FormView.DataBind();
            TabContainer1.ActiveTabIndex = 1; 
        }

        // The id parameter name should match the DataKeyNames value set on the control
        public void ConciliacionesBancarias_FormView_UpdateItem(int id)
        {
            ConciliacionesBancaria item = null;
            // Load the item here, e.g. item = MyDataLayer.Find(id);
            BancosEntities db = new BancosEntities();
            item = db.ConciliacionesBancarias.FirstOrDefault(c => c.ID == id); 
            if (item == null)
            {
                // The item wasn't found
                ModelState.AddModelError("", String.Format("Item with id {0} was not found", id));
                return;
            }
            TryUpdateModel(item);
            if (ModelState.IsValid)
            {
                // Save changes here, e.g. MyDataLayer.SaveChanges();
                db.SaveChanges();
                ConciliacionesBancarias_GridView.DataBind();                // para 'refrescar' el GridView con los cambios efectuados ... 
            }
        }

        protected void ConciliacionesBancarias_FormView_ItemInserted(object sender, FormViewInsertedEventArgs e)
        {
            if (e.Exception == null && ModelState.IsValid && this.CustomValidator1.IsValid)
            {
                ConciliacionesBancarias_GridView.DataBind();                // para 'refrescar' el GridView con los cambios efectuados ... 
                TabContainer1.ActiveTabIndex = 0;
            }
            else
            {
                e.ExceptionHandled = true;
                e.KeepInInsertMode = true;
            }
        }

        protected void ConciliacionesBancarias_FormView_ItemDeleted(object sender, FormViewDeletedEventArgs e)
        {
            if (e.Exception == null && ModelState.IsValid && this.CustomValidator1.IsValid)
            {
                ConciliacionesBancarias_GridView.DataBind();                // para 'refrescar' el GridView con los cambios efectuados ... 
                TabContainer1.ActiveTabIndex = 0;
            }
            else
            {
                e.ExceptionHandled = true;
            }
        }

        protected void ConciliacionesBancarias_FormView_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
        {
            if (e.Exception == null && ModelState.IsValid && this.CustomValidator1.IsValid)
            {
                ConciliacionesBancarias_GridView.DataBind();                // para 'refrescar' el GridView con los cambios efectuados ... 
                TabContainer1.ActiveTabIndex = 0;
            }
            else
            {
                e.ExceptionHandled = true;
                e.KeepInEditMode = true;
            }
        }

        protected void AddItem_LinkButton_Click(object sender, EventArgs e)
        {
            ConciliacionesBancarias_FormView.ChangeMode(FormViewMode.Insert);
            ConciliacionesBancarias_FormView.DataBind();
            TabContainer1.ActiveTabIndex = 1; 
        }

        // The id parameter name should match the DataKeyNames value set on the control
        public void ConciliacionesBancarias_FormView_DeleteItem(int id)
        {
            ConciliacionesBancaria item = null;
            // Load the item here, e.g. item = MyDataLayer.Find(id);
            BancosEntities db = new BancosEntities();
            item = db.ConciliacionesBancarias.FirstOrDefault(c => c.ID == id);
            if (item == null)
            {
                // The item wasn't found
                ModelState.AddModelError("", String.Format("Item with id {0} was not found", id));
                return;
            }

            if (ModelState.IsValid)
            {
                // Save changes here, e.g. MyDataLayer.SaveChanges();
                db.ConciliacionesBancarias.DeleteObject(item); 
                db.SaveChanges();
                ConciliacionesBancarias_GridView.DataBind();                // para 'refrescar' el GridView con los cambios efectuados ... 
                TabContainer1.ActiveTabIndex = 0; 
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            if (this.ConciliacionesBancarias_GridView.SelectedValue == null)
            {
                CustomValidator1.ErrorMessage = "Ud. debe seleccionar un registro en la lista. Los valores del registro serán usados como " + 
                    "criterios de ejecución de la conciliación bancaria.";
                CustomValidator1.IsValid = false;

                return; 
            }

            Session["ConciliacionBancariaID"] = this.ConciliacionesBancarias_GridView.SelectedValue;

            // cerramos la página ...  
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("window.opener.RefreshPage();");
            sb.Append("window.close();");
            ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true);
            // ---------------------------------------------------------------------------------------------
        }

        protected void ConciliacionesBancarias_FormView_DataBound(object sender, EventArgs e)
        {
            FormView formView = sender as FormView; 

            // Nota: el código que sigue es necesario, pues para lograr el cascading dropdownlist en FormView, debemos hacer 
            // el 'databinding' del child control usando código ... 


            // inicializamos el parameter en el 2do datasource (child) y establecemos el selected value del 2do. dropdownlist (child)
            // en base al valor que viene en el row 
            if (formView.CurrentMode == FormViewMode.Edit)
            {
                ConciliacionesBancaria conciliacion = formView.DataItem as ConciliacionesBancaria;

                if (conciliacion != null)
                {
                    // 1er. combo (child) 
                    DropDownList ddl2 = formView.FindControl("CuentasBancarias_DropDownList") as DropDownList;
                    SqlDataSource dsc2 = formView.FindControl("CuentasBancarias_SqlDataSource") as SqlDataSource;

                    dsc2.SelectParameters["CiaContab"].DefaultValue = conciliacion.CiaContab.ToString();
                    ddl2.DataBind();
                    ddl2.SelectedValue = conciliacion.CuentaBancaria.ToString();

                    // 2do. combo (child) 
                    DropDownList ddl3 = formView.FindControl("CuentasContables_DropDownList") as DropDownList;
                    SqlDataSource dsc3 = formView.FindControl("CuentasContables_SqlDataSource") as SqlDataSource;

                    dsc3.SelectParameters["CiaContab"].DefaultValue = conciliacion.CiaContab.ToString();
                    ddl3.DataBind();
                    ddl3.SelectedValue = conciliacion.CuentaContable.ToString(); 
                }
            }
        }

        protected void CiasContab_DDL_DataBinding(object sender, System.EventArgs e)
        {
            DropDownList ddl = (DropDownList)(sender);

            ddl.Items.Add(new ListItem("Seleccione una cia ...", "999")); 

            // usamos una clase para construir una lista con las compañías (Contab) que se han asignado al usuario 
            ConstruirListaCompaniasAsignadas listaCiasContabAsignadas = new ConstruirListaCompaniasAsignadas();
            var companiasAsignadas = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

            foreach (var item in companiasAsignadas)
            {
                ListItem newItem = new ListItem(item.NombreCorto, item.Numero.ToString());
                ddl.Items.Add(newItem); 
            }
        }

        protected void ConciliacionesBancarias_FormView_ItemInserting(object sender, FormViewInsertEventArgs e)
        {
            // Nota: el código que sigue es necesario, pues para lograr el cascading dropdownlist en FormView, debemos hacer 
            // el 'databinding' del child control usando código ... 

            // establecemos los valores de las propiedades que toman el valor de cada dropdownlist 
            // recuérdese que tuvimos que dejar de usar Bind(property) para hacer el databinding en forma manual ...

            FormView formView = sender as FormView;

            DropDownList ddl2 = formView.FindControl("CuentasBancarias_DropDownList") as DropDownList;
            e.Values["CuentaBancaria"] = ddl2.SelectedValue;

            DropDownList ddl3 = formView.FindControl("CuentasContables_DropDownList") as DropDownList;
            e.Values["CuentaContable"] = ddl3.SelectedValue;
        }

        protected void ConciliacionesBancarias_FormView_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        {
            // Nota: el código que sigue es necesario, pues para lograr el cascading dropdownlist en FormView, debemos hacer 
            // el 'databinding' del child control usando código ... 

            // establecemos los valores de las propiedades que toman el valor de cada dropdownlist 
            // recuérdese que tuvimos que dejar de usar Bind(property) para hacer el databinding en forma manual ...

            FormView formView = sender as FormView;

            DropDownList ddl2 = formView.FindControl("CuentasBancarias_DropDownList") as DropDownList;
            e.NewValues["CuentaBancaria"] = ddl2.SelectedValue;

            DropDownList ddl3 = formView.FindControl("CuentasContables_DropDownList") as DropDownList;
            e.NewValues["CuentaContable"] = ddl3.SelectedValue; 
        }

        protected void CiasContab_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Nota: el código que sigue es necesario, pues para lograr el cascading dropdownlist en FormView, debemos hacer 
            // el 'databinding' del child control usando código ... 

            // cada vez que el usuario cambia su selección en el dropdownlist 1 (parent), actualizamos el valor del 
            // parametro en cada DataSource y hacemos DataBind de los dropdownlist (children) 

            DropDownList ddl1 = ConciliacionesBancarias_FormView.FindControl("CiasContab_DropDownList") as DropDownList;

            SqlDataSource dsc2 = ConciliacionesBancarias_FormView.FindControl("CuentasBancarias_SqlDataSource") as SqlDataSource;
            dsc2.SelectParameters[0].DefaultValue = ddl1.SelectedValue;

            SqlDataSource dsc3 = ConciliacionesBancarias_FormView.FindControl("CuentasContables_SqlDataSource") as SqlDataSource;
            dsc3.SelectParameters[0].DefaultValue = ddl1.SelectedValue;

            DropDownList ddl2 = ConciliacionesBancarias_FormView.FindControl("CuentasBancarias_DropDownList") as DropDownList;
            ddl2.DataBind();

            DropDownList ddl3 = ConciliacionesBancarias_FormView.FindControl("CuentasContables_DropDownList") as DropDownList;
            ddl3.DataBind(); 
        }
    }
}