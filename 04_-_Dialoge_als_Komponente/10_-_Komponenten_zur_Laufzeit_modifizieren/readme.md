# 04 - Dialoge als Komponente
## 10 - Komponenten zur Laufzeit modifizieren

![image.png](image.png)

In diesem Beispiel wird gezeigt, wie man Komponenten zu Laufzeit ändern kann.
Dafür wird ein Button verwendet, bei dem sich die Bezeichnung bei jedem Klick erhöht.

---
**Unit mit dem neuen Dialog.**
<br>
Der Dialog mit dem Zähler-Button.

```pascal
unit MyDialog;

```

Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.
Direkt mit **Insert(New(...** geht nicht mehr.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    CounterButton: PButton; // Button mit Zähler.
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

Im Konstruktor sieht man, das man den Umweg über der **CounterButton** macht.
**CounterButton** wird für die Modifikation gebraucht.

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

Im EventHandle, wird die Zahl im Button beim Drücken erhöht.
Das sieht man, warum man den **CounterButton** braucht, ohne dem hätte man keinen Zugriff auf **Titel**.
Wichtig, wen man eine Komponente ändert, muss man mit **Draw** die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.

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
          if Counter > 9999 then begin                // Auf Überlauf prüfen, weil nur 4 Zeichen zur Verfügung.
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


