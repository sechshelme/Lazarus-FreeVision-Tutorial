<html>
    <b><h1>07 Fenster</h1></b>
    <b><h2>04 Fenster verwalten</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Fenster verwalten. Nun ist es möglich über das Menü Steuerkomandos für die Fensterverwaltung zu geben.<br>
ZB. Zoom, verkleinern, Fensterwechsel, Kaskade, etc.<br>
<hr><br>
Das Menü wurde um die Steuerbefehle für die Fensterverwatung ergänzt.<br>
Die ausgeklammerten Kommandos müssen manuel gemacht werden.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, NewMenu(
      NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~N~eu'</font>, <font color="#FF0000">'F4'</font>, kbF4, cmNewWin, hcNoContext,
        NewLine(
        NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>)))),
      NewSubMenu(<font color="#FF0000">'~F~enster'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~N~ebeneinander'</font>, <font color="#FF0000">''</font>, kbNoKey, cmTile, hcNoContext,
        NewItem(<font color="#FF0000">#154</font><font color="#FF0000">'ber~l~append'</font>, <font color="#FF0000">''</font>, kbNoKey, cmCascade, hcNoContext,
        NewItem(<font color="#FF0000">'~A~lle schliessen'</font>, <font color="#FF0000">''</font>, kbNoKey, cmCloseAll, hcNoContext,
        NewItem(<font color="#FF0000">'Anzeige ~e~rneuern'</font>, <font color="#FF0000">''</font>, kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem(<font color="#FF0000">'Gr'</font><font color="#FF0000">#148</font><font color="#FF0000">'sse/~P~osition'</font>, <font color="#FF0000">'Ctrl+F5'</font>, kbCtrlF5, cmResize, hcNoContext,
        NewItem(<font color="#FF0000">'Ver~g~'</font><font color="#FF0000">#148</font><font color="#FF0000">'ssern'</font>, <font color="#FF0000">'F5'</font>, kbF5, cmZoom, hcNoContext,
        NewItem(<font color="#FF0000">'~N~'</font><font color="#FF0000">#132</font><font color="#FF0000">'chstes'</font>, <font color="#FF0000">'F6'</font>, kbF6, cmNext, hcNoContext,
        NewItem(<font color="#FF0000">'~V~orheriges'</font>, <font color="#FF0000">'Shift+F6'</font>, kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem(<font color="#FF0000">'~S~chliessen'</font>, <font color="#FF0000">'Alt+F3'</font>, kbAltF3, cmClose, hcNoContext, <b><font color="0000BB">Nil</font></b>)))))))))))), <b><font color="0000BB">nil</font></b>)))));
<br>
  <b><font color="0000BB">end</font></b>;</code></pre>
Beim Fenster erzeugen, ist noch ein Counter hinzugekommen.<br>
Wen man bei den Fenster eine überlappend oder nebeneinader Darstellung will, muss man noch den Status <b>ofTileable</b> setzen.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.NewWindows;
  <b><font color="0000BB">var</font></b>
    Win: PWindow;
    R: TRect;
  <b><font color="0000BB">const</font></b>
    WinCounter: integer = <font color="#0077BB">0</font>;                    <i><font color="#FFFF00">// Zählt Fenster</font></i>
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">60</font>, <font color="#0077BB">20</font>);
    Inc(WinCounter);
    Win := <b><font color="0000BB">New</font></b>(PWindow, Init(R, <font color="#FF0000">'Fenster'</font>, WinCounter));
    Win^.Options := Win^.Options <b><font color="0000BB">or</font></b> ofTileable; <i><font color="#FFFF00">// Für Tile und Cascade</font></i>
<br>
    <b><font color="0000BB">if</font></b> ValidView(Win) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Win);
    <b><font color="0000BB">end</font></b> <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
      Dec(WinCounter);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
Diese Procedure schliesst alle Fenster im Desktop.<br>
Dazu wird jedem Fenster mit <b>ForEach</b> ein <b>cmClose</b>-Event gesendet.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.CloseAll;
<br>
    <b><font color="0000BB">procedure</font></b> SendClose(P: PView);
    <b><font color="0000BB">begin</font></b>
      Message(P, evCommand, cmClose, <b><font color="0000BB">nil</font></b>);
    <b><font color="0000BB">end</font></b>;
<br>
  <b><font color="0000BB">begin</font></b>
    Desktop^.ForEach(@SendClose);
  <b><font color="0000BB">end</font></b>;</code></pre>
<b>cmNewWin</b> muss man selbst abarbeiten. <b>cmClose</b> für das Schliessen des Fenster läuft im Hintergrund automatisch.<br>
<pre><code>
  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmNewWin: <b><font color="0000BB">begin</font></b>
          NewWindows;    <i><font color="#FFFF00">// Fenster erzeugen.</font></i>
        <b><font color="0000BB">end</font></b>;
        cmCloseAll:<b><font color="0000BB">begin</font></b>
          CloseAll;      <i><font color="#FFFF00">// Schliesst alle Fenster.</font></i>
        <b><font color="0000BB">end</font></b>;
        cmRefresh: <b><font color="0000BB">begin</font></b>
          ReDraw;        <i><font color="#FFFF00">// Anwendung neu zeichnen.</font></i>
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
