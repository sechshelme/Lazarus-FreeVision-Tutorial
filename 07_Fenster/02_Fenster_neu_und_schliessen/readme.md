<html>
    <b><h1>07 Fenster</h1></b>
    <b><h2>02 Fenster neu und schliessen</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Über das Menü Fenster erzeigen und schliessen.<br>
<hr><br>
Neue Konstanten für Kommados.<br>
Auch ist der HandleEvent dazugekommen.<br>
<pre><code><b><font color="0000BB">const</font></b>
  cmNewWin = <font color="#0077BB">1001</font>;
<b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    <b><font color="0000BB">constructor</font></b> Init;
<br>
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;
<br>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// Abarbeitung Kommandos</font></i>
    <b><font color="0000BB">procedure</font></b> OutOfMemory; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Wird aufgerufen, wen Speicher überläuft.</font></i>
<br>
    <b><font color="0000BB">procedure</font></b> NewWindows;
  <b><font color="0000BB">end</font></b>;</code></pre>
Das Menü wurde um <b>Neu</b> und <b>Schliessen</b> ergänzt.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    Rect: TRect;
  <b><font color="0000BB">begin</font></b>
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + <font color="#0077BB">1</font>;
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(
      NewItem(<font color="#FF0000">'~N~eu'</font>, <font color="#FF0000">'F4'</font>, kbF4, cmNewWin, hcNoContext,
      NewItem(<font color="#FF0000">'S~c~hliessen'</font>, <font color="#FF0000">'Alt-F3'</font>, kbAltF3, cmClose, hcNoContext,
      NewLine(
      NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>))))), <b><font color="0000BB">nil</font></b>))));
  <b><font color="0000BB">end</font></b>;</code></pre>
Beim Fenster erzeugen, ist noch ein Counter hinzugekommen.<br>
Dieser wird benutzt um die Fenster zu nummerieren.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.NewWindows;
  <b><font color="0000BB">var</font></b>
    Win: PWindow;
    Rect: TRect;
  <b><font color="0000BB">const</font></b>
    WinCounter: integer = <font color="#0077BB">0</font>;      <i><font color="#FFFF00">// Zählt Fenster</font></i>
  <b><font color="0000BB">begin</font></b>
    Rect.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">60</font>, <font color="#0077BB">20</font>);
    Inc(WinCounter);
    Win := <b><font color="0000BB">New</font></b>(PWindow, Init(Rect, <font color="#FF0000">'Fenster'</font>, WinCounter));
    <i><font color="#FFFF00">// Wen zu wenig Speicher für Fenster, dann Counter wieder -1.</font></i>
    <b><font color="0000BB">if</font></b> ValidView(Win) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Win);
    <b><font color="0000BB">end</font></b> <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
      Dec(WinCounter);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<b>cmNewWin</b> muss man selbst abarbeiten. <b>cmClose</b> für das Schliessen des Fenster läuft es im Hintergrund automatisch.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmNewWin: <b><font color="0000BB">begin</font></b>
          NewWindows;    <i><font color="#FFFF00">// Fenster erzeugen.</font></i>
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
