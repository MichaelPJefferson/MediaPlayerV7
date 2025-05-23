﻿<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MediaPlayerV7._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <!-- Video Selection UI -->
        <section class="row" aria-labelledby="videoPlayerTitle">
            <h2 id="videoPlayerTitle">Video Translation Tool</h2>
            <h4 id="videoPlayerTitleDescrition">Upload mp4 filesto be transcribed and translated to a variety of languages.<br />Currently configured for Spanish, French, and Greek.</h4>
            <div style="display: flex; align-items: center; gap: 20px; padding: 10px; border: 1px solid #ccc; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2); border-radius: 5px; background-color: #f9f9f9;">
                <asp:Label ID="lblVideo" runat="server" AssociatedControlID="ddlVideoFolders" Text="Video" style="min-width:70px; margin-right:5px;" />
                <asp:DropDownList ID="ddlVideoFolders" runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlVideoFolders_SelectedIndexChanged"
                    Width="300px" />
                <asp:Label ID="lblLanguage" runat="server" AssociatedControlID="ddlLanguages" Text="Language" style="min-width:70px; margin-left:15px; margin-right:5px;" />
                <asp:DropDownList ID="ddlLanguages" runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlLanguages_SelectedIndexChanged"
                    Width="100px" />
                <div style="display: flex; align-items: center; gap: 20px;">
                    <input type="file" id="fileUpload" accept=".mp4" style="margin-left:15px;" />
                    <button type="button" id="btnUpload" style="margin-left:5px;">Upload</button>
                    <progress id="uploadProgress" value="0" max="100" style="width:120px; margin-left:5px; display:none;"></progress>
                    <button type="button" id="btnRefresh" style="margin-left:5px;">Refresh</button>
                </div>
            </div>
            <div style="display: flex; align-items: flex-start; gap: 20px; padding-top: 0px;">
                <video id="videoPlayer" width="800" height="600" controls>
                    <source id="videoSource" type="video/mp4" />
                    <track id="captionTrack" label="English" kind="subtitles" srclang="en" default />
                    Your browser does not support the video tag.
                </video>
                <!-- Text Field for Loading .txt Content -->
                <div style="padding-top: 90px;">
                <textarea id="textContent" rows="20" readonly 
                     style="display: none; height: 510px; width: 500px; resize: none; box-sizing: border-box;"></textarea>
                </div>
            </div>
            <div style="display: flex; align-items: flex-start; gap: 20px; padding-top: 10px; height:30px">
                Download Individual Files   
                <a id="downloadVideo" runat="server" target="_blank" href="#" rel="stylesheet" download >Video</a>
                <a id="downloadAudio" runat="server" target="_blank" href="#" rel="stylesheet" download >Audio</a>
                <a id="downloadTranscript" runat="server" target="_blank" href="#" rel="stylesheet" download >Transcription</a>
                <a id="downloadCC" runat="server" target="_blank" href="#" rel="stylesheet" download >Closed Caption File</a>
            </div>
        </section>

        <script type="text/javascript">
            function setVideoSource(src) {
                var video = document.getElementById('videoPlayer');
                var source = document.getElementById('videoSource');
                var track = document.getElementById('captionTrack');
                var textArea = document.getElementById('textContent');

                var dlVideo = document.getElementById('MainContent_downloadVideo');
                var dlAudio = document.getElementById('MainContent_downloadAudio');
                var dlTranscript = document.getElementById('MainContent_downloadTranscript');
                var dlCC = document.getElementById('MainContent_downloadCC');

                var ddlLanguages = document.getElementById('<%= ddlLanguages.ClientID %>'); // Get the language dropdown

                source.src = src;

                // Set VTT track to same path as video, but with .vtt extension
                if (src && src.lastIndexOf('.') !== -1) {
                    var vttSrc = src.substring(0, src.lastIndexOf('.')) + '.vtt';
                    track.src = vttSrc;
                    track.style.display = '';

                    // Update the srclang attribute based on the selected language
                    var selectedLanguage = ddlLanguages.value; // Get the selected language value
                    track.srclang = selectedLanguage; // Set the srclang attribute

                    dlVideo.href = vttSrc.substring(0, vttSrc.lastIndexOf('.')) + '.mp4';
                    dlAudio.href = vttSrc.substring(0, vttSrc.lastIndexOf('.')) + '.wav';
                    dlTranscript.href = vttSrc.substring(0, vttSrc.lastIndexOf('.')) + '.txt';
                    dlCC.href = vttSrc;

                } else {
                    track.src = '';
                    track.style.display = 'none';
                }
                // Load .txt file content
                if (src && src.lastIndexOf('.') !== -1) {
                    var txtSrc = src.substring(0, src.lastIndexOf('.')) + '.txt';
                    fetch(txtSrc)
                        .then(response => {
                            if (response.ok) {
                                return response.text();
                            } else {
                                throw new Error('Text file not found.');
                            }
                        })
                        .then(text => {
                            textArea.style.display = '';
                            textArea.value = text;
                        })
                        .catch(error => {
                            textArea.style.display = 'none';
                            textArea.value = '';
                            console.error(error.message);
                        });
                } else {
                    textArea.style.display = 'none';
                    textArea.value = '';
                }
                video.load();
            }
        </script>

        <script type="text/javascript">
            document.addEventListener('DOMContentLoaded', function () {
                var btn = document.getElementById('btnUpload');
                var fileInput = document.getElementById('fileUpload');
                var ddlVideoFolders = document.getElementById('<%= ddlVideoFolders.ClientID %>');
            var ddlLanguages = document.getElementById('<%= ddlLanguages.ClientID %>');
            var progress = document.getElementById('uploadProgress');
            var progressText = document.getElementById('progressText');

                btn.addEventListener('click', function () {
                    var file = fileInput.files[0];
                    if (!file) {
                        alert('Please select a file.');
                        return;
                    }
                    var folder = ddlVideoFolders.value;
                    var language = ddlLanguages.value;
                    if (!folder || !language) {
                        alert('Please select both a video and a language.');
                        return;
                    }

                    // Hide the upload button and show the progress bar
                    btn.style.display = 'none';
                    progress.style.display = '';

                    var formData = new FormData();
                    formData.append('file', file);
                    formData.append('videoFolder', folder);
                    formData.append('language', language);

                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', 'UploadHandler.ashx', true);

                    xhr.upload.onprogress = function (e) {
                        if (e.lengthComputable) {
                            var percent = Math.round((e.loaded / e.total) * 100);
                            progress.value = percent;
                            progressText.textContent = percent + '%';
                        }
                    };

                    xhr.onloadstart = function () {
                        progress.value = 0;
                        progressText.textContent = '0%';
                    };

                    xhr.onloadend = function () {
                        setTimeout(function () {
                            progress.style.display = 'none';
                            btn.style.display = ''; // Show the upload button again
                            progressText.textContent = '';
                        }, 1000);
                    };

                    xhr.onreadystatechange = function () {
                        if (xhr.readyState === 4) {
                            if (xhr.status === 200) {
                                alert('Upload complete.  Refresh the Page after a minute. (Depending on the video size you might require more time).');
                            } else {
                                alert('Upload failed: ' + xhr.statusText);
                            }
                        }
                    };

                    xhr.send(formData);
                });        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var btnRefresh = document.getElementById('btnRefresh');
            if (btnRefresh) {
                btnRefresh.addEventListener('click', function () {
                    window.location.reload();
                });
            }
        });
    </script>
    </main>

</asp:Content>

