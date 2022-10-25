# 15 - Fertige Dialoge
## 25 - Ordner wechseln
<img src="image.png" alt="Selfhtml"><br><br>
Ordner Wechsel Dialog.<br>
Der <b>PChDirDialog</b>.<br>
---
Der Ordnerwechsel Dialog<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    ChDirDialog: PChDirDialog;
    Ordner: ShortString;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmChDir: begin
          New(ChDirDialog, Init(fdOpenButton, 1));</font>
          if ExecuteDialog(ChDirDialog, nil) <> cmCancel then begin
            MessageBox('Ordner wurde gewechselt', nil, mfOKButton);
          end;
        end;
        else begin
          Exit;
        end;```
<br>
