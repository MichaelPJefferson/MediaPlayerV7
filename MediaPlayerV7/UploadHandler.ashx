<%@ WebHandler Language="C#" Class="UploadHandler" %>
using System;
using System.IO;
using System.Web;

public class UploadHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        var file = context.Request.Files["file"];
        //var videoFolder = context.Request.Form["videoFolder"];
        //var language = context.Request.Form["language"];

        if (file != null) // && !string.IsNullOrEmpty(videoFolder) && !string.IsNullOrEmpty(language))
        {
            string videosPath = context.Server.MapPath($"~/Videos");
            if (!Directory.Exists(videosPath))
                Directory.CreateDirectory(videosPath);

            string fileName = Path.GetFileName(file.FileName);
            if (Path.GetExtension(fileName).Equals(".mp4", StringComparison.OrdinalIgnoreCase))
            {
                string filePath = Path.Combine(videosPath, fileName);
                file.SaveAs(filePath);
                context.Response.StatusCode = 200;
                context.Response.Write("OK");
                return;
            }
        }
        context.Response.StatusCode = 400;
        context.Response.Write("Invalid upload.");
    }

    public bool IsReusable { get { return false; } }
}
