//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs, Validate;

//type+
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;
//type-

implementation

//init+
constructor TMyDialog.Init;
const
  acht = 8;
  vier = 16;
  Mo = 'Montag';
  Fr = 'Freitag';
var
  Rect: TRect;
  Params:record
    s1, s2: PString;
    i1, i2: Int32;
  end;
  s: ShortString;
  p: Pointer;

begin
  Params.s1 := NewStr(Mo);
  Params.s2 := NewStr(Fr);
  Params.i1 := acht;
  Params.i2 := vier;
  p := @Params;

  FormatStr(s, 'Gearbeitet wird zwischen %s und %s'#13+
    'und dies zwischen %d:00 und %d:00 Uhr.', (@Params)^);

  Rect.Assign(0, 0, 52, 11);
  Rect.Move(23, 3);
  inherited Init(Rect, 'String formatieren');

  // ---Statictext;
  Rect.Assign(3, 2, 50, 5);
  Insert(new(PStaticText, Init(Rect, s)));

  // ---Ok-Button
  Rect.Assign(20, 8, 32, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;

//init-

//draw+
//draw-

end.
