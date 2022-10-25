# 20 - Diverses
## 05 - String formatieren
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

<br>

<br>

<br>

<br>
```pascal
procedure Str(var X: TNumericType[:NumPlaces[:Decimals]];var S: String);
```
<br>
---
---
<br>
```pascal
unit MyDialog;
<br>
```
<br>

<br>
```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;
<br>
```
<br>

<br>
```pascal
constructor TMyDialog.Init;
const
  acht = 8;
  vier = 16;
  Mo = 'Montag';
  Fr = 'Freitag';
<br>
var
  R: TRect;
  Params:record
    s1, s2: PString;
    i1, i2: PtrInt;
  end;
  s: ShortString;
<br>
```
<br>

<br>
```pascal
begin
  Params.s1 := NewStr(Mo);
  Params.s2 := NewStr(Fr);
  Params.i1 := acht;
  Params.i2 := vier;
<br>
  FormatStr(s, 'Gearbeitet wird zwischen %s und %s'#13+
    'und dies zwischen %d:00 und %d:00 Uhr.', (@Params)^);
<br>
  R.Assign(0, 0, 52, 13);
  R.Move(23, 3);
  inherited Init(R, 'String formatieren');
<br>
  // ---Statictext;
  R.Assign(3, 2, 50, 5);
  Insert(new(PStaticText, Init(R, s)));
<br>
  // ---Ok-Button
  R.Assign(20, 8, 32, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
<br>
```
<br>

