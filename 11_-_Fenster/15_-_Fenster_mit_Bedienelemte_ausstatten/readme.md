# 11 - Fenster
## 15 - Fenster mit Bedienelemte ausstatten
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Dem Fenster wurden noch Scrollbalken spendiert.<br>
Man könnte noch eine Indikator hinzufügen, welcher Zeilen und Spalten anzeigt.<br>
Und das wichtigste für einen Editor, ein Memo in dem man schreiben kann.<br>
<br>
Wen man einen Editor schreiben will, dann nimmt man dazu <b>PEditWindow</b> aus der Unit <b>Editors</b>.<br>
Dies ist viel einfacher, als alles selbst zu bauen.<br>
<hr><br>
Hier wird das neue vererbte Windows erzeugt.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.NewWindows;
  <b><font color="0000BB">var</font></b>
    Win: PMyWindow;
    R: TRect;
  <b><font color="0000BB">const</font></b>
    WinCounter: integer = <font color="#0077BB">0</font>;      <i><font color="#FFFF00">// Zählt Fenster</font></i>
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">60</font>, <font color="#0077BB">20</font>);
    Inc(WinCounter);
    Win := <b><font color="0000BB">New</font></b>(PMyWindow, Init(R, <font color="#FF0000">'Fenster'</font>, WinCounter));
<br>
    <b><font color="0000BB">if</font></b> ValidView(Win) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Win);
    <b><font color="0000BB">end</font></b> <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
      Dec(WinCounter);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<hr><br>
<b>Unit mit dem neuen Fenster.</b><br>
<br><br>
<pre><code><b><font color="0000BB">unit</font></b> MyWindow;
</code></pre>
Ein Horizontaler und ein Vertikaler Scrollbalken einfügen.<br>
Es wird noch gezeigt, wie man die Position des Schiebers festlegen kann.<br>
Mit <b>Min</b> und <b>Max</b> legt man den Bereich fest und mit <b>Value</b> gibt man die Position des Schiebers an.<br>
Ein Indicator wird auch noch eingefügt, welcher die Spalten und Zeilen anzeigt. (Bei einem 64Bit OS ist diese fehlerhaft.)<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyWindow.Init(<b><font color="0000BB">var</font></b> Bounds: TRect; ATitle: TTitleStr; ANumber: Sw_Integer);
<b><font color="0000BB">var</font></b>
  VScrollBar, HScrollBar : PScrollBar;  <i><font color="#FFFF00">// Rollbalken</font></i>
  Indicator  : PIndicator;              <i><font color="#FFFF00">// Zeilen/Spalten-Anzeige</font></i>
  R: TRect;
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> Init(Bounds, ATitle, ANumber);
  Options := Options <b><font color="0000BB">or</font></b> ofTileable;     <i><font color="#FFFF00">// Für Tile und Cascade</font></i>
<br>
  R.Assign (<font color="#0077BB">18</font>, Size.Y - <font color="#0077BB">1</font>, Size.X - <font color="#0077BB">2</font>, Size.Y);
  HScrollBar := <b><font color="0000BB">New</font></b> (PScrollBar, Init (R));
  HScrollBar^.Max := <font color="#0077BB">100</font>;
  HScrollBar^.Min := <font color="#0077BB">0</font>;
  HScrollBar^.Value := <font color="#0077BB">50</font>;
  Insert (HScrollBar);
<br>
  R.Assign (Size.X - <font color="#0077BB">1</font>, <font color="#0077BB">1</font>, Size.X, Size.Y - <font color="#0077BB">1</font>);
  VScrollBar := <b><font color="0000BB">New</font></b> (PScrollBar, Init (R));
  VScrollBar^.Max := <font color="#0077BB">100</font>;
  VScrollBar^.Min := <font color="#0077BB">0</font>;
  VScrollBar^.Value := <font color="#0077BB">20</font>;
  Insert (VScrollBar);
<br>
  R.Assign (<font color="#0077BB">2</font>, Size.Y - <font color="#0077BB">1</font>, <font color="#0077BB">16</font>, Size.Y);
  Indicator := <b><font color="0000BB">New</font></b> (PIndicator, Init (R));
  Insert (Indicator);
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
