# 99 - Test
## 00 - Komponenten zur Laufzeit modifizieren

![image.png](image.png)

In den vererbten Dialogen ist es möglich Buttons einubauen, welche lokal im Dialog eine Aktion ausführen.
Im Beispiel wir eine MessageBox aufgerufen.

---

---
**Unit mit dem neuen Dialog.**
<br>
Dort wird gezeigt, wie man Werte bei Komponenten zu Laufzeit lesen und schreiben kann.
Als Beispiel, wird die Zahl im Button bei jedem drücken um 1 erhöht.

```pascal
unit MyDialog;

```

Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.
Direkt mit **Insert(New(...** geht nicht mehr.

```pascal
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

```

Im Konstruktor sieht man, das man den Umweg über der **CounterButton** macht.
**CounterButton** wird für die Modifikation gebraucht.

```pascal
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
          CounterButton^.Title^ := IntToStr(Counter); // Neuer Titel an Button übergeben.

          CounterButton^.Draw;                        // Button neu zeichnen.
          ClearEvent(Event);                          // Event beenden.
        end;
        cmOK:Close;
      end;
    end;
  end;

end;

```


