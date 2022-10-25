# 04 - Dialoge als Komponente
## 10 - Komponenten zur Laufzeit modifizieren
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird gezeigt, wie man Komponenten zu Laufzeit ändern kann.<br>
Dafür wird ein Button verwendet, bei dem sich die Bezeichnung bei jedem Klick erhöht.<br>
---
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit dem Zähler-Button.<br>
<pre><code>unit MyDialog;
</code></pre>
Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.<br>
Direkt mit <b>Insert(New(...</b> geht nicht mehr.<br>
<pre><code>type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    CounterButton: PButton; // Button mit Zähler.
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
</code></pre>
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.<br>
<b>CounterButton</b> wird für die Modifikation gebraucht.<br>
<pre><code>const
  cmCounter = 1003;       // Wird lokal für den Zähler-Button gebraucht.</font>
<br>
constructor TMyDialog.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);</font>
  R.Move(23, 3);</font>
  inherited Init(R, 'Mein Dialog');</font>
<br>
  // StaticText
  R.Assign(5, 2, 41, 8);</font>
  Insert(new(PStaticText, Init(R, 'Rechter Button z' + #132 + 'hlt Counter hoch')));</font>
<br>
  // Button, bei den der Titel geändert wird.
  R.Assign(19, 8, 32, 10);</font>
  CounterButton := new(PButton, Init(R, '    ', cmCounter, bfNormal));</font>
  CounterButton^.Title^ := '1';</font>
<br>
  Insert(CounterButton);
<br>
  // Ok-Button
  R.Assign(7, 8, 17, 10);</font>
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
end;
</code></pre>
Im EventHandle, wird die Zahl im Button beim Drücken erhöht.<br>
Das sieht man, warum man den <b>CounterButton</b> braucht, ohne dem hätte man keinen Zugriff auf <b>Titel</b>.<br>
Wichtig, wen man eine Komponente ändert, muss man mit <b>Draw</b> die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.<br>
<pre><code>procedure TMyDialog.HandleEvent(var Event: TEvent);
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
          if Counter &gt; 9999 then begin                // Auf Überlauf prüfen, weil nur 4 Zeichen zur Verfügung.
            Counter := 9999;</font>
          end;
          CounterButton^.Title^ := IntToStr(Counter); // Neuer Titel an Button übergeben.
<br>
          CounterButton^.Draw;                        // Button neu zeichnen.
          ClearEvent(Event);                          // Event beenden.
        end;
      end;
    end;
  end;
<br>
end;
</code></pre>
<br>
