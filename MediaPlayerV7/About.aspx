<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="MediaPlayerV7.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %>.</h2>
        <h3>Transcribe and Translate Videos</h3>
        <p>This application lets you upload videos, generates transcriptions and closed caption files of the uploaded video, then translates to alternative languages and creates language specific variants of the video.</p>

        <!-- PDF Viewer -->
        <div style="margin-top: 20px; border: 1px solid #ccc; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);">
            <iframe src="ProjectInfo.pdf" width="100%" height="600px" style="border: none;"></iframe>
        </div>
    </main>
</asp:Content>
