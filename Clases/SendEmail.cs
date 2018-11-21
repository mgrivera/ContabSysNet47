using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;

namespace ContabSysNet_Web.Clases
{
    public class SendEmail
    {
        string _host;
        int? _port;
        bool _enableSSL; 
        string _userName;
        string _userPassword; 

        public string FromAddress { get; set; }
        public string ToAddress { get; set; }
        public string CCAddress { get; set; }

        public string Subject { get; set; }
        public string Body { get; set; }
        public string AttachmentFileName { get; set; }

        public SendEmail(string host, int? port, bool enableSSL, string userName, string userPassword) 
        {
            _host = host;
            _port = port;
            _enableSSL = enableSSL;
            _userName = userName;
            _userPassword = userPassword;  
        }

        public bool Send(out string ErrorMessage)
        {
            ErrorMessage = ""; 

            // smtp settings
            SmtpClient SmtpServer = new SmtpClient();
            {
                SmtpServer.Host = _host;
                SmtpServer.EnableSsl = _enableSSL;
                SmtpServer.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                SmtpServer.Credentials = new NetworkCredential(_userName, _userPassword);
                SmtpServer.Timeout = 20000;
            }

            if (_port != null)
                SmtpServer.Port = _port.Value; 


            MailMessage mailMessage = new MailMessage();

            mailMessage.From = new MailAddress(FromAddress);
            mailMessage.To.Add(ToAddress);

            if (!string.IsNullOrEmpty(CCAddress)) 
                mailMessage.CC.Add(CCAddress);

            mailMessage.Subject = Subject;
            mailMessage.Body = Body;
            mailMessage.IsBodyHtml = true;

            try
            {
                if (!string.IsNullOrEmpty(AttachmentFileName))
                {
                    // 'using' is used to dispose the attachment correctly (ie: file does not remain opened after email is sent) ... 
                    using (System.Net.Mail.Attachment attachment = new System.Net.Mail.Attachment(AttachmentFileName))
                    {
                        mailMessage.Attachments.Add(attachment);
                        SmtpServer.Send(mailMessage);
                    }
                }
                else
                    SmtpServer.Send(mailMessage);
            }
            catch (Exception ex)
            {
                ErrorMessage = ex.Message;
                if (ex.InnerException != null)
                    ErrorMessage += ex.InnerException.Message;

                return false;
            }
            finally
            {
                SmtpServer.Dispose(); 
            }

            return true; 
        }
    }
}