# 06 - Listen und ListBoxen
## 00 - StringCollection unsortiert
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

---
---
<br>

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
var
  R: TRect;
  s: shortstring;
  i: Integer;
  StringCollection: PUnSortedStrCollection;
<br>
const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');
<br>
begin
  R.Assign(10, 5, 50, 19);
  inherited Init(R, 'StringCollection Demo');
<br>
  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;
  s := '';
<br>
  for i := 0 to StringCollection^.Count - 1 do begin
    s := s + PString(StringCollection^.At(i))^ + #13;
  end;
<br>
  Dispose(StringCollection, Done); // Die Liste freigeben
<br>
  R.Assign(5, 2, 36, 12);
  Insert(new(PStaticText, Init(R, s)));
<br>
  // Ok-Button
  R.Assign(5, 11, 18, 13);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
<br>
```
<br>

