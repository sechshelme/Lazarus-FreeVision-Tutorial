# 90 - Experimente
## 35 - HistoryViewer

<img src="image.png" alt="Selfhtml"><br><br>
Bei der TListBox muss man unbedingt mit einem Destructor den Speicher der TList freigeben.
Dies ist nicht Free-Vision üblich. Dies hat auch einen Sinn, da man Listen vielfach global verwendet, 
ansonsten müsste man immer eine Kopie davon anlegen.
Dort fehlt der <b>destructor</b>, welcher den Speicher aufräumt.
<hr><br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b>
<br>
Der Dialog mit der ListBox

```pascal
unit MyDialog;

```

Den <b>Destructor</b> deklarieren, welcher den <b>Speicher</b> der List frei gibt.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    ListBox: PListBox;
    StringCollection: PUnSortedStrCollection;

    constructor Init;
    destructor Done; virtual;  // Wegen Speicher Leak in TList
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

Komponenten für den Dialog generieren.

```pascal
const
  cmTag = 1000;  // Lokale Event Konstante

constructor TMyDialog.Init;
var
  R: TRect;
  HScrollBar, VScrollBar: PScrollBar;
  i: Integer;
  hw:PHistoryViewer;
const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');

begin
  R.Assign(10, 5, 64, 17);
  inherited Init(R, 'ListBox Demo');

  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;

  // HScrollBar für ListBox
  R.Assign(5, 7, 31, 8);
  HScrollBar := new(PScrollBar, Init(R));
  Insert(HScrollBar);

  // VScrollBar für ListBox
  R.Assign(31, 2, 32, 7);
  VScrollBar := new(PScrollBar, Init(R));
  Insert(VScrollBar);

  //// ListBox
  //R.A.X := 5;
  //Dec(R.B.X, 1);
  //ListBox := new(PListBox, Init(R, 1, VScrollBar));
  //ListBox^.NewList(StringCollection);
  //Insert(ListBox);

  // ListBox
  R.A.X := 5;
  Dec(R.B.X, 1);
  hw := new(PHistoryViewer, Init(R, HScrollBar, VScrollBar,1));
//  hw^.NewList(StringCollection);
  Insert(hw);



  // Tag-Button
  R.Assign(5, 9, 18, 11);
  Insert(new(PButton, Init(R, '~T~ag', cmTag, bfNormal)));

  // Cancel-Button
  R.Move(15, 0);
  Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));

  // Ok-Button
  R.Move(15, 0);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

Manuell den Speicher der Liste frei geben.

```pascal
destructor TMyDialog.Done;
begin
//  Dispose(ListBox^.List, Done); // Die Liste freigeben
  inherited Done;
end;

```

Der EventHandle
Wen man auf <b>[Tag]</b> klickt, wird der fokusierte Eintrag der ListBox angezeigt.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // mache etwas
        end;
        cmTag: begin
          // Eintrag mit Fokus auslesen
          // Und ausgeben
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' gew' + #132 + 'hlt', nil, mfOKButton);
          // Event beenden.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

```


