# 19 - Optische-Gestaltung
## 05 --Desktop-Hintergrund Farbe
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Wen man die Farbe des Hintergrundes änder will, ist ein wenig komplizierter als nur das Zeichen.<br>
Dazu muss man beim Object <b>TBackground</b> die Funktion <b>GetPalette</b> überschreiben.<br>
<br>
<hr><br>
Für das Object <b>TBackground</b> wird ein Nachkomme erzeugt, welcher eine neue <b>GetPalette</b> Funktion bekommt.<br>
LineEnding+```pascal
type
  PMyBackground = ^TMyBackground;
  TMyBackground = object(TBackGround)
    function GetPalette: PPalette; virtual; // neu GetPalette
  end;
```
<br>
In der neuen Funktion wird eine andere Palette zugeordnet.<br>
LineEnding+```pascal
  function TMyBackground.GetPalette: PPalette;
  const
    P: string[1] = #74;
  begin
    Result := @P;
  end;
```
<br>
Der Konstruktor sieht fast gleich aus wie beim Hintergrundzeichen.<br>
Einziger Unterschied anstelle von <b>PBackGround</b> wird <b>PMyBackground</b> genommen.<br>
LineEnding+```pascal
  constructor TMyApp.Init;
  var
    R:TRect;
  begin
    inherited Init;                                       // Vorfahre aufrufen
    GetExtent(R);
<br>
    DeskTop^.Insert(New(PMyBackground, Init(R, #3)));  // Hintergrund einfügen.
  end;
```
<br>

