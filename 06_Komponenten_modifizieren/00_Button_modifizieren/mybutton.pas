//head+
unit MyButton;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs,
  SysUtils;

//type+
type
  PMyButton = ^TMyButton;
  TMyButton = object(TButton)
    constructor Init(x, y: integer; ATitle: TTitleStr; ACommand: word; AFlags: word);
  end;
//type-

implementation

{ TMyButton }

//init+
constructor TMyButton.Init(x, y: integer; ATitle: TTitleStr; ACommand: word; AFlags: word);
var
  Rect: TRect;
begin
  Rect.Assign(x, y, x + Length(StringReplace(ATitle, '~', '', [])) + 2, y + 2);

  inherited Init(Rect, ATitle, ACommand, AFlags);
end;
//init-

end.
