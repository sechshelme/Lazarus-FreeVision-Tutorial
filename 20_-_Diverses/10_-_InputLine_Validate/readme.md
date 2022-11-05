# 20 - Diverses
## 10 - InputLine Validate

![image.png](image.png)

Hier wird eine Bereichsbegrenzung für **PInputLine** gezeigt.
Bei der ersten Zeile ist nur eine Zahl zwischen 0 und 99 erlaubt.
Bei der zweiten Zeile muss es ein Wochentag ( Montag - Freitag ) sein.
Für den zweiten Fall wäre eine ListBox idealer, mir geht zum zeigen wie es mit der **PInputLine** geht.

---

---
**Unit mit dem neuen Dialog.**
<br>
Ein Dialog mit **PInputLine** welche eine Prüfung bekommen.
Wen man **Ok** drückt, wird ein Validate-Prüfungen ausgeführt.
Bei **Abbruch** gibt es keine Prüfung.

```pascal
unit MyDialog;

```

Die Deklaration des Dialoges, hier wird nur das Init überschrieben, welches die Komponenten, für den Dialog erzeugt.
So nebenbei werden noch die beiden Validate überschrieben.
Dies wird nur gemacht, das eine deutsche Fehlermeldung bei falscher Eingabe kommt.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;

  PMyRangeValidator = ^TMyRangeValidator;
  TMyRangeValidator = object(TRangeValidator)
    procedure Error; Virtual;   // Überschreibt die englische Fehlermeldung.
  end;

  PMyStringLookUpValidator = ^TMyStringLookUpValidator;
  TMyStringLookUpValidator = object(TStringLookUpValidator)
    procedure Error; Virtual;   // Überschreibt die englische Fehlermeldung.
  end;

```

Die beiden neuen Fehlermeldungen.

```pascal
procedure TMyRangeValidator.Error;
var
  Params: array[0..1] Of Longint;
begin
  Params[0] := Min;
  Params[1] := Max;
  MessageBox('Wert nicht im Bereich %d bis %d', @Params, mfError or mfOKButton);
end;

procedure TMyStringLookUpValidator.Error;
begin
  MessageBox('Eingabe nicht in g'#129'ltiger Liste', nil, mfError or mfOKButton);
end;

```

Hier sieht man, das eine Validate-Prüfung zu den **PInputLines** dazu kommt.

```pascal
constructor TMyDialog.Init;
const
  // Wochentage, als String, welche in der PInputLine erlaubt sind.
  WochenTag:array[0..6] of String = ('Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');
var
  R: TRect;
  i: Integer;
  InputLine: PInputLine;               // Die Eingabe Zeilen.
  StringCollektion: PStringCollection; // Stringliste, welche die erlaubten Strings enthält.
begin
  // Der Dialog selbst.
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);
  inherited Init(R, 'Validate');

  // --- InputLine mit Bereichsbegrenzung 0-99.
  R.Assign(25, 2, 36, 3);
  InputLine := new(PInputLine, Init(R, 6));
  // Validate-Prüfung 0-99.
  InputLine^.SetValidator(new(PMyRangeValidator, Init(0, 99)));
  Insert(InputLine);
  R.Assign(2, 2, 22, 3);
  Insert(New(PLabel, Init(R, '~B~ereich: 0-99', InputLine)));

  // --- Wochentage
  // Stringliste erzeugen.
  StringCollektion := new(PStringCollection, Init(10, 2));
  // Stringliste mit den Wochentagen laden.
  for i := 0 to 6 do begin
    StringCollektion^.Insert(NewStr(WochenTag[i]));
  end;
  R.Assign(25, 4, 36, 5);
  InputLine := new(PInputLine, Init(R, 10));
  // Überprüfung mit der Stringliste.
  InputLine^.SetValidator(new(PMyStringLookUpValidator, Init(StringCollektion)));
  Insert(InputLine);
  R.Assign(2, 4, 22, 5);
  Insert(New(PLabel, Init(R, '~W~ochentage:', InputLine)));

  // ---Ok-Button
  R.Assign(7, 8, 19, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

  // --- Abbrechen-Button
  R.Assign(24, 8, 36, 10);
  Insert(new(PButton, Init(R, '~A~bbrechen', cmCancel, bfNormal)));
end;

```


