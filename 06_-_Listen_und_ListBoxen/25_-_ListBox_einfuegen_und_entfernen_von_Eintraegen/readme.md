# 06 - Listen und ListBoxen
## 25 - ListBox einfuegen und entfernen von Eintraegen
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Bei <b>ListBox</b> kann man auch Einträge einfügen, entfernen, etc.<br>
ZT. muss man da direkt auf die Liste zugreifen.<br>
<hr><br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der mehrspaltigen ListBox<br>
```pascal
unit MyDialog;
<br>
```
Den <b>Destructor</b> deklarieren, welcher den <b>Speicher</b> der List frei gibt.<br>
```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    ListBox: PListBox;
    StringCollection: PUnSortedStrCollection;
<br>
    constructor Init;
    destructor Done; virtual;  // Wegen Speicher Leak in TList
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
<br>
```
Komponenten für den Dialog generieren.<br>
```pascal
const
  cmMonat = 1000;  // Lokale Event Konstante
  cmNewFocus = 1001;
  cmNewBack = 1002;
  cmDelete = 1003;
<br>
constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  i: integer;
const
  Tage: array [0..11] of shortstring = (
    'Januar', 'Februar', 'M' + #132'rz', 'April', 'Mai', 'Juni', 'Juli',
    'August', 'September', 'Oktober', 'November', 'Dezember');
<br>
begin
  R.Assign(10, 3, 64, 20);
  inherited Init(R, 'ListBox Demo');
<br>
  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;
<br>
  // ScrollBar für ListBox
  R.Assign(22, 2, 23, 16);
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);
<br>
  // ListBox
  R.A.X := 5;
  Dec(R.B.X, 1);
  ListBox := new(PListBox, Init(R, 1, ScrollBar));
  ListBox^.NewList(StringCollection);
  Insert(ListBox);
<br>
  // Tag-Button
  R.A.X := R.B.X + 5;
  R.B.X := R.A.X + 14;
  R.A.Y := 2;
  R.B.Y := R.A.Y + 2;
  Insert(new(PButton, Init(R, '~M~onat', cmMonat, bfNormal)));
<br>
  // Neu Button bei fukosierten Eintrag
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~N~eu fokus', cmNewFocus, bfNormal)));
<br>
  // Neu-Button am Ende der List
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~N~eu hinten', cmNewBack, bfNormal)));
<br>
  // Enfernen
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~E~ntfernen', cmDelete, bfNormal)));
<br>
  // Cancel-Button
  R.Move(0, 3);
  Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));
<br>
  // Ok-Button
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
<br>
```
Manuell den Speicher der Liste frei geben.<br>
```pascal
destructor TMyDialog.Done;
begin
  Dispose(ListBox^.List, Done); // Die Liste freigeben
  inherited Done;
end;
<br>
```
Der EventHandle<br>
Hier sieht man, wie man Einträge einfügt und entfernt.<br>
```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // mache etwas
        end;
        cmNewFocus: begin
          // Fügt beim markierten Eintrag einen neuen Eintrag ein
          ListBox^.List^.AtInsert(ListBox^.Focused, NewStr('neu'));
          ListBox^.SetRange(ListBox^.List^.Count);
          ListBox^.Draw;
        end;
        cmNewBack: begin
          // Fügt hinten einen neuen Eintrag ein
          ListBox^.Insert(NewStr('neu'));
          ListBox^.Draw;
        end;
        cmDelete: begin
          // Löscht den fokusierte Eintrag
          ListBox^.FreeItem(ListBox^.Focused);
          ListBox^.Draw;
        end;
        cmMonat: begin
          // Eintrag mit Fokus ausgeben
          if ListBox^.List^.Count &gt; 0 then begin
            MessageBox('Monat: ' + PString(ListBox^.GetFocusedItem)^ + ' gew' + #132 + 'hlt', nil, mfOKButton);
          end;
          // Event beenden.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;
<br>
```
<br>
