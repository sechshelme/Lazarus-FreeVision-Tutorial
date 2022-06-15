<html>
    <b><h1>02 - Statuszeile und Menu</h1></b>
    <b><h2>25 - Fertige Statuszeile und Menues</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Für die Statuszeile und das Menü gibt es fertige Items, aber ich bevorzuge es, die Items selbst zu erstellen.<br>
Die fetigen Items sind nur in Englisch.<br>
Die Statuszeile ist Textlos, das einzige, sie bringt Schnellkomandos mit. ( cmQuit, cmMenu, cmClose, cmZoom, cmNext, cmPrev )<br>
Bis aus <b>OS shell</b> und <b>Exit</b> passiert nichts.<br>
<hr><br>
Mit <b>StdStatusKeys(...</b> wird eine Statuszeile estellt, aber wie oben beschrieben, sieht man keinne Text.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitStatusLine;
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.A.Y := R.B.Y - <font color="#0077BB">1</font>;
<br>
    StatusLine := <b><font color="0000BB">New</font></b>(PStatusLine, Init(R, NewStatusDef(<font color="#0077BB">0</font>, <font color="#0077BB">$</font>FFFF, StdStatusKeys(<b><font color="0000BB">nil</font></b>), <b><font color="0000BB">nil</font></b>)));
  <b><font color="0000BB">end</font></b>;</code></pre>
Fur das Menü gibt es 3 fertige Items, für Datei, Bearbeiten und Fenster, aber eben in Englisch.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, NewMenu(
      NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(
        StdFileMenuItems (<b><font color="0000BB">nil</font></b>)),
      NewSubMenu(<font color="#FF0000">'~B~earbeiten'</font>, hcNoContext, NewMenu(
         StdEditMenuItems (<b><font color="0000BB">nil</font></b>)),
      NewSubMenu(<font color="#FF0000">'~F~enster'</font>, hcNoContext, NewMenu(
        StdWindowMenuItems(<b><font color="0000BB">nil</font></b>)), <b><font color="0000BB">nil</font></b>))))));
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
