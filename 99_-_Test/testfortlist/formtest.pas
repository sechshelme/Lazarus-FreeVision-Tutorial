unit FormTest;

interface

uses
  App, Objects, Drivers, Views, Dialogs, MsgBox, Validate, StdDlg,
  SysUtils;

type
  PFormTest = ^TFormTest;
  TFormTest = object(TDialog)
  pstr:PShortString;
  PListBoxList          : PSortedListBox;//PListBox;
  PScrollBarList        : PScrollBar;
  PSpeedStrList         : PStringCollection;
  PPortStrList          : PStringCollection;
  PEditPort             : PInputLine;
  PEditSpeed            : PInputLine;
  PRadioButtonBytes     : PRadioButtons;
  PRadioButtonPairty    : PRadioButtons;
  PRadioButtonStops     : PRadioButtons;
  PRadioButtonProtocol  : PRadioButtons;
  PRadioButtonType      : PRadioButtons;
  PEditRespTout         : PInputLine;
  PEditDelay            : PInputLine;
  PEditNick             : PInputLine;
  constructor Init();
  procedure HandleEvent(var Event: TEvent); virtual;
  procedure FreeRes;
  end;

implementation

constructor TFormTest.Init();
var
  Rect  : TRect;
  i     : Integer;
  s     : string='Empty';
  PCnt  : DWord;
  PortList: array of DWord;
begin
  //Form
  Rect.Assign(0, 0, 57, 12);
  Rect.Move((Desktop^.Size.X - Rect.B.X) DIV 2, (Desktop^.Size.Y - Rect.B.Y) DIV 2); 
  inherited Init(Rect, 'TLIST_Test');

  //ListBox
          //ScrollBar
  Rect.Assign(54, 2, 55, 6);
  PScrollBarList  := New(PScrollBar, Init(Rect));
  Insert(PScrollBarList );
          //StringList
  PPortStrList := new(PStringCollection, Init(0, 1)); ;  //10,2
  pstr:=NewStr(s);
  PPortStrList^.Insert(pstr);
  //PPortStrList^.Insert(NewStr(s));

  PCnt :=0;

          //ListBox
  Rect.Assign(2, 2, 54, 6);
  PListBoxList:=New( PSortedListBox,Init(Rect,1,PScrollBar(PScrollBarList )));
  PListBoxList^.NewList(PPortStrList);
  Insert(PListBoxList);
          //Label
  Rect.Assign(1, 1,  10, 2);
  insert(new(PLabel, Init(Rect,'List:', PListBoxList)));
  
  //Button
  Rect.Assign(46, 8, 56, 9);
  Insert(new(PButton, Init(Rect, '~S~ave', cmOK, bfDefault))); 

end;

procedure TFormTest.FreeRes;
var
  i:DWord;
  p:PString;
begin
  PListBoxList^.list^.FreeAll;
  PListBoxList^.list^.DeleteAll;
  PListBoxList^.FreeAll;
  Dispose(PPortStrList);
  //PListBoxList^.Done;
end;


procedure TFormTest.HandleEvent(var Event: TEvent);
var
  Counter: integer;
  Rect  : TRect;
begin
  //inherited HandleEvent(Event);
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK:
            begin
              //PEditPort^.Data^:= '123';
              //Close;
              FreeRes;
            end;
        cmCancel:
            begin
              FreeRes;
            end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

begin

end.
