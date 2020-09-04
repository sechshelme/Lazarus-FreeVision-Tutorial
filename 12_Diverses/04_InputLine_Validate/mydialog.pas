//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs, Validate;

//type+
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
//type-



implementation

//RV+
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
//RV-

//init+
constructor TMyDialog.Init;
const
  // Wochentage, als String, welche in der PInputLine erlaubt sind.
  WochenTag:array[0..6] of String = ('Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');
var
  Rect: TRect;
  // Die Eingabe Zeilen.
  InputLine: PInputLine;
  // Stringliste, welche die erlaubten Strings enthält.
  StringKollektion: PStringCollection;
  i: Integer;
begin
  // Der Dialog selbst.
  Rect.Assign(0, 0, 42, 11);
  Rect.Move(23, 3);
  inherited Init(Rect, 'Validate');

  // --- InputLine mit Bereichsbegrenzung 0-99.
  Rect.Assign(25, 2, 36, 3);
  InputLine := new(PInputLine, Init(Rect, 6));
  // Validate-Prüfung 0-99.
  InputLine^.SetValidator(new(PMyRangeValidator, Init(0, 99)));
  Insert(InputLine);
  Rect.Assign(2, 2, 22, 3);
  Insert(New(PLabel, Init(Rect, '~B~ereich: 0-99', InputLine)));

  // --- Wochentage
  // Stringliste erzeugen.
  StringKollektion := new(PStringCollection, Init(10, 2));
  // Stringliste mit den Wochentagen laden.
  for i := 0 to 6 do begin
    StringKollektion^.Insert(NewStr(WochenTag[i]));
  end;
  Rect.Assign(25, 4, 36, 5);
  InputLine := new(PInputLine, Init(Rect, 10));
  // Überprüfung mit der Stringliste.
  InputLine^.SetValidator(new(PMyStringLookUpValidator, Init(StringKollektion)));
  Insert(InputLine);
  Rect.Assign(2, 4, 22, 5);
  Insert(New(PLabel, Init(Rect, '~W~ochentage:', InputLine)));

  // ---Ok-Button
  Rect.Assign(7, 8, 19, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));

  // --- Abbrechen-Button
  Rect.Assign(24, 8, 36, 10);
  Insert(new(PButton, Init(Rect, '~A~bbrechen', cmCancel, bfNormal)));
end;
//init-

end.
