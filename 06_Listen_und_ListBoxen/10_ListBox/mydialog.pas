//head+
unit MyDialog;
//head-

interface

{$H-}

uses
  App, Objects, Drivers, Views, Dialogs, MsgBox, StdDlg;

//type+
type
  PMyDialog = ^TMyDialog;

  { TMyDialog }

  TMyDialog = object(TDialog)
  const
    cmTag = 1000;  // Lokale Event Konstante
  var
    ListBox: PListBox;
    StringCollection: PStringCollection;

    constructor Init;
    destructor Done; virtual;  // Wegen Speicher Leak in TList
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  i: Integer;
const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');

begin
  R.Assign(10, 5, 64, 17);
  inherited Init(R, 'ListBox Demo');

  // StringCollection
  StringCollection := new(PStringCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;

  // ScrollBar für ListBox
  R.Assign(31, 2, 32, 7);
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);

  // ListBox
  R.A.X := 5;
  Dec(R.B.X, 1);
  ListBox := new(PListBox, Init(R, 1, ScrollBar));
  ListBox^.NewList(StringCollection);
  Insert(ListBox);

  // Tag-Button
  R.Assign(5, 9, 18, 10);
  Insert(new(PButton, Init(R, '~T~ag', cmTag, bfNormal)));

  // Cancel-Button
  R.Move(15, 0);
  Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));

  // Ok-Button
  R.Move(15, 0);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
//init-

//done+
destructor TMyDialog.Done;
begin
  Dispose(ListBox^.List, Done); // Die Liste freigeben
  inherited Done;
end;
//done-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  s: shortstring;
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // mache etwas
        end;
        cmTag: begin
          str(ListBox^.Focused + 1, s);
          // Eintrag mit Fokus auslesen
          s := PString(ListBox^.GetFocusedItem)^;
          // Und ausgeben
          MessageBox('Wochentag: ' + s + ' gew' + #132 + 'hlt', nil, mfOKButton);
          // Event beenden.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;
//handleevent-

end.
