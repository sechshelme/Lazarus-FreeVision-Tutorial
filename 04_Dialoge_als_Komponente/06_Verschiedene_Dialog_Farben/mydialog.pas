//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs,
  SysUtils; // Für IntToStr und StrToInt.

//type+
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
  const
    cmBlue = 1006;
    cmCyan = 1007;
    cmGray = 1008;
  var
    CounterButton: PButton; // Button mit Zähler.

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyDialog.Init;
var
  Rect: TRect;
begin
  Rect.Assign(0, 0, 42, 11);
  Rect.Move(23, 3);
  inherited Init(Rect, 'Mein Dialog');

  // StaticText
  Rect.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(Rect, 'W' + #132 + 'hle eine Farbe')));

  // Farbe
  Rect.Assign(7, 5, 15, 7);
  Insert(new(PButton, Init(Rect, 'blue', cmBlue, bfNormal)));
  Rect.Assign(17, 5, 25, 7);
  Insert(new(PButton, Init(Rect, 'cyan', cmCyan, bfNormal)));
  Rect.Assign(27, 5, 35, 7);
  Insert(new(PButton, Init(Rect, 'gray', cmGray, bfNormal)));

  // Ok-Button
  Rect.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);    // Vorfahre aufrufen.

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmBlue: begin
          Palette := dpBlueDialog; // Palette zuordnen, hier blau.
          Draw;                    // Dialog neu zeichnen.
          ClearEvent(Event);       // Das Event ist abgeschlossen.
        end;
        cmCyan: begin
          Palette := dpCyanDialog;
          Draw;
          ClearEvent(Event);
        end;
        cmGray: begin
          Palette := dpGrayDialog;
          Draw;
          ClearEvent(Event);
        end;
      end;
    end;
  end;

end;
//handleevent-

end.
