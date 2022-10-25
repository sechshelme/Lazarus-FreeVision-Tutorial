# 15 - Fertige Dialoge
## 20 - Datei Dialoge
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Ein Dialog zum öffnen und speichern von Dateien.<br>
Der <b>PFileDialog</b>.<br>
<hr><br>
Verschiedene Datei-Dialoge<br>
```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    FileDialog: PFileDialog;
    FileName: shortstring;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmFileOpen: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOpenButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        cmFileSave: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOkButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        cmFileHelp: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOkButton + fdOpenButton + fdReplaceButton + fdClearButton + fdHelpButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        else begin
          Exit;
        end;```
<br>
