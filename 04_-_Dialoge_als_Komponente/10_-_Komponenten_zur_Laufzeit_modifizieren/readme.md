# 04 - Dialoge als Komponente
## 10 - Komponenten zur Laufzeit modifizieren

<img src="image.png" alt="Selfhtml"><br><br>


---




```pascal
unit MyDialog;

```




```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    CounterButton: PButton; // Button mit Zähler.
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```




```pascal
const
  cmCounter = 1003;       // Wird lokal für den Zähler-Button gebraucht.

constructor TMyDialog.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);
  inherited Init(R, 'Mein Dialog');

  // StaticText
  R.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(R, 'Rechter Button z' + #132 + 'hlt Counter hoch')));

  // Button, bei den der Titel geändert wird.
  R.Assign(19, 8, 32, 10);
  CounterButton := new(PButton, Init(R, '    ', cmCounter, bfNormal));
  CounterButton^.Title^ := '1';

  Insert(CounterButton);

  // Ok-Button
  R.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```





```pascal
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
          if Counter &gt; 9999 then begin                // Auf Überlauf prüfen, weil nur 4 Zeichen zur Verfügung.
            Counter := 9999;
          end;
          CounterButton^.Title^ := IntToStr(Counter); // Neuer Titel an Button übergeben.

          CounterButton^.Draw;                        // Button neu zeichnen.
          ClearEvent(Event);                          // Event beenden.
        end;
      end;
    end;
  end;

end;

```


