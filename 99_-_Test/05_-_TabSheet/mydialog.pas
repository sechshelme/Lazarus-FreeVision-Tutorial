//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs, Tabs;

//type+
const
  cmMsg = 1003;  //

type
  PMyAbout = ^TMyAbout;

  TMyAbout = object(TDialog)

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyAbout.Init;
var
  R: TRect;
  Tabdef: PTabDef;
  Tab: PTab;
  bt0, bt1, bt2: PButton;
  Group: PGroup;
begin
  R.Assign(0, 0, 42, 16);
  R.Move(23, 3);
  inherited Init(R, 'About');

  R.Assign(2, 4, 12, 6);
  bt0 := new(PButton, Init(R, 'bt~a~', cmValid, bfDefault));
  R.Assign(2, 6, 12, 8);
  bt1 := new(PButton, Init(R, 'bt~b~', cmValid, bfDefault));
  R.Assign(2, 8, 12, 19);
  bt2 := new(PButton, Init(R, 'bt~c~', cmValid, bfDefault));


  // Tab
  R.Assign(1, 1, 10, 5);
  Group := new(PGroup, Init(R));
  Group^.BackgroundChar := 'x';

  R.Assign(5, 2, 41, 13);
  Tabdef := NewTabDef('Tab~1~', bt1, NewTabItem(bt0, NewTabItem(bt1, NewTabItem(bt2, nil))), NewTabDef('Tab~2~', nil, nil, nil));
  Tab := new(PTab, Init(R, Tabdef));

  Insert(Tab);

  // MessageBox-Button, mit lokalem Ereigniss.
  R.Assign(19, 13, 32, 15);
  Insert(new(PButton, Init(R, '~M~sg-Box', cmMsg, bfNormal)));

  // Ok-Button
  R.Assign(7, 13, 17, 15);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyAbout.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);

  case Event.What of
    evCommand: begin
      case Event.Command of
        // Lokales Ereigniss ausführen.
        cmMsg: begin
          MessageBox('Ich bin eine MessageBox !', nil, mfOKButton);
          ClearEvent(Event);  // Event beenden.
        end;
      end;
    end;
  end;

end;
//handleevent-

end.
