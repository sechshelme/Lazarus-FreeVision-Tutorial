# 20 - Diverses
## 05 - String formatieren
<img src="image.png" alt="Selfhtml"><br><br>
Mit <b>FormatStr</b> können Strings formatiert werden.<br>
Dabei sind filgende Formatierungen möglich:<br>
%c: Char<br>
%s: String<br>
%d: Ganzzahlen<br>
%x: Hexadezimal<br>
%#: Formatierungen<br>
Bei Realzahlen muss man sich folgendermassen behelfen:<br>
```pascal>procedure Str(var X: TNumericType[:NumPlaces[:Decimals]];var S: String);```
---
---
<pre><code>unit MyDialog;
</code></pre>
Deklaration des Dialogs.<br>
<pre><code>type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;
</code></pre>
Bei Integern ist es wichtig, das man diese als <b>PtrInt</b> deklariert.<br>
<pre><code>constructor TMyDialog.Init;
const
  acht = 8;</font>
  vier = 16;</font>
  Mo = 'Montag';</font>
  Fr = 'Freitag';</font>
<br>
var
  R: TRect;
  Params:record
    s1, s2: PString;
    i1, i2: PtrInt;
  end;
  s: ShortString;
</code></pre>
Hier sieht man, die Formatierung mit <b>FormatStr</b>.<br>
<pre><code>begin
  Params.s1 := NewStr(Mo);
  Params.s2 := NewStr(Fr);
  Params.i1 := acht;
  Params.i2 := vier;
<br>
  FormatStr(s, 'Gearbeitet wird zwischen %s und %s'#13+
    'und dies zwischen %d:00 und %d:00 Uhr.', (@Params)^);
<br>
  R.Assign(0, 0, 52, 13);</font>
  R.Move(23, 3);</font>
  inherited Init(R, 'String formatieren');</font>
<br>
  // ---Statictext;
  R.Assign(3, 2, 50, 5);</font>
  Insert(new(PStaticText, Init(R, s)));
<br>
  // ---Ok-Button
  R.Assign(20, 8, 32, 10);</font>
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
end;
</code></pre>
<br>
