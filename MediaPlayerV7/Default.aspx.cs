using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediaPlayerV7
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateVideoFolders();

                // Select the first video folder if available
                if (ddlVideoFolders.Items.Count > 0)
                {
                    ddlVideoFolders.SelectedIndex = 0;
                    PopulateLanguages();

                    // Select the first language if available
                    if (ddlLanguages.Items.Count > 0)
                    {
                        ddlLanguages.SelectedIndex = 0;
                        SetVideoSource();
                    }
                    else
                    {
                        // No language, clear video
                        ClearVideoSource();
                    }
                }
                else
                {
                    // No video folder, clear language and video
                    ddlLanguages.Items.Clear();
                    ClearVideoSource();
                }
            }
        }

        private void PopulateVideoFolders()
        {
            string videosRoot = Server.MapPath("~/Videos");
            ddlVideoFolders.Items.Clear();
            ddlLanguages.Items.Clear();

            if (Directory.Exists(videosRoot))
            {
                var folders = Directory.GetDirectories(videosRoot);
                foreach (var folder in folders)
                {
                    string folderName = Path.GetFileName(folder);
                    ddlVideoFolders.Items.Add(new ListItem(folderName, folderName));
                }
            }
        }

        private void PopulateLanguages()
        {
            ddlLanguages.Items.Clear();
            string selectedFolder = ddlVideoFolders.SelectedValue;
            if (!string.IsNullOrEmpty(selectedFolder))
            {
                string folderPath = Server.MapPath("~/Videos/" + selectedFolder);
                if (Directory.Exists(folderPath))
                {
                    var subfolders = Directory.GetDirectories(folderPath);
                    foreach (var subfolder in subfolders)
                    {
                        string subfolderName = Path.GetFileName(subfolder);
                        ddlLanguages.Items.Add(new ListItem(subfolderName, subfolderName));
                    }
                }
            }
        }

        protected void ddlVideoFolders_SelectedIndexChanged(object sender, EventArgs e)
        {
            PopulateLanguages();

            // Select the first language if available and update video
            if (ddlLanguages.Items.Count > 0)
            {
                ddlLanguages.SelectedIndex = 0;
                SetVideoSource();
            }
            else
            {
                ClearVideoSource();
            }
        }

        protected void ddlLanguages_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetVideoSource();
        }

        private void SetVideoSource()
        {
            string selectedFolder = ddlVideoFolders.SelectedValue;
            string selectedLanguage = ddlLanguages.SelectedValue;
            if (!string.IsNullOrEmpty(selectedFolder) && !string.IsNullOrEmpty(selectedLanguage))
            {
                string videosPath = Server.MapPath($"~/Videos/{selectedFolder}/{selectedLanguage}");
                if (Directory.Exists(videosPath))
                {
                    var files = Directory.GetFiles(videosPath, "*.mp4");
                    if (files.Length > 0)
                    {
                        string fileName = Path.GetFileName(files[0]);
                        string relativePath = ResolveUrl($"~/Videos/{selectedFolder}/{selectedLanguage}/{fileName}");
                        string script = $"setVideoSource('{relativePath}');";
                        ScriptManager.RegisterStartupScript(this, GetType(), "SetVideoSource", script, true);
                        return;
                    }
                }
            }
            ClearVideoSource();
        }

        private void ClearVideoSource()
        {
            string script = "setVideoSource('');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ClearVideoSource", script, true);
        }
    }
}