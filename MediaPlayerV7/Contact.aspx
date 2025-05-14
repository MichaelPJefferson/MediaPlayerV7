<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="MediaPlayerV7.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %></h2>
        <h3>Michael Jefferson</h3>
        <address>
            Pinpoint Global Communications<br />
            9 Trafalgar Square, Suite 140<br />
            Nashua, NH 03063<br />
            <abbr title="Phone">P:</abbr>
            603-880-8130
        </address>

        <address>
            <strong>Questions:</strong>   <a href="mailto:mike.jefferson@pinpointglobal.com">mike.jefferson@pinpointglobal.com</a><br />
        </address>
    </main>
</asp:Content>
