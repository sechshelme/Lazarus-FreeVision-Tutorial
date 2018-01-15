//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs;

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
  Rect: TRect;
begin
  Rect.Assign(0, 0, 42, 11);
  Rect.Move(23, 3);
  inherited Init(Rect, 'About');

  // StaticText
  Rect.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(Rect,
    'Free Vison Tutorial 1.0' + #13 +
    '2017' + #13 +
    'Gechrieben von M. Burkhard'+ #13#32#13 +
    'FPC: '+ {$I %FPCVERSION%} + '   OS:'+ {$I %FPCTARGETOS%} + '   CPU:' + {$I %FPCTARGETCPU%})));

  // MessageBox-Button, mit lokalem Ereigniss.
  Rect.Assign(19, 8, 32, 10);
  Insert(new(PButton, Init(Rect, '~M~sg-Box', cmMsg, bfNormal)));

  // Ok-Button
  Rect.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
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
