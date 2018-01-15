//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs, Editors,
  sysutils;

//type+
type
  PMyMouse = ^TMyMouse;
  TMyMouse = object(TDialog)
    EditMB,
    EditX, EditY: PInputLine;

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyMouse.Init;
var
  Rect: TRect;
begin
  Rect.Assign(0, 0, 42, 13);
  Rect.Move(23, 3);
  inherited Init(Rect, 'Mausaktion');

  // PosX
  Rect.Assign(25, 2, 30, 3);
  EditX := new(PInputLine, Init(Rect, 5));
  Insert(EditX);
  EditX^.State := sfDisabled or EditX^.State;    // ReadOnly
  Rect.Assign(5, 2, 20, 3);
  Insert(New(PLabel, Init(Rect, 'MausPosition ~X~:', EditX)));

  // PosY
  Rect.Assign(25, 4, 30, 5);
  EditY := new(PInputLine, Init(Rect, 5));
  EditY^.State := sfDisabled or EditY^.State;    // ReadOnly
  Insert(EditY);
  Rect.Assign(5, 4, 20, 5);
  Insert(New(PLabel, Init(Rect, 'MausPosition ~Y~:', EditY)));

  // Maus-Tasten
  Rect.Assign(25, 7, 32, 8);
  EditMB := new(PInputLine, Init(Rect, 7));
  EditMB^.State := sfDisabled or EditMB^.State;  // ReadOnly
  EditMB^.Data^:= 'oben';                        // Anfangs ist die Taste oben.
  Insert(EditMB);
  Rect.Assign(5, 7, 20, 8);
  Insert(New(PLabel, Init(Rect, '~M~austaste:', EditMB)));

  // Ok-Button
  Rect.Assign(27, 10, 37, 12);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyMouse.HandleEvent(var Event: TEvent);
var
  Mouse : TPoint;
begin
  inherited HandleEvent(Event);

  case Event.What of
    evMouseDown: begin                 // Taste wurde gedrückt.
      EditMB^.Data^:= 'unten';
      EditMB^.Draw;
    end;
    evMouseUp: begin                   // Taste wurde losgelassen.
      EditMB^.Data^:= 'oben';
      EditMB^.Draw;
    end;
    evMouseMove: begin                 // Maus wurde bewegt.
      MakeLocal (Event.Where, Mouse);  // Mausposition ermitteln.
      EditX^.Data^:= IntToStr(Mouse.X);
      EditX^.Draw;
      EditY^.Data^:= IntToStr(Mouse.Y);
      EditY^.Draw;
    end;
  end;

end;
//handleevent-

end.
