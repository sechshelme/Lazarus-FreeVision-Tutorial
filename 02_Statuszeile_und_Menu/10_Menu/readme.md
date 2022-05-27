<html>
    <b><h1>02 Statuszeile und Menu</h1></b>
    <b><h2>10 Menu</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Hinzufügen eines Menüs.<br>
<hr><br>
Für das Menü werden die gleichen Units wie für die Statuszeile gebraucht.<br>
<pre><code><b><font color="0000BB">uses</font></b>
  App,      <i><font color="#FFFF00">// TApplication</font></i>
  Objects,  <i><font color="#FFFF00">// Fensterbereich (TRect)</font></i>
  Drivers,  <i><font color="#FFFF00">// Hotkey</font></i>
  Views,    <i><font color="#FFFF00">// Ereigniss (cmQuit)</font></i>
  Menus;    <i><font color="#FFFF00">// Statuszeile</font></i></code></pre>
Für ein Menu muss man <b>InitMenuBar</b> vererben.<br>
<pre><code><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;   <i><font color="#FFFF00">// Statuszeile</font></i>
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;      <i><font color="#FFFF00">// Menü</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Das Menü erzeugen, das Beispiel hat nur eine einziger Menüpunkt, Beenden.<br>
Beim Menü sind die Zeichen die mit <b>~x~</b> hervorgehoben sind nicht nur Optischen, sonder auch funktionell.<br>
Zum beenden, kann man auch <b>[Alt+s]</b>, <b>[b]</b> drücken.<br>
Es gibt auch direkte HotKey auf die Menüpunkte, hier im Beipiel ist die <b>[Alt+x]</b> für beenden.<br>
Dieses überschneidet sich hier zufällig mit <b>[Alt+x]</b> von der Statuszeile, aber dies ist egal.<br>
Der Aufbau der Menüerzeugung ist ähnlich der Statuszeile.<br>
Beim letzten Menüpunkt kommt immer ein <b>nil</b>.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;           <i><font color="#FFFF00">// Rechteck für die Memüzeile Position.</font></i>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>; <i><font color="#FFFF00">// Position des Menüs, auf oberste Zeile der App setzen.</font></i>
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, NewMenu(
      NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(
      NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext,
      <b><font color="0000BB">nil</font></b>)), <b><font color="0000BB">nil</font></b>))));
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
