# 02 - Statuszeile und Menu
## 00 - Status Zeile
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Ändern der Status-Zeile.<br>
Die Statuszeile wird gebraucht um wichtige Information und HotKey anzuzeigen.<br>
<hr><br>
Für die Statuszeile werden noch verschiedene Units gebraucht.<br>
<pre><code=pascal><b><font color="0000BB">uses</font></b>
  App,      <i><font color="#FFFF00">// TApplication</font></i>
  Objects,  <i><font color="#FFFF00">// Fensterbereich (TRect)</font></i>
  Drivers,  <i><font color="#FFFF00">// Hotkey</font></i>
  Views,    <i><font color="#FFFF00">// Ereigniss (cmQuit)</font></i>
  Menus;    <i><font color="#FFFF00">// Statuszeile</font></i></code></pre>
Wen man etwas ändern will, muss man TApplication vererben.<br>
Hier im Beispiel, wird die Statuszeile abgeändert, dazu muss man die Procedure <b>InitStatusLine</b> überschreiben.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.InitStatusLine;
  <b><font color="0000BB">var</font></b>
    R: TRect;           <i><font color="#FFFF00">// Rechteck für die Statuszeilen Position.</font></i>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);       <i><font color="#FFFF00">// Liefert die Grösse/Position der App, im Normalfall 0, 0, 80, 24.</font></i>
    R.A.Y := R.B.Y - <font color="#0077BB">1</font>; <i><font color="#FFFF00">// Position der Statuszeile, auf unterste Zeile der App setzen.</font></i>
<br>
    StatusLine := <b><font color="0000BB">New</font></b>(PStatusLine, Init(R, NewStatusDef(<font color="#0077BB">0</font>, <font color="#0077BB">$</font>FFFF, NewStatusKey(<font color="#FF0000">'~Alt+X~ Programm beenden'</font>, kbAltX, cmQuit, <b><font color="0000BB">nil</font></b>), <b><font color="0000BB">nil</font></b>)));
  <b><font color="0000BB">end</font></b>;</code></pre>
Das die neue Statuszeile verwendet wird muss man den Nachkomme anstelle von <b>TApplication</b> deklarieren.<br>
<pre><code=pascal><b><font color="0000BB">var</font></b>
  MyApp: TMyApp;</code></pre>
Die  bleibt gleich.<br>
<pre><code=pascal><b><font color="0000BB">begin</font></b>
  MyApp.Init;   <i><font color="#FFFF00">// Inizialisieren</font></i>
  MyApp.Run;    <i><font color="#FFFF00">// Abarbeiten</font></i>
  MyApp.Done;   <i><font color="#FFFF00">// Freigeben</font></i>
<b><font color="0000BB">end</font></b>.</code></pre>
<br>
