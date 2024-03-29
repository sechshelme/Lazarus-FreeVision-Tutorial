//head+
unit MyDialog;
//head-

interface

{$H-}



uses
  App, Objects, Drivers, Views, Dialogs, MsgBox, StdDlg,
  SysUtils; // Für IntToStr und StrToInt.

//type+
type
  PMyDialog = ^TMyDialog;

  TMyDialog = object(TDialog)
  const
    cmTag = 1000;
  var
    ListBox: PListBox;

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  StringCollection: PCollection;

begin
  R.Assign(10, 5, 67, 17);
  inherited Init(R, 'ListBox Demo');

  Title := NewStr('dfsfdsa');

  // ListBox
  R.Assign(31, 2, 32, 7);
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);

  StringCollection := new(PCollection, Init(0, 1));
  StringCollection^.Insert(NewStr('Montag'));
  StringCollection^.Insert(NewStr('Dienstag'));
  StringCollection^.Insert(NewStr('Mittwoch'));
  StringCollection^.Insert(NewStr('Donnerstag'));
  StringCollection^.Insert(NewStr('Freitag'));
  StringCollection^.Insert(NewStr('Samstag'));
  StringCollection^.Insert(NewStr('Sonntag'));

  R.Assign(5, 2, 31, 7);
  ListBox := new(PListBox, Init(R, 1, ScrollBar));
  ListBox^.NewList(StringCollection);

  Insert(ListBox);
  ListBox^.Insert(NewStr('aaaaaaaaa'));

  ListBox^.List^.Insert(NewStr('bbbbbbb'));
  ListBox^.SetRange(ListBox^.List^.Count);



  // Cancel-Button
  R.Assign(19, 9, 32, 10);
  Insert(new(PButton, Init(R, '~T~ag', cmTag, bfNormal)));

  // Ok-Button
  R.Assign(7, 9, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  s: string;

begin
  inherited HandleEvent(Event);

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmTag: begin
          str(ListBox^.Focused + 1, s);
          MessageBox('Wochentag: ' + s + ' gew' + #132 + 'hlt', nil, mfOKButton);
          ClearEvent(Event);   // Event beenden.
        end;
      end;
    end;
  end;

end;
//handleevent-

end.
