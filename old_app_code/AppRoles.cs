using System.Collections.Generic;
using System.Web.Security; 

public class AppRoles
{
    private string _roleName;

    public string RoleName
    {
        get
        {
            return _roleName;
        }
        set
        {
            _roleName = value;
        }
    }

    public List<AppRoles> GetRoles()
    {

        //Dim MyRoleObject_List As New List(Of AppRoles)
        //Dim MyRole As AppRoles

        //For Each sRoleName As String In Roles.GetAllRoles
        //    MyRole = New AppRoles
        //    MyRole.RoleName = sRoleName

        //    MyRoleObject_List.Add(MyRole)
        //Next

        //Return MyRoleObject_List

        List<AppRoles> MyRoleObject_List = new List<AppRoles>();
        AppRoles MyRole;
        foreach (string sRoleName in Roles.GetAllRoles())
        {
            MyRole = new AppRoles();
            MyRole.RoleName = sRoleName;
            MyRoleObject_List.Add(MyRole);
        }
        return MyRoleObject_List;
    }

    public void Delete_Role(string original_RoleName)
    {
        //  primero eliminamos probables asociaciones de usuarios a este rol 
        string[] sUsersInRol;
        sUsersInRol = Roles.GetUsersInRole(original_RoleName);
        foreach (string MyUserName in sUsersInRol)
        {
            Roles.RemoveUserFromRole(MyUserName, original_RoleName);
        }
        Roles.DeleteRole(original_RoleName);
    }

    public void Create_Role(string RoleName)
    {
        Roles.CreateRole(RoleName);
    }
}