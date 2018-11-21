using ContabSysNet_Web.report_datasets.Bancos;
namespace ContabSysNet_Web.report_datasets.Bancos.Disponibilidad_MontosRestringidosTableAdapters
{
    partial class Disponibilidad_MontosRestringidosTableAdapter
    {
        public int Fill(Disponibilidad_MontosRestringidos.Disponibilidad_MontosRestringidosDataTable MyDataTable, string sSqlWhereClauseString)
        {
            this.Adapter.SelectCommand = this.CommandCollection[0];
            this.Adapter.SelectCommand.CommandText = (this.Adapter.SelectCommand.CommandText + (" Where " + sSqlWhereClauseString));
            if (this.ClearBeforeFill)
            {
                MyDataTable.Clear();
            }
            return this.Adapter.Fill(MyDataTable);
        }
    }
}
