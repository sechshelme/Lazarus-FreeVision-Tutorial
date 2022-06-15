<html>
    <b><h1>04 - Dialoge als Komponente</h1></b>
    <b><h2>10 - Komponenten zur Laufzeit modifizieren</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird gezeigt, wie man Komponenten zu Laufzeit ändern kann.<br>
Dafür wird ein Button verwendet, bei dem sich die Bezeichnung bei jedem Klick erhöht.<br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit dem Zähler-Button.<br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.<br>
Direkt mit <b>Insert(New(...</b> geht nicht mehr.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyDialog = ^TMyDialog;
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
    CounterButton: PButton; <i><font color="#FFFF00">// Button mit Zähler.</font></i>
    <b><font color="0000BB">constructor</font></b> Init;
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.<br>
<b>CounterButton</b> wird für die Modifikation gebraucht.<br>
<pre><code><b><font color="0000BB">const</font></b>
  cmCounter = <font color="#0077BB">1003</font>;       <i><font color="#FFFF00">// Wird lokal für den Zähler-Button gebraucht.</font></i>
<br>
<b><font color="0000BB">constructor</font></b> TMyDialog.Init;
<b><font color="0000BB">var</font></b>
  R: TRect;
<b><font color="0000BB">begin</font></b>
  R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">42</font>, <font color="#0077BB">11</font>);
  R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'Mein Dialog'</font>);
<br>
  <i><font color="#FFFF00">// StaticText</font></i>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">2</font>, <font color="#0077BB">41</font>, <font color="#0077BB">8</font>);
  Insert(<b><font color="0000BB">new</font></b>(PStaticText, Init(R, <font color="#FF0000">'Rechter Button z'</font> + <font color="#FF0000">#132</font> + <font color="#FF0000">'hlt Counter hoch'</font>)));
<br>
  <i><font color="#FFFF00">// Button, bei den der Titel geändert wird.</font></i>
  R.Assign(<font color="#0077BB">19</font>, <font color="#0077BB">8</font>, <font color="#0077BB">32</font>, <font color="#0077BB">10</font>);
  CounterButton := <b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'    '</font>, cmCounter, bfNormal));
  CounterButton^.Title^ := <font color="#FF0000">'1'</font>;
<br>
  Insert(CounterButton);
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  R.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">8</font>, <font color="#0077BB">17</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
</code></pre>
Im EventHandle, wird die Zahl im Button beim Drücken erhöht.<br>
Das sieht man, warum man den <b>CounterButton</b> braucht, ohne dem hätte man keinen Zugriff auf <b>Titel</b>.<br>
Wichtig, wen man eine Komponente ändert, muss man mit <b>Draw</b> die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyDialog.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">var</font></b>
  Counter: integer;
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evCommand: <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmCounter: <b><font color="0000BB">begin</font></b>
          Counter := StrToInt(CounterButton^.Title^); <i><font color="#FFFF00">// Titel des Button auslesen.</font></i>
          Inc(Counter);                               <i><font color="#FFFF00">// Counter erhöhen.</font></i>
          <b><font color="0000BB">if</font></b> Counter &gt; <font color="#0077BB">9999</font> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>                <i><font color="#FFFF00">// Auf Überlauf prüfen, weil nur 4 Zeichen zur Verfügung.</font></i>
            Counter := <font color="#0077BB">9999</font>;
          <b><font color="0000BB">end</font></b>;
          CounterButton^.Title^ := IntToStr(Counter); <i><font color="#FFFF00">// Neuer Titel an Button übergeben.</font></i>
<br>
          CounterButton^.Draw;                        <i><font color="#FFFF00">// Button neu zeichnen.</font></i>
          ClearEvent(Event);                          <i><font color="#FFFF00">// Event beenden.</font></i>
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;
<br>
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
</html>
