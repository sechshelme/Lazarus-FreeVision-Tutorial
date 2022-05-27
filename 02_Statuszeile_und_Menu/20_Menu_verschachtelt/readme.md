<html>
    <b><h1>02 Statuszeile und Menu</h1></b>
    <b><h2>08 Menu verschachtelt</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Menupunkt kann man auch ineinander verschachteln.<br>
<hr><br>
Bei der Statuszeile habe ich die Einträge verschachtelt, somit braucht man keine Zeiger.<br>
Ich finde dies auch übersichtlicher, als ein Variablen-Urwald.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitStatusLine;
  <b><font color="0000BB">var</font></b>
    R: TRect;              <i><font color="#FFFF00">// Rechteck für die Statuszeilen Position.</font></i>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.A.Y := R.B.Y - <font color="#0077BB">1</font>;
<br>
    StatusLine := <b><font color="0000BB">New</font></b>(PStatusLine, Init(R, NewStatusDef(<font color="#0077BB">0</font>, <font color="#0077BB">$</font>FFFF,
      NewStatusKey(<font color="#FF0000">'~Alt+X~ Programm beenden'</font>, kbAltX, cmQuit,
      NewStatusKey(<font color="#FF0000">'~F10~ Menu'</font>, kbF10, cmMenu,
      NewStatusKey(<font color="#FF0000">'~F1~ Hilfe'</font>, kbF1, cmHelp, <b><font color="0000BB">nil</font></b>))), <b><font color="0000BB">nil</font></b>)));
  <b><font color="0000BB">end</font></b>;</code></pre>
Folgendes Beispiel demonstriert ein verschachteltes Menü.<br>
Die Erzeugung ist auch verschachtelt.<br>
<pre><code>Datei
  Beenden
Demo
  Einfach 1
  Verschachtelt
    Menu 0
    Menu 1
    Menu 2
  Einfach 2
Hilfe
  About</code></pre>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;                   <i><font color="#FFFF00">// Rechteck für die Menüzeilen-Position.</font></i>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, NewMenu(
      NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>)),
<br>
      NewSubMenu(<font color="#FF0000">'Dem~o~'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'Einfach ~1~'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext,
        NewSubMenu(<font color="#FF0000">'~V~erschachtelt'</font>, hcNoContext, NewMenu(
          NewItem(<font color="#FF0000">'Menu ~0~'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext,
          NewItem(<font color="#FF0000">'Menu ~1~'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext,
          NewItem(<font color="#FF0000">'Menu ~2~'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext, <b><font color="0000BB">nil</font></b>)))),
        NewItem(<font color="#FF0000">'Einfach ~2~'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext, <b><font color="0000BB">nil</font></b>)))),
<br>
      NewSubMenu(<font color="#FF0000">'~H~ilfe'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~A~bout...'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext, <b><font color="0000BB">nil</font></b>)), <b><font color="0000BB">nil</font></b>))))));
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
