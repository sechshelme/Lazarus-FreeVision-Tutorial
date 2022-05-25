//head+
unit MyDialog;
//head-

interface

{$H-}

//{$X+,R-,I-,Q-,V-}


uses
  App, Objects, Drivers, Views, Dialogs, MsgBox, StdDlg;

//typenewlistbox+
type
  PListBox = ^TListBox;
  TListBox = object(Dialogs.TListBox)
    destructor Done; virtual;
  end;
//typenewlistbox-

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
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

{ TMyLisBox }

//donelistbox+
destructor TListBox.Done;
begin
  if List <> nil then begin
    Dispose(List, Done);
  end;
  inherited Done;
end;
//donelistbox-

//init+
constructor TMyDialog.Init;
var
  Rect: TRect;
  ScrollBar: PScrollBar;
  i: Sw_Integer;
const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');

begin
  Rect.Assign(10, 5, 67, 17);
  inherited Init(Rect, 'ListBox Demo');

  // StringCollection
  StringCollection := new(PStringCollection, Init(5, 5));
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;

  // ScrollBar für ListBox
  Rect.Assign(31, 2, 32, 7);
  ScrollBar := new(PScrollBar, Init(Rect));
  Insert(ScrollBar);

  // ListBox
  Rect.Assign(5, 2, 31, 7);
  ListBox := new(PListBox, Init(Rect, 1, ScrollBar));
  ListBox^.NewList(StringCollection);
  Insert(ListBox);

  // Cancel-Button
  Rect.Assign(19, 9, 32, 10);
  Insert(new(PButton, Init(Rect, '~T~ag', cmTag, bfNormal)));

  // Ok-Button
  Rect.Assign(7, 9, 17, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;
//init-

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
