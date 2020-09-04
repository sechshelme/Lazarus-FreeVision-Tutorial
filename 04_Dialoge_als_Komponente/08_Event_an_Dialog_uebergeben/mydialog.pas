//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs,
  SysUtils; // Für IntToStr und StrToInt.

const
  cmCounterUp = 1010;

//type+
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
  var
    CounterInputLine: PInputLine; // Ausgabe Zeile für den Counter.

    constructor Init(var Bounds: TRect; ATitle: TTitleStr);
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyDialog.Init(var Bounds: TRect; ATitle: TTitleStr);
var
  Rect: TRect;
begin
  inherited Init(Bounds, ATitle);

  Rect.Assign(5, 2, 10, 3);
  CounterInputLine := new(PInputLine, Init(Rect, 20));
  CounterInputLine^.Data^ := '0';
  Insert(CounterInputLine);
end;
//init-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  Counter: integer;
begin
  inherited HandleEvent(Event);

  case Event.What of
    evBroadcast: begin
      case Event.Command of
        cmCounterUp: begin                              // cmCounterUp wurde mit Message gesendet.
          Counter := StrToInt(CounterInputLine^.Data^); // Ausgabezeile auslesen.
          Inc(Counter);                                 // Counter erhöhen.
          CounterInputLine^.Data^ := IntToStr(Counter); // Neue Zahl ausgeben.
          CounterInputLine^.Draw;                       // Asugabezeile aktualisieren.
//          ClearEvent(Event);                            // Event beenden.
        end;
      end;
    end;
  end;

end;
//handleevent-

end.
