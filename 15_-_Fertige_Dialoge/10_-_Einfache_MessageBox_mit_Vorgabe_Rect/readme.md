# 15 - Fertige Dialoge
## 10 - Einfache MessageBox mit Vorgabe Rect
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

---
<br>

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    R: TRect;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          R.Assign(10, 3, 28, 20);  // Grösse der Box
          MessageBoxRect(R, 'Ich bin eine vorgegebene Box', nil, mfInformation + mfOkButton);
        end;
```
<br>

