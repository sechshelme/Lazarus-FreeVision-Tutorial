# 15 - Fertige Dialoge
## 15 - String-Eingabe Box

![image.png](image.png)

Es gibt auch einen fertigen Dialog für eine String-Eingabe.
Es gibt noch <b>InputBoxRect</b>, dort kann man die Grösser der Box selbst festlegen.
---
So sieht der Code für die String-Eingabe aus.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    s:ShortString;
  begin
    inherited HandleEvent(Event);

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


