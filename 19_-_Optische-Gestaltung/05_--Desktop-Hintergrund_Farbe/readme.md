# 19 - Optische-Gestaltung
## 05 --Desktop-Hintergrund Farbe
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

<br>
---
<br>

```pascal
type
  PMyBackground = ^TMyBackground;
  TMyBackground = object(TBackGround)
    function GetPalette: PPalette; virtual; // neu GetPalette
  end;
```
<br>

<br>
```pascal
  function TMyBackground.GetPalette: PPalette;
  const
    P: string[1] = #74;
  begin
    Result := @P;
  end;
```
<br>

<br>

```pascal
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

