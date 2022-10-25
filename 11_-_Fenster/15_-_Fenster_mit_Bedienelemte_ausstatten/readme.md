# 11 - Fenster
## 15 - Fenster mit Bedienelemte ausstatten

<img src="image.png" alt="Selfhtml"><br><br>
Dem Fenster wurden noch Scrollbalken spendiert.

Man könnte noch eine Indikator hinzufügen, welcher Zeilen und Spalten anzeigt.

Und das wichtigste für einen Editor, ein Memo in dem man schreiben kann.



Wen man einen Editor schreiben will, dann nimmt man dazu <b>PEditWindow</b> aus der Unit <b>Editors</b>.

Dies ist viel einfacher, als alles selbst zu bauen.

<hr><br>
Hier wird das neue vererbte Windows erzeugt.


```pascal
  procedure TMyApp.NewWindows;
  var
    Win: PMyWindow;
    R: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PMyWindow, Init(R, 'Fenster', WinCounter));

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;
```

<hr><br>
<b>Unit mit dem neuen Fenster.</b>

<br>


```pascal
unit MyWindow;

```

Ein Horizontaler und ein Vertikaler Scrollbalken einfügen.

Es wird noch gezeigt, wie man die Position des Schiebers festlegen kann.

Mit <b>Min</b> und <b>Max</b> legt man den Bereich fest und mit <b>Value</b> gibt man die Position des Schiebers an.

Ein Indicator wird auch noch eingefügt, welcher die Spalten und Zeilen anzeigt. (Bei einem 64Bit OS ist diese fehlerhaft.)


```pascal
constructor TMyWindow.Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Sw_Integer);
var
  VScrollBar, HScrollBar : PScrollBar;  // Rollbalken
  Indicator  : PIndicator;              // Zeilen/Spalten-Anzeige
  R: TRect;
begin
  inherited Init(Bounds, ATitle, ANumber);
  Options := Options or ofTileable;     // Für Tile und Cascade

  R.Assign (18, Size.Y - 1, Size.X - 2, Size.Y);
  HScrollBar := New (PScrollBar, Init (R));
  HScrollBar^.Max := 100;
  HScrollBar^.Min := 0;
  HScrollBar^.Value := 50;
  Insert (HScrollBar);

  R.Assign (Size.X - 1, 1, Size.X, Size.Y - 1);
  VScrollBar := New (PScrollBar, Init (R));
  VScrollBar^.Max := 100;
  VScrollBar^.Min := 0;
  VScrollBar^.Value := 20;
  Insert (VScrollBar);

  R.Assign (2, Size.Y - 1, 16, Size.Y);
  Indicator := New (PIndicator, Init (R));
  Insert (Indicator);
end;

```


