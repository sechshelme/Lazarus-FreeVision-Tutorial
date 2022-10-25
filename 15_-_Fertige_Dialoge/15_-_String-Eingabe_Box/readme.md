# 15 - Fertige Dialoge
## 15 - String-Eingabe Box
<img src="image.png" alt="Selfhtml"><br><br>
Es gibt auch einen fertigen Dialog für eine String-Eingabe.<br>
Es gibt noch <b>InputBoxRect</b>, dort kann man die Grösser der Box selbst festlegen.<br>
---
So sieht der Code für die String-Eingabe aus.<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    s:ShortString;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmInputLine: begin
          s := 'Hello world !';</font>
          // Die InputBox
          if InputBox('Eingabe', 'Wert:', s, 255) = cmOK then begin</font>
            MessageBox('Es wurde "' + s + '" eingegeben', nil, mfOKButton);
          end;
        end;
        else begin
          Exit;
        end;```
<br>
