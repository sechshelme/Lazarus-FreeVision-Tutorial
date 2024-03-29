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
  TMyDialog = object(TDialog)
  const
    cmTag = 1000;  // Lokale Event Konstante
  var
    ListBox: PListBox;
    StringCollection: PStringCollection;

    constructor Init;
    destructor Done; virtual;  // Wegen Speicher Leak
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  i: Sw_Integer;
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
  R.Assign(5, 2, 31, 7);
  ListBox := new(PListBox, Init(R, 1, ScrollBar));
  ListBox^.NewList(StringCollection);
  Insert(ListBox);

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
//init-

//done+
destructor TMyDialog.Done;
begin
   Dispose(ListBox^.List, Done); // Dies Versuchsweise ausklammern
   inherited Done;
end;
//done-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  s: ShortString;
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // mache etwas
        end;
        cmTag: begin
          str(ListBox^.Focused + 1, s);
          MessageBox('Wochentag: ' + s + ' gew' + #132 + 'hlt', nil, mfOKButton);
          ClearEvent(Event);  // Event beenden.
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;
//handleevent-

end.
