//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs;

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
  R: TRect;
  Params:record
    s1, s2: PString;
    i1, i2: PtrInt;
  end;
  s: ShortString;
//init-

//draw+
begin
  Params.s1 := NewStr(Mo);
  Params.s2 := NewStr(Fr);
  Params.i1 := acht;
  Params.i2 := vier;

  FormatStr(s, 'Gearbeitet wird zwischen %s und %s'#13+
    'und dies zwischen %d:00 und %d:00 Uhr.', (@Params)^);

  R.Assign(0, 0, 52, 13);
  R.Move(23, 3);
  inherited Init(R, 'String formatieren');

  // ---Statictext;
  R.Assign(3, 2, 50, 5);
  Insert(new(PStaticText, Init(R, s)));

  // ---Ok-Button
  R.Assign(20, 8, 32, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
//draw-



end.
