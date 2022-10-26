# 15 - Fertige Dialoge
## 10 - Einfache MessageBox mit Vorgabe Rect

![image.png](image.png)
Bei der MessageBox, kann man die Grösse auch manuell festlegen.
Dazu muss man <b>MeassgeBoxRect(...)</b> verwenden.
---
Hier wird mir <b>R.Assign</b> die grösse der Box selbst festgelegt.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    R: TRect;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          R.Assign(10, 3, 28, 20);  // Grösse der Box
          MessageBoxRect(R, 'Ich bin eine vorgegebene Box', nil, mfInformation + mfOkButton);
        end;
```


