# 14 - TView
## 05 - TView erweitern
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<b>TView</b>, ist die unterste Ebene von allen Fenster, Dialog, Button, etc.<br>
Au diesem Grund habe ich dieses kleine Beispiel von <b>TView</b> gemacht.<br>
---
Beim Fenster erzeugen, ist noch ein Counter hinzugekommen.<br>
Wen man bei den Fenster eine überlappend oder nebeneinader Darstellung will, muss man noch den Status <b>ofTileable</b> setzen.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.NewWindows;
  <b><font color="0000BB">var</font></b>
    Win: PMyView;
    R: TRect;
  <b><font color="0000BB">const</font></b>
    WinCounter: integer = <font color="#0077BB">0</font>;                    <i><font color="#FFFF00">// Zählt Fenster</font></i>
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">60</font>, <font color="#0077BB">20</font>);
    Inc(WinCounter);
    Win := <b><font color="0000BB">New</font></b>(PMyView, Init(R));
    Win^.Options := Win^.Options <b><font color="0000BB">or</font></b> ofTileable; <i><font color="#FFFF00">// Für Tile und Cascade</font></i>
<br>
    <b><font color="0000BB">if</font></b> ValidView(Win) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Win);
    <b><font color="0000BB">end</font></b> <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
      Dec(WinCounter);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
Da es im View keine <b>cmClose</b> Abarbeitung gibt, wird manuell in einer Schleife überprüft, ob es Fenster gibt, wen ja, löschen.<br>
<pre><code=pascal><b><font color="0000BB">procedure</font></b> TMyApp.CloseAll;
<b><font color="0000BB">var</font></b>
  v: PView;
<b><font color="0000BB">begin</font></b>
  v := Desktop^.Current;   <i><font color="#FFFF00">// Gibt es Fenster ?</font></i>
  <b><font color="0000BB">while</font></b> v <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
    Desktop^.Delete(v);    <i><font color="#FFFF00">// Fenster löschen.</font></i>
    v := Desktop^.Current;
  <b><font color="0000BB">end</font></b>;
<b><font color="0000BB">end</font></b>;</code></pre>
<b>cmNewWin</b> muss man selbst abarbeiten. <b>cmClose</b> für das Schliessen des Fenster läuft im Hintergrund automatisch.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmNewWin: <b><font color="0000BB">begin</font></b>
          NewWindows;    <i><font color="#FFFF00">// Fenster erzeugen.</font></i>
        <b><font color="0000BB">end</font></b>;
        cmRefresh: <b><font color="0000BB">begin</font></b>
          ReDraw;        <i><font color="#FFFF00">// Anwendung neu zeichnen.</font></i>
        <b><font color="0000BB">end</font></b>;
        cmCloseAll: <b><font color="0000BB">begin</font></b>
          CloseAll;
        <b><font color="0000BB">end</font></b>;
        cmClose: <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">if</font></b> Desktop^.Current <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b>  Desktop^.Delete(Desktop^.Current);
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
---
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Mit den 3 oberen Button, kann man das Farb-Schema des Dialoges ändern.<br>
<pre><code><b><font color="0000BB">unit</font></b> MyView;
</code></pre>
Hier sind 3 Event-Konstante hinzugekommen.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyView = ^TMyView;
<br>
  <font color="#FFFF00">{ TMyView }</font>
<br>
  TMyView = <b><font color="0000BB">object</font></b>(TView)
    MyCol:Byte;
    <b><font color="0000BB">constructor</font></b> Init(<b><font color="0000BB">var</font></b> Bounds: TRect);
    <b><font color="0000BB">destructor</font></b> Done; <b><font color="0000BB">Virtual</font></b>;
<br>
    <b><font color="0000BB">procedure</font></b> Draw; <b><font color="0000BB">virtual</font></b>;
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">Virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Das Bauen des Dialoges ist nichts besonderes.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyView.Draw;
<b><font color="0000BB">const</font></b>
  Titel = <font color="#FF0000">'MyTView'</font>;
<b><font color="0000BB">var</font></b>
  B: TDrawBuffer;
  y: integer;
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> Draw;
<br>
  EnableCommands([cmClose]);
<br>
  WriteChar(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#FF0000">#201</font>, MyCol, <font color="#0077BB">1</font>);
  WriteChar(<font color="#0077BB">1</font>, <font color="#0077BB">0</font>, <font color="#FF0000">#205</font>, MyCol, <font color="#0077BB">3</font>);
  WriteStr(<font color="#0077BB">5</font>, <font color="#0077BB">0</font>, Titel, <font color="#0077BB">4</font>);
  WriteChar(Length(Titel) + <font color="#0077BB">6</font>, <font color="#0077BB">0</font>, <font color="#FF0000">#205</font>, MyCol, Size.X - Length(Titel) - <font color="#0077BB">7</font>);
  WriteChar(Size.X - <font color="#0077BB">1</font>, <font color="#0077BB">0</font>, <font color="#FF0000">#187</font>, MyCol, <font color="#0077BB">1</font>);
<br>
  <b><font color="0000BB">for</font></b> y := <font color="#0077BB">1</font> <b><font color="0000BB">to</font></b> Size.Y - <font color="#0077BB">2</font> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
    WriteChar(<font color="#0077BB">0</font>, y, <font color="#FF0000">#186</font>, MyCol, <font color="#0077BB">1</font>);
    WriteChar(Size.X - <font color="#0077BB">1</font>, y, <font color="#FF0000">#186</font>, MyCol, <font color="#0077BB">1</font>);
  <b><font color="0000BB">end</font></b>;
<br>
  WriteChar(<font color="#0077BB">0</font>, Size.Y - <font color="#0077BB">1</font>, <font color="#FF0000">#200</font>, MyCol, <font color="#0077BB">1</font>);
  WriteChar(<font color="#0077BB">1</font>, Size.Y - <font color="#0077BB">1</font>, <font color="#FF0000">#205</font>, MyCol, Size.X - <font color="#0077BB">2</font>);
  WriteChar(Size.X - <font color="#0077BB">1</font>, Size.Y - <font color="#0077BB">1</font>, <font color="#FF0000">#188</font>, MyCol, <font color="#0077BB">1</font>);
<b><font color="0000BB">end</font></b>;
</code></pre>
Hier werden die Farb-Schemas mit Hilfe von <b>Palette := dpxxx</b> geändert.<br>
Auch hier ist wichtig, das man <b>Draw</b> aufruft, diemal nicht für eine Komponente, sonder für den ganzen Dialog.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyView.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evMouseDown: <b><font color="0000BB">begin</font></b>    <i><font color="#FFFF00">// Maus-Taste wurde gedrückt.</font></i>
      MyCol:=Random(<font color="#0077BB">16</font>);
      Draw;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
