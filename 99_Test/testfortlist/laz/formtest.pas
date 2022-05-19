unit FormTest;

interface

{$H-}

uses
  App, Objects, Drivers, Views, Dialogs, MsgBox, Validate, StdDlg,
  SysUtils;

type
  PFormTest = ^TFormTest;

  TFormTest = object(TDialog)
    pstr: pshortstring;
    ListBoxList: PSortedListBox;//PListBox;
    PScrollBarList: PScrollBar;
    PSpeedStrList: PStringCollection;
    PPortStrList: PStringCollection;
    PEditPort: PInputLine;
    PEditSpeed: PInputLine;
    PRadioButtonBytes: PRadioButtons;
    PRadioButtonPairty: PRadioButtons;
    PRadioButtonStops: PRadioButtons;
    PRadioButtonProtocol: PRadioButtons;
    PRadioButtonType: PRadioButtons;
    PEditRespTout: PInputLine;
    PEditDelay: PInputLine;
    PEditNick: PInputLine;
    constructor Init();
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure FreeRes;
  end;

implementation

constructor TFormTest.Init();
var
  Rect: TRect;
begin
  //Form
  Rect.Assign(0, 0, 57, 12);
  Rect.Move((Desktop^.Size.X - Rect.B.X) div 2, (Desktop^.Size.Y - Rect.B.Y) div 2);
  inherited Init(Rect, 'TLIST_Test');

  //ListBox
  //ScrollBar
  Rect.Assign(54, 2, 55, 6);
  PScrollBarList := New(PScrollBar, Init(Rect));
  Insert(PScrollBarList);
  //StringList
  PPortStrList := new(PStringCollection, Init(0, 1));
  ;  //10,2

  PPortStrList^.Insert(NewStr('Montag'));
  PPortStrList^.Insert(NewStr('Dienstag'));
  PPortStrList^.Insert(NewStr('Mittwoch'));
  PPortStrList^.Insert(NewStr('Donnerstag'));
  PPortStrList^.Insert(NewStr('Freitag'));
  PPortStrList^.Insert(NewStr('Samstag'));
  PPortStrList^.Insert(NewStr('Sonntag'));

  //ListBox
  Rect.Assign(2, 2, 54, 6);
  ListBoxList := New(PSortedListBox, Init(Rect, 1, PScrollBar(PScrollBarList)));
  ListBoxList^.NewList(PPortStrList);
  Insert(ListBoxList);
  //Label
  Rect.Assign(1, 1, 10, 2);
  insert(new(PLabel, Init(Rect, 'List:', ListBoxList)));

  //Button
  Rect.Assign(46, 8, 56, 9);
  Insert(new(PButton, Init(Rect, '~S~ave', cmOK, bfDefault)));

end;

procedure TFormTest.FreeRes;
var
  i: DWord;
  p: PString;
begin
  //ListBoxList^.list^.FreeAll;
  //ListBoxList^.list^.DeleteAll;
  //ListBoxList^.FreeAll;
  //Dispose(PPortStrList);
  //ListBoxList^.Done;
end;


procedure TFormTest.HandleEvent(var Event: TEvent);
var
  Counter: integer;
  Rect: TRect;
begin
  //inherited HandleEvent(Event);
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          //PEditPort^.Data^:= '123';
          //Close;
          FreeRes;
        end;
        cmCancel: begin
          FreeRes;
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

begin

end.
