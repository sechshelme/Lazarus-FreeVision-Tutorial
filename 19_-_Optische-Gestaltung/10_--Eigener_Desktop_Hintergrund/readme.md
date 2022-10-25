# 19 - Optische-Gestaltung
## 10 --Eigener Desktop Hintergrund

<img src="image.png" alt="Selfhtml"><br><br>



<hr><br>


```pascal
type
  PMyBackground = ^TMyBackground;
  TMyBackground = object(TView)
    procedure Draw; virtual; // neu Draw-Procedure.
  end;
```






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


