<%-- 
Document   : FileUploadDragDrop
Author     : RIB
Created on : 6/02/2018, 04:51:47 PM

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
Author     : RAS
Created on : 8/03/2021
Desc       : Funcionalidad para abrir explorardor de archivos

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
Author     : RIB
Created on : 11/03/2021
Desc       : Se agrega barra de progreso en la subida de archivos

--%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>File Upload Drag &amp; Drop</title>
        <link rel="stylesheet" type="text/css" media="all" href="../../../resources/css/file_upload_style.css" />
    </head>

    <script>
        function UploadFiles(){}
        function ResetPage(){}
    </script>

    <body>

        <table style="width: 100%;">
            <tr>
                <td colspan="2">
                    <div id="submitbutton">
                        <input type="image" src="../../../images/e3/ui/buttons/upload_file.png" onclick="UploadFiles();" title="Upload Files">
                        <input type="image" src="../../../images/e3/ui/buttons/clear_files.png" title="Cancel" onclick="ResetPage();">
                    </div>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;" ondblclick="FileSelectorClick()" rowspan="2">
                    <form id="upload" action="${pageContext.request.contextPath}/uploadresource" method="POST" enctype="multipart/form-data">
                        <fieldset>
                            <legend>Arrastre los archivos o haga doble clic.</legend>
                            <div>
                                <div id="filedrag"></div>
                            </div>
                            <progress id="progress" value="0" style="width: 90%"></progress>
                            <span id="display"></span>
                        </fieldset>
                    </form>
                </td>
                <td style="vertical-align: top; width: 55%; height: 50%">
                    <fieldset>
                        <legend>Sugerencia</legend>
                        <p style="color:#FE2E2E;font-size: smaller"><b>Si tiene problemas para arrastrar los archivos presione las teclas Win+Flecha Izquierda o Win+Flecha Derecha para ajustar la página.</b></p>
                        <p style="color:#FE2E2E;font-size: smaller"><b>O bien haga doble clic en la caja para abrir el explorador de archivos.</b></p>
                    </fieldset>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top; width: 50%; height: 50%">
                    <fieldset>
                        <legend>Archivos a cargar.</legend>
                        <div id="messages"></div>
                    </fieldset>
                    <script >
                        if (window.File && window.FileList && window.FileReader) {
                            Init();
                        }
                        function Init() {
                            var loFiledrag = $id("filedrag");

                            var loXHR = new XMLHttpRequest();
                            if (loXHR.upload) {
                                loFiledrag.addEventListener("dragover", FileDragHover, false);
                                loFiledrag.addEventListener("dragleave", FileDragHover, false);
                                loFiledrag.addEventListener("drop", FileSelectHandler, false);
                                loFiledrag.style.display = "block";
                            }
                        }
                        
                        function $id(psId) {
                            return document.getElementById(psId);
                        }

                        function Output(psMsg) {
                            var lsMsg = $id("messages");
                            lsMsg.innerHTML = psMsg + lsMsg.innerHTML;
                        }

                        function FileSelectorClick(){
                            var loFormData = new FormData();
                            var inputElement = document.createElement("input");
                            var loFiles;
                            var loXHR = new XMLHttpRequest();
                            
                            inputElement.type = "file";
                            inputElement.addEventListener("change", function(){
                                loFiles = Array.from(inputElement.files)
                                for (var lii = 0, loFile; loFile = loFiles [lii]; lii++) {
                                    ParseFile(loFile);
                                    loFormData.append("file", loFile);
                                }
                                
                                console.log("${pageContext.request.contextPath}/uploadresource");
                                loXHR.open("POST", "${pageContext.request.contextPath}/uploadresource", true);
                                
                                updateProgressBar(loXHR);
                                
                                loXHR.send(loFormData);
                            });
                            
                            inputElement.dispatchEvent(new MouseEvent("click")); 
                        }

                        function FileDragHover(poEvent) {
                            poEvent.stopPropagation();
                            poEvent.preventDefault();
                            poEvent.target.className = (poEvent.type == "dragover" ? "hover" : "");
                        }

                        function FileSelectHandler(poEvent) {
                            var loFormData = new FormData();
                            var loFiles = poEvent.target.files || poEvent.dataTransfer.files;
                            var loXHR = new XMLHttpRequest();
                        
                            FileDragHover(poEvent);
                        
                            for (var lii = 0, loFile; loFile = loFiles [lii]; lii++) {
                                ParseFile(loFile);
                                loFormData.append("file", loFile);
                            }

                            loXHR.open("POST", "${pageContext.request.contextPath}/uploadresource", true);
                            
                            updateProgressBar(loXHR);

                            loXHR.send(loFormData);
                        }

                        function ParseFile(poFile) {
                            Output(
                                "<p>File: <strong>" + poFile.name +
                                "</strong> size: <strong>" + poFile.size +
                                "</strong> bytes</p>"
                                );
                        }
                        
                        function updateProgressBar(poXHR){
                            var loProgressBar = document.getElementById("progress");
                            var loDisplay = document.getElementById("display");
                            
                            if (poXHR.upload) {
                                poXHR.upload.onprogress = function(e) {
                                    if (e.lengthComputable) {
                                        loProgressBar.max = e.total;
                                        loProgressBar.value = e.loaded;
                                        loDisplay.innerText = Math.floor((e.loaded / e.total) * 100) + '%';
                                    }
                                }
                                
                                poXHR.upload.onloadstart = function(e) {
                                    loProgressBar.value = 0;
                                    loDisplay.innerText = '0%';
                                }
                                
                                poXHR.upload.onloadend = function(e) {
                                    loProgressBar.value = e.loaded;
                                    alert("La carga ha finalizado!");
                                }
                            }
                        }
                    </script>
                </td>
            </tr>
        </table>
    </body>
</html>