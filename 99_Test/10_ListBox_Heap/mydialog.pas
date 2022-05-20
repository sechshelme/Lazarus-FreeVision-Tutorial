//head+
unit MyDialog;
//head-

interface

{$H-}



uses
  App, Objects, Drivers, Views, Dialogs, MsgBox, StdDlg,
  SysUtils; // Für IntToStr und StrToInt.

type

  { TNewListBox }

  PNewListBox = ^TNewListBox;
  TNewListBox = object(TSortedListBox)
    destructor Done; virtual;
  end;


//type+
type
  PMyDialog = ^TMyDialog;

  TMyDialog = object(TDialog)
  const
    cmTag = 1000;
  var
    ListBox: PNewListBox;

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

{ TNewListBox }

destructor TNewListBox.Done;
begin
//  if List <> nil then Dispose(List, Done);
//  TListBox.Done;
//  FreeAll;
  inherited Done;
end;

//init+
constructor TMyDialog.Init;
var
  Rect: TRect;
  ScrollBar: PScrollBar;
  StringCollection: PCollection;

begin
  Rect.Assign(10, 5, 67, 17);
  inherited Init(Rect, 'ListBox Demo');

  //  Title := NewStr('dfsfdsa');

  // ListBox
  Rect.Assign(31, 2, 32, 7);
  ScrollBar := new(PScrollBar, Init(Rect));
  Insert(ScrollBar);

//  StringCollection := new(PCollection, Init(2, 1));
  StringCollection := new(PCollection, Init(4, 1));
  StringCollection^.Insert(NewStr('Montag'));
  StringCollection^.Insert(NewStr('Dienstag'));
  StringCollection^.Insert(NewStr('Mittwoch'));
  StringCollection^.Insert(NewStr('Donnerstag'));
  StringCollection^.Insert(NewStr('Freitag'));
  StringCollection^.Insert(NewStr('Samstag'));
  StringCollection^.Insert(NewStr('Sonntag'));

  Rect.Assign(5, 2, 31, 7);
  ListBox := new(PNewListBox, Init(Rect, 1, ScrollBar));
  ListBox^.NewList(StringCollection);

  Insert(ListBox);
  //ListBox^.Insert(NewStr('aaaaaaaaa'));
  //
  //ListBox^.List^.Insert(NewStr('bbbbbbb'));
  //ListBox^.SetRange(ListBox^.List^.Count);



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
  s: string;

begin
  inherited HandleEvent(Event);

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
//          MessageBox('Wochentag', nil, mfOKButton);
        end;

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
