unit FormTest;

interface

{$H-}

uses
  App, Objects, Drivers, Views, Dialogs, MsgBox, StdDlg,
  SysUtils;

type
  PFormTest = ^TFormTest;

  TFormTest = object(TDialog)
    constructor Init();
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

implementation

constructor TFormTest.Init();
var
  Rect: TRect;
  ListBox: PListBox;
  ScrollBar: PScrollBar;
  Collection: PCollection;

begin
  Rect.Assign(10, 5, 67, 17);
  inherited Init(Rect, 'TLIST_Test');

  //ScrollBar
  Rect.Assign(54, 2, 55, 6);
  ScrollBar := New(PScrollBar, Init(Rect));
  Insert(ScrollBar);

  //StringList
  Collection := new(PCollection, Init(0, 1));
  Collection^.Insert(NewStr('Montag'));
  Collection^.Insert(NewStr('Dienstag'));
  Collection^.Insert(NewStr('Mittwoch'));
  Collection^.Insert(NewStr('Donnerstag'));
  Collection^.Insert(NewStr('Freitag'));
  Collection^.Insert(NewStr('Samstag'));
  Collection^.Insert(NewStr('Sonntag'));

  //ListBox
  Rect.Assign(2, 2, 54, 6);
  ListBox := New(PListBox, Init(Rect, 1, ScrollBar));
  ListBox^.NewList(Collection);
  Insert(ListBox);
  //Label
  Rect.Assign(1, 1, 10, 2);
  insert(new(PLabel, Init(Rect, 'List:', ListBox)));

  //Button
  Rect.Assign(46, 8, 56, 9);
  Insert(new(PButton, Init(Rect, '~S~ave', cmOK, bfDefault)));

end;

procedure TFormTest.HandleEvent(var Event: TEvent);
begin
  //inherited HandleEvent(Event);
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          //PEditPort^.Data^:= '123';
          //Close;
        end;
        cmCancel: begin
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

begin

end.
