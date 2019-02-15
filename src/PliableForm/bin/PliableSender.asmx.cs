using System;
using System.Configuration;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web.Script.Services;
using System.Web.Services;
using umbraco.NodeFactory;

namespace PliableForm
{
    /// <summary>
    /// Summary description for PliableSender
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    //[System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class PliableSender : System.Web.Services.WebService
    {

        private formRequest _req;
        public formRequest req
        {
            get { return _req; }
            set { _req = value; }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false, XmlSerializeString = false)]
        public formResponse sendForm(formRequest request)
        {
            formResponse nr = new formResponse();
            nr.Result = "1";
            nr.Msg = string.Empty;


            try
            {
                // start Node Factory
                Node page = new Node(request.Id);

                string autoResponderEmail = string.Empty;
                string autoResponderId = string.Empty;
                if (page.GetProperty("emailField") != null)
                {
                    autoResponderId = page.GetProperty("emailField").Value;
                }

                // construct the email message
                int rowCount = 0;
                string message = "<html><head></head><body><table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"font-family: sans-serif; font-size: 13px; color: #222; border-collapse: collapse;\">";
                for (int i = 0; i < request.Values.Length; i++)
                {
                    string name = request.Names[i];
                    //string nodeName = string.Empty;
                    int index = request.FieldIds[i].LastIndexOf('_') + 1;
                    if (index > 0)
                    {
                        string fullId = request.FieldIds[i].Substring(index, request.FieldIds[i].Length - index);

                        if (fullId == autoResponderId)
                        {
                            autoResponderEmail = request.Values[i];
                        }

                        int id;
                        if (int.TryParse(fullId, out id))
                        {
                            Node node = new Node(id);
                            if (node != null)
                            {
                                //nodeName = node.Name;
                                name = node.Name;
                                try
                                {
                                    if (node.GetProperty("label").Value.Length > 0)
                                    {
                                        name = node.GetProperty("label").Value;
                                    }
                                    else if (node.NodeTypeAlias == "PliableText")
                                    {
                                        if (node.GetProperty("defaultValue").Value.Length > 0)
                                        {
                                            name = node.GetProperty("defaultValue").Value;
                                        }
                                    }
                                }
                                catch { }
                            }
                        }
                    }
                    if (name.Length > 0)
                    {
                        rowCount++;
                        try
                        {
                            if (rowCount % 2 == 0)
                            {
                                message += string.Format("<tr><td style=\"background-color: #ffffff; padding: 4px 8px; vertical-align: top; width: 120px;\">{0}</td><td style=\"background-color: #ffffff; padding: 4px 8px; vertical-align: top;\">{1}</td></tr>", name, request.Values[i]);
                            }
                            else
                            {
                                message += string.Format("<tr><td style=\"background-color: #ebf5ff; padding: 4px 8px; vertical-align: top; width: 120px;\">{0}</td><td style=\"background-color: #ebf5ff; padding: 4px 8px; vertical-align: top;\">{1}</td></tr>", name, request.Values[i]);
                            }
                        }
                        catch { }
                    }
                }
                message += "</table></body></html>";


                // determine the to address
                string emailTo = page.GetProperty("toAddress").Value;

                if (string.IsNullOrEmpty(emailTo))
                {
                    emailTo = ConfigurationManager.AppSettings["PliableForm.defaultToAddress"];
                    if (emailTo == null)
                    {
                        emailTo = umbraco.library.GetDictionaryItem("PliableForm.defaultToAddress");
                    }
                }
                string subject = page.GetProperty("emailSubject").Value;
                if (string.IsNullOrEmpty(subject))
                {
                    subject = ConfigurationManager.AppSettings["PliableForm.defaultEmailSubject"];
                    if (subject == null)
                    {
                        subject = umbraco.library.GetDictionaryItem("PliableForm.defaultEmailSubject");
                    }
                }

                req = request;
                MatchEvaluator reEval = new MatchEvaluator(this.replaceFields);

                // send the email
                SendEmailMessage(emailTo, message, Regex.Replace(subject, "{([^}]+)}", reEval), true);
                nr.Result = "2";

                // send the autoresponder email
                if (!string.IsNullOrEmpty(autoResponderEmail))
                {
                    string ARbody = string.Empty;
                    try
                    {
                        ARbody = page.GetProperty("autoResponderText").Value;
                    }
                    catch { /* Swallow Exception */ }

                    bool ARisHtml = false;
                    if (string.IsNullOrEmpty(ARbody))
                    {
                        ARbody = page.GetProperty("autoResponderHtml").Value;
                        ARbody = ARbody.Replace("[OriginalMessage]", message.Replace("<html><head></head><body>", string.Empty).Replace("</body></html>", string.Empty));
                        ARisHtml = true;
                    }

                    ARbody = Regex.Replace(ARbody, "{([^}]+)}", reEval);
                    SendEmailMessage(autoResponderEmail, ARbody, Regex.Replace(page.GetProperty("autoResponderSubject").Value, "{([^}]+)}", reEval), ARisHtml);
                }

            }
            catch (Exception ex)
            {
                nr.Result = "3";

                var innerEx = string.Empty;
                if(ex.InnerException != null)
                {
                    innerEx = ex.InnerException.StackTrace;
                }
                nr.Msg = string.Format("Message: {0} StackTrace: {1} {2}", ex.Message, ex.StackTrace, innerEx);
            }

            return nr;
        }

        public void SendEmailMessage(string toAddress, string emailBody, string emailSubject, bool isHtml)
        {
            string enableSsl = ConfigurationManager.AppSettings["PliableForm.enableSsl"];
            if (enableSsl == null)
            {
                enableSsl = umbraco.library.GetDictionaryItem("PliableForm.enableSsl");
            }
            string emailFrom = ConfigurationManager.AppSettings["PliableForm.fromAddress"];
            if (emailFrom == null)
            {
                emailFrom = umbraco.library.GetDictionaryItem("PliableForm.fromAddress");
            }
            
            MailMessage msg = new MailMessage();
            msg.Subject = emailSubject;
            msg.From = new MailAddress(emailFrom);
            msg.IsBodyHtml = isHtml;
            msg.Body = emailBody;

            string[] addressList;
            if (ProcessAddresses(toAddress, out addressList))
            {
                foreach (string address in addressList)
                {
                    msg.To.Add(new MailAddress(address));
                }
            }
            else
            {
                msg.To.Add(new MailAddress(toAddress));
            }

            SmtpClient smtp = new SmtpClient { EnableSsl = false };
            if (enableSsl.ToLower() == "true" || enableSsl == "1")
            {
                smtp.EnableSsl = true;
            }
            smtp.Send(msg);
        }

        private bool ProcessAddresses(string addresses, out string[] list)
        {
            try
            {
                list = addresses.Split(char.Parse(";"));

                if (list.Length > 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                list = null;

                return false;
            }
        }
        private string replaceFields(Match m)
        {
            for (int i = 0; i < req.Values.Length; i++)
            {
                if (req.Names[i] == m.Groups[1].Value)
                {
                    return req.Values[i];
                }
            }
            return m.Value;
        }

    }


    public class formResponse
    {
        private string _result;
        private string _msg;

        public string Result
        {
            get { return _result; }
            set { _result = value; }
        }
        public string Msg
        {
            get { return _msg; }
            set { _msg = value; }
        }
    }

    public class formRequest
    {
        private string[] _fieldIds;
        private string[] _names;
        private string[] _values;
        private int _id;

        public string[] FieldIds
        {
            get { return _fieldIds; }
            set { _fieldIds = value; }
        }
        public string[] Names
        {
            get { return _names; }
            set { _names = value; }
        }
        public string[] Values
        {
            get { return _values; }
            set { _values = value; }
        }
        public int Id
        {
            get { return _id; }
            set { _id = value; }
        }
    }

}
