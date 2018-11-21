using ContabSysNet_Web.ModelosDatos_EF.Users;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace ContabSysNet_Web.Clases
{
    public class ConstruirListaCompaniasAsignadas
    {
        private List<Compania> _companias; 

        public ConstruirListaCompaniasAsignadas()
        {
            // para crear la lista de compañías, siempre en base a las que se han asignado al usuario ... 
            var currentUser = Membership.GetUser();
            // el usuario en la tabla de compañías y usuarios es de tipo uniqueIdentifier (Guid) 
            Guid userID = new Guid(currentUser.ProviderUserKey.ToString());

            dbContabUsersEntities userContext = new dbContabUsersEntities();

            // nótese como determinamos las compañías que se han asignado al usuario. De no haber ninguna, asumimos todas 
            List<CompaniasYUsuario> companiasAsignadas = userContext.CompaniasYUsuarios.Where(c => c.Usuario == userID).ToList<CompaniasYUsuario>();

            if (companiasAsignadas.Count() == 0)
            {
                // si el usuario no tiene compañías asignadas, asumimos todas 
                _companias = userContext.Companias.OrderBy(c => c.Nombre).ToList();
            }
            else
            {
                List<Compania> companias = userContext.Companias.OrderBy(c => c.Nombre).ToList();
                // seleccionamos solo las compañías que existen en la lista anterior (companiasAsignadas) 
                _companias = companias.Where(c => companiasAsignadas.Any(x => x.Compania == c.Numero)).ToList<Compania>();
            }
        }

        public List<Compania> GetListaCompaniasAsignadas()
        {
            return _companias; 
        }
    }
}