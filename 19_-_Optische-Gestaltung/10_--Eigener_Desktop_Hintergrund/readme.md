# 19 - Optische-Gestaltung
## 10 --Eigener Desktop Hintergrund
<br>
Man hat sogar die Möglichkeit, den ganzen Background selbst zu zeichnen.<br>
Da man alles selbst zeichent kann man sich den Umweg über <b>TBackGround</b> sparen und direkt <B>TView</b> vererben.<br>
<b>TBackGround</b> ist ein direkter Nachkomme von <b>TView</b>.<br>
<hr><br>
Für das Object <b>TView</b> wird ein Nachkomme erzeugt, welcher eine neue <b>Draw</b> Procedure bekommt.<br>
```pascal
type
  PMyBackground = ^TMyBackground;
  TMyBackground = object(TView)
    procedure Draw; virtual; // neu Draw-Procedure.
  end;
```
In der neuen Funktion wird ein Byte-Muster in Form einer Backsteinwand gezeichnet.<br>
Die Möglickeiten sind unbegrenzt, man kann ein ganzes Bild erzeugen.<br>
Das was man ausgeben will, kommt Zeilenweise in den <b>TDrawBuffer</b>.<br>
Anschliessend wird mit <b>WriteLine(...</b> der Buffer gezeichnet.<br>
```pascal
  procedure TMyBackground.Draw;
  const
    b1 : array [0..3] of Byte = (196, 193, 196, 194); // obere Backsteinreihe.
    b2 : array [0..3] of Byte = (196, 194, 196, 193); // untere Backsteinreihe.
<br>
  var
    Buf1, Buf2: TDrawBuffer;
    i: integer;
  begin
    for i := 0 to Size.X - 1 do begin
      Buf1[i] := b1[i mod 4] + $46 shl 8;
      Buf2[i] := b2[i mod 4] + $46 shl 8;
    end;
<br>
    for i := 0 to Size.Y div 2 do begin
      WriteLine(0, i * 2 + 0, Size.X, 1, Buf1);
      WriteLine(0, i * 2 + 1, Size.X, 1, Buf2);
    end;
  end;
```
Der Konstruktor sieht gleich aus wie bei der Hintergrund-Zeichenfarbe.<br>
Dem ist Egal ob <b>TMyBackground</b> ein Nachkomme von <b>TView</b> oder <b>TBackground</b> ist.<br>
```pascal
  constructor TMyApp.Init;
  var
    R: TRect;
  begin
    inherited Init;                                // Vorfahre aufrufen
    GetExtent(R);
<br>
    DeskTop^.Insert(New(PMyBackground, Init(R)));  // Hintergrund einfügen.
  end;
```
<br>
