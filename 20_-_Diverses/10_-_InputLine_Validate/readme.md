# 20 - Diverses
## 10 - InputLine Validate

<img src="image.png" alt="Selfhtml"><br><br>




---
---






```pascal
unit MyDialog;

```





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


