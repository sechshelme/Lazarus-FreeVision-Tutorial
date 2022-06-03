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
    ListBox: PListBox;
    StringCollection: PUnSortedStrCollection;

    constructor Init;
    destructor Done; virtual;  // Wegen Speicher Leak in TList
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
const
  cmMonat = 1000;  // Lokale Event Konstante
  cmNew = 1001;
  cmDelete = 1002;

constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  i: integer;
const
  Tage: array [0..11] of shortstring = (
    'Januar', 'Februar', 'M' + #132'rz', 'April', 'Mai', 'Juni', 'Juli',
    'August', 'September', 'Oktober', 'November', 'Dezember');

begin
  R.Assign(10, 3, 64, 17);
  inherited Init(R, 'ListBox Demo');

  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;

  // ScrollBar für ListBox
  R.Assign(22, 2, 23, 10);
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);

  // ListBox
  R.A.X := 5;
  Dec(R.B.X, 1);
  ListBox := new(PListBox, Init(R, 1, ScrollBar));
  ListBox^.NewList(StringCollection);
  Insert(ListBox);

  // Tag-Button
  R.A.X := R.B.X + 5;
  R.B.X := R.A.X + 14;
  R.A.Y := 2;
  R.B.Y := R.A.Y + 2;
  Insert(new(PButton, Init(R, '~M~onat', cmMonat, bfNormal)));

  // Neu-Button
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~N~eu', cmNew, bfNormal)));

  // Enfernen
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~E~ntfernen', cmDelete, bfNormal)));

  // Cancel-Button
  R.Move(0, 2);
  Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));

  // Ok-Button
  R.Move(0, 2);
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
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // mache etwas
        end;
        cmNew: begin
          // mache etwas
        end;
        cmDelete: begin
          ListBox^.FreeItem(ListBox^.Focused);
          ListBox^.Draw;
        end;
        cmMonat: begin
          if ListBox^.List^.Count > 0 then begin
            // Eintrag mit Fokus auslesen
            // Und ausgeben
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
//handleevent-

end.
