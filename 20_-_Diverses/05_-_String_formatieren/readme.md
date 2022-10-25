# 20 - Diverses
## 05 - String formatieren

<img src="image.png" alt="Selfhtml"><br><br>
Mit <b>FormatStr</b> können Strings formatiert werden.
Dabei sind filgende Formatierungen möglich:
%c: Char
%s: String
%d: Ganzzahlen
%x: Hexadezimal
%#: Formatierungen
Bei Realzahlen muss man sich folgendermassen behelfen:

```pascal
procedure Str(var X: TNumericType[:NumPlaces[:Decimals]];var S: String);
```

<hr><br>
<hr><br>

```pascal
unit MyDialog;

```

Deklaration des Dialogs.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;

```

Bei Integern ist es wichtig, das man diese als <b>PtrInt</b> deklariert.

```pascal
constructor TMyDialog.Init;
const
  acht = 8;
  vier = 16;
  Mo = 'Montag';
  Fr = 'Freitag';

var
  R: TRect;
  Params:record
    s1, s2: PString;
    i1, i2: PtrInt;
  end;
  s: ShortString;

```

Hier sieht man, die Formatierung mit <b>FormatStr</b>.

```pascal
begin
  Params.s1 := NewStr(Mo);
  Params.s2 := NewStr(Fr);
  Params.i1 := acht;
  Params.i2 := vier;

  FormatStr(s, 'Gearbeitet wird zwischen %s und %s'#13+
    'und dies zwischen %d:00 und %d:00 Uhr.', (@Params)^);

  R.Assign(0, 0, 52, 13);
  R.Move(23, 3);
  inherited Init(R, 'String formatieren');

  // ---Statictext;
  R.Assign(3, 2, 50, 5);
  Insert(new(PStaticText, Init(R, s)));

  // ---Ok-Button
  R.Assign(20, 8, 32, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```


