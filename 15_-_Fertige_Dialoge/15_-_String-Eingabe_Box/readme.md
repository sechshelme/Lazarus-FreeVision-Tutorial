# 15 - Fertige Dialoge
## 15 - String-Eingabe Box
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

---
<br>

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    s:ShortString;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmInputLine: begin
          s := 'Hello world !';
          // Die InputBox
          if InputBox('Eingabe', 'Wert:', s, 255) = cmOK then begin
            MessageBox('Es wurde "' + s + '" eingegeben', nil, mfOKButton);
          end;
        end;
        else begin
          Exit;
        end;
```
<br>

