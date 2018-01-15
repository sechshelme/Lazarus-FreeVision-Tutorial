//head+
unit MyDialog;
//head-

//interface+
interface

uses
  App, Objects, Drivers, Views, Dialogs;

type
  PMyAbout = ^TMyAbout;
  TMyAbout = object(TDialog)
    constructor Init;  // Neuer Konstruktor, welche den Dialog mit den Komponenten baut.
  end;
//interface-

//implementation+
implementation

constructor TMyAbout.Init;
var
  Rect: TRect;
begin
  Rect.Assign(0, 0, 42, 11);
  Rect.Move(23, 3);

  inherited Init(Rect, 'About');  // Dialog in verdefinierter Grösse erzeugen.

  // StaticText
  Rect.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(Rect,
    'Free Vison Tutorial 1.0' + #13 +
    '2017' + #13 +
    'Gechrieben von M. Burkhard' + #13#32#13 +
    'FPC: '+ {$I %FPCVERSION%} + '   OS:'+ {$I %FPCTARGETOS%} + '   CPU:' + {$I %FPCTARGETCPU%})));

  // Ok-Button
  Rect.Assign(27, 8, 37, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;
//implementation-

end.
