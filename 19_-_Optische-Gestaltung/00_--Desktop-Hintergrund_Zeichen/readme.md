# 19 - Optische-Gestaltung
## 00 --Desktop-Hintergrund Zeichen

<img src="image.png" alt="Selfhtml"><br><br>
Beim Desktophintergrund kann man ein beliebiges Hintergrund-Zeichen zuordnen. Als Default ist das Zeichen <b>#176</b>.
<hr><br>
Der Hintergrund fügt man ähnlich zu, wie ein Fenster/Dialog, dies geschieht auch mit <b>Insert</b>.
Mit <b>#3</b> füllt es den Hintergrund mit Herzen auf.

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


