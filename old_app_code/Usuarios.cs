using System; 
using System.Web.Security;
// <summary>
// Para ser usada como source del ObjectDataSource para actualizar los usuarios de la aplicaci�n en 
// Control de Usuaruios. 
// </summary>
public class Usuarios
{
    public MembershipUserCollection GetUsers()
    {
        return Membership.GetAllUsers();
    }

    public void UpdateUser(string Email, bool IsOnline, DateTime CreationDate, DateTime LastLoginDate, string original_UserName)
    {
        MembershipUser MyUsuario = Membership.GetUser(original_UserName);
        MyUsuario.Email = Email;
        Membership.UpdateUser(MyUsuario);
    }

    public void DeleteUser(string original_UserName)
    {
        Membership.DeleteUser(original_UserName);
    }
}