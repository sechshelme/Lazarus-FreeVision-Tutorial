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
    cmCounter = 1003;       // Wird lokal für den Zähler-Butoon gebraucht.
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
  Insert(new(PStaticText, Init(Rect, 'Rechter Button z' + #132 + 'hlt Counter hoch')));

  // Button, bei den der Titel geändert wird.
  Rect.Assign(19, 8, 32, 10);
  CounterButton := new(PButton, Init(Rect, '0', cmCounter, bfNormal));
  Insert(CounterButton);

  // Ok-Button
  Rect.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  Counter: integer;
begin
  inherited HandleEvent(Event);

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmCounter: begin
          Counter := StrToInt(CounterButton^.Title^); // Titel des Button auslesen.
          Inc(Counter);                               // Counter erhöhen.
          CounterButton^.Title^ := IntToStr(Counter); // Neuer Titel an Button übergeben.

          CounterButton^.Draw;                        // Button neu zeichnen.
          ClearEvent(Event);                          // Event beenden.
        end;
        cmOK:Close;
      end;
    end;
  end;

end;
//handleevent-

end.
