# 19 - Optische-Gestaltung
## 00 --Desktop-Hintergrund Zeichen

<img src="image.png" alt="Selfhtml"><br><br>

---



```pascal
  constructor TMyApp.Init;
  var
    R: TRect;
  begin
    inherited Init;                                      // Vorfahre aufrufen
    GetExtent(R);

    DeskTop^.Insert(New(PBackGround, Init(R, #3)));   // Hintergrund einfügen.
  end;
```


