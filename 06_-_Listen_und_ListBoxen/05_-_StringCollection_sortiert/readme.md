# 06 - Listen und ListBoxen
## 05 - StringCollection sortiert

![image.png](image.png)
Eine sortierte String-Liste
für eine sortierte Liste muss man <b>PStringCollection</b> oder <b>PStrCollection</b> verwenden.
---
---
<b>Unit mit dem neuen Dialog.</b>
<br>
Der Dialog mit der <b>StringCollection</b>
Deklaration des Dialog, nichts Besonderes.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;

```

Es wird eine <b>StringCollection</b> gebaut und
als Demonstration wird deren Inhalt in ein StaticText geschrieben.
Man sieht gut, das die Wochentage alphapetisch sortiert sind.

```pascal
constructor TMyDialog.Init;
var
  R: TRect;
  s: shortstring;
  i: Integer;
  StringCollection: PStringCollection;

const
  Tage: array [0..6] of shortstring = (
  'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');

begin
  R.Assign(10, 5, 50, 19);
  inherited Init(R, 'StringCollection Demo');

  // StringCollection
  StringCollection := new(PStringCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;
  s := '';

  for i := 0 to StringCollection^.Count - 1 do begin
    s := s + PString(StringCollection^.At(i))^ + #13;
  end;

  Dispose(StringCollection, Done); // Die Liste freigeben

  R.Assign(5, 2, 36, 12);
  Insert(new(PStaticText, Init(R, s)));

  // Ok-Button
  R.Assign(5, 11, 18, 13);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```


