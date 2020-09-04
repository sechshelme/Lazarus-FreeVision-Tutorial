//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs, Editors,
  sysutils;

//type+
type
  PMyKey = ^TMyKey;
  TMyKey = object(TDialog)
    EditScanCode, EditShiftState,
    EditZeichen, EditZeichenCode: PInputLine;

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyKey.Init;
var
  Rect: TRect;
begin
  Rect.Assign(0, 0, 42, 15);
  Rect.Move(23, 3);
  inherited Init(Rect, 'Keyboard-Aktion');

  // PosX
  Rect.Assign(25, 2, 30, 3);
  EditZeichen := new(PInputLine, Init(Rect, 5));
  Insert(EditZeichen);
  EditZeichen^.State := sfDisabled or EditZeichen^.State;    // ReadOnly
  Rect.Assign(5, 2, 20, 3);
  Insert(New(PLabel, Init(Rect, 'Zeichen:', EditZeichen)));

  // PosY
  Rect.Assign(25, 4, 30, 5);
  EditZeichenCode := new(PInputLine, Init(Rect, 5));
  EditZeichenCode^.State := sfDisabled or EditZeichenCode^.State;    // ReadOnly
  Insert(EditZeichenCode);
  Rect.Assign(5, 4, 20, 5);
  Insert(New(PLabel, Init(Rect, 'Zeichencode:', EditZeichenCode)));

  // Maus-Tasten
  Rect.Assign(25, 7, 30, 8);
  EditScanCode := new(PInputLine, Init(Rect, 7));
  EditScanCode^.State := sfDisabled or EditScanCode^.State;  // ReadOnly
  Insert(EditScanCode);
  Rect.Assign(5, 7, 20, 8);
  Insert(New(PLabel, Init(Rect, 'Scancode:', EditScanCode)));

  // Maus-Tasten
  Rect.Assign(25, 9, 30, 10);
  EditShiftState := new(PInputLine, Init(Rect, 7));
  EditShiftState^.State := sfDisabled or EditShiftState^.State;  // ReadOnly
  Insert(EditShiftState);
  Rect.Assign(5, 9, 20, 10);
  Insert(New(PLabel, Init(Rect, 'Shiftstate:', EditShiftState)));

  // Ok-Button
  Rect.Assign(27, 12, 37, 14);
  Insert(new(PButton, Init(Rect, 'OK', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyKey.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);

  case Event.What of
    evKeyDown: begin                 // Taste wurde gedrückt.
      EditZeichen^.Data^:= Event.CharCode;
      EditZeichen^.Draw;
      EditZeichenCode^.Data^:= IntToStr(Byte(Event.CharCode));
      EditZeichenCode^.Draw;
      EditScanCode^.Data^:= IntToStr(Event.ScanCode);
      EditScanCode^.Draw;
      EditShiftState^.Data^:= IntToStr(Event.KeyShift);
      EditShiftState^.Draw;
    end;
  end;

end;
//handleevent-

end.
