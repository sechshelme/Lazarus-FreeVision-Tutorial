# 19 - Optische-Gestaltung
## 00 --Desktop-Hintergrund Zeichen
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>
---
<br>

<br>
```pascal
  constructor TMyApp.Init;
  var
    R: TRect;
  begin
    inherited Init;                                      // Vorfahre aufrufen
    GetExtent(R);
<br>
    DeskTop^.Insert(New(PBackGround, Init(R, #3)));   // Hintergrund einfügen.
  end;
```
<br>

