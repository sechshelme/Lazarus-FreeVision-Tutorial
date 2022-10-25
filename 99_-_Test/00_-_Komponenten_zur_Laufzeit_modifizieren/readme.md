# 99 - Test
## 00 - Komponenten zur Laufzeit modifizieren
<br>
In den vererbten Dialogen ist es möglich Buttons einubauen, welche lokal im Dialog eine Aktion ausführen.<br>
Im Beispiel wir eine MessageBox aufgerufen.<br>
<hr><br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Dort wird gezeigt, wie man Werte bei Komponenten zu Laufzeit lesen und schreiben kann.<br>
Als Beispiel, wird die Zahl im Button bei jedem drücken um 1 erhöht.<br>
```pascal
unit MyDialog;
<br>
```
Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.<br>
Direkt mit <b>Insert(New(...</b> geht nicht mehr.<br>
```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
  const
    cmCounter = 1003;       // Wird lokal für den Zähler-Butoon gebraucht.
  var
    CounterButton: PButton; // Button mit Zähler.
<br>
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
<br>
```
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.<br>
<b>CounterButton</b> wird für die Modifikation gebraucht.<br>
```pascal
constructor TMyDialog.Init;
var
  Rect: TRect;
begin
  Rect.Assign(0, 0, 42, 11);
  Rect.Move(23, 3);
  inherited Init(Rect, 'Mein Dialog');
<br>
  // StaticText
  Rect.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(Rect, 'Rechter Button z' + #132 + 'hlt Counter hoch')));
<br>
  // Button, bei den der Titel geändert wird.
  Rect.Assign(19, 8, 32, 10);
  CounterButton := new(PButton, Init(Rect, '0', cmCounter, bfNormal));
  Insert(CounterButton);
<br>
  // Ok-Button
  Rect.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;
<br>
```
Im EventHandle, wird die Zahl im Button beim Drücken erhöht.<br>
Das sieht man, warum man den <b>CounterButton</b> braucht, ohne dem hätte man keinen Zugriff auf <b>Titel</b>.<br>
Wichtig, wen man eine Komponente ändert, muss man mit <b>Draw</b> die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.<br>
```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  Counter: integer;
begin
  inherited HandleEvent(Event);
<br>
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmCounter: begin
          Counter := StrToInt(CounterButton^.Title^); // Titel des Button auslesen.
          Inc(Counter);                               // Counter erhöhen.
          CounterButton^.Title^ := IntToStr(Counter); // Neuer Titel an Button übergeben.
<br>
          CounterButton^.Draw;                        // Button neu zeichnen.
          ClearEvent(Event);                          // Event beenden.
        end;
        cmOK:Close;
      end;
    end;
  end;
<br>
end;
<br>
```
<br>
