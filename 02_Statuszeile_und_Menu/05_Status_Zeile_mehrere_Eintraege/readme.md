<html>
    <b><h1>02 Statuszeile und Menu</h1></b>
    <b><h2>02 Status Zeile mehrere Eintraege</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Ändern der Status-Zeile, mit mehreren Optionen.<br>
<hr><br>
In der Statuszeile sind auch mehrere Hot-Key möglich.<br>
Die Deklaration könnte man verschachtelt in einer Zeile schreiben.<br>
Im Beispiel wird es gesplittet gemacht.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitStatusLine;
  <b><font color="0000BB">var</font></b>
    R: TRect;                 <i><font color="#FFFF00">// Rechteck für die Statuszeilen Position.</font></i>
<br>
    P0: PStatusDef;           <i><font color="#FFFF00">// Pointer ganzer Eintrag.</font></i>
    P1, P2, P3: PStatusItem;  <i><font color="#FFFF00">// Pointer auf die einzelnen Hot-Key.</font></i>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);             <i><font color="#FFFF00">// Liefert die Grösse/Position der App, im Normalfall 0, 0, 80, 24.</font></i>
    R.A.Y := R.B.Y - <font color="#0077BB">1</font>;       <i><font color="#FFFF00">// Position der Statuszeile, auf unterste Zeile der App setzen.</font></i>
<br>
    P3 := NewStatusKey(<font color="#FF0000">'~F1~ Hilfe'</font>, kbF1, cmHelp, <b><font color="0000BB">nil</font></b>);
    P2 := NewStatusKey(<font color="#FF0000">'~F10~ Menu'</font>, kbF10, cmMenu, P3);
    P1 := NewStatusKey(<font color="#FF0000">'~Alt+X~ Programm beenden'</font>, kbAltX, cmQuit, P2);
    P0 := NewStatusDef(<font color="#0077BB">0</font>, <font color="#0077BB">$</font>FFFF, P1, <b><font color="0000BB">nil</font></b>);
<br>
    StatusLine := <b><font color="0000BB">New</font></b>(PStatusLine, Init(R, P0));
  <b><font color="0000BB">end</font></b>;</code></pre>
Die Deklaration und Ausführung bleibt gleich.<br>
<pre><code><b><font color="0000BB">var</font></b>
  MyApp: TMyApp;
<br>
<b><font color="0000BB">begin</font></b>
  MyApp.Init;   <i><font color="#FFFF00">// Inizialisieren</font></i>
  MyApp.Run;    <i><font color="#FFFF00">// Abarbeiten</font></i>
  MyApp.Done;   <i><font color="#FFFF00">// Freigeben</font></i>
<b><font color="0000BB">end</font></b>.</code></pre>
<br>
</html>
