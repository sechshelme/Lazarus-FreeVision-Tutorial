# 19 - Optische-Gestaltung
## 10 --Eigener Desktop Hintergrund

![image.png](image.png)

Man hat sogar die Möglichkeit, den ganzen Background selbst zu zeichnen.
Da man alles selbst zeichent kann man sich den Umweg über **TBackGround** sparen und direkt <B>TView** vererben.
**TBackGround** ist ein direkter Nachkomme von **TView**.

---
Für das Object **TView** wird ein Nachkomme erzeugt, welcher eine neue **Draw** Procedure bekommt.

```pascal
type
  PMyBackground = ^TMyBackground;
  TMyBackground = object(TView)
    procedure Draw; virtual; // neu Draw-Procedure.
  end;
```

In der neuen Funktion wird ein Byte-Muster in Form einer Backsteinwand gezeichnet.
Die Möglickeiten sind unbegrenzt, man kann ein ganzes Bild erzeugen.
Das was man ausgeben will, kommt Zeilenweise in den **TDrawBuffer**.
Anschliessend wird mit **WriteLine(...** der Buffer gezeichnet.

```pascal
  procedure TMyBackground.Draw;
  const
    b1 : array [0..3] of Byte = (196, 193, 196, 194); // obere Backsteinreihe.
    b2 : array [0..3] of Byte = (196, 194, 196, 193); // untere Backsteinreihe.

  var
    Buf1, Buf2: TDrawBuffer;
    i: integer;
  begin
    for i := 0 to Size.X - 1 do begin
      Buf1[i] := b1[i mod 4] + $46 shl 8;
      Buf2[i] := b2[i mod 4] + $46 shl 8;
    end;

    for i := 0 to Size.Y div 2 do begin
      WriteLine(0, i * 2 + 0, Size.X, 1, Buf1);
      WriteLine(0, i * 2 + 1, Size.X, 1, Buf2);
    end;
  end;
```

Der Konstruktor sieht gleich aus wie bei der Hintergrund-Zeichenfarbe.
Dem ist Egal ob **TMyBackground** ein Nachkomme von **TView** oder **TBackground** ist.

```pascal
  constructor TMyApp.Init;
  var
    R: TRect;
  begin
    inherited Init;                                // Vorfahre aufrufen
    GetExtent(R);

    DeskTop^.Insert(New(PMyBackground, Init(R)));  // Hintergrund einfügen.
  end;
```


