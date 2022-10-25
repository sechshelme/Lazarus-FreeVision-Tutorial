# 02 - Statuszeile und Menu
## 30 - Menu Hinweise
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Hinweise in der Statuszeile der Menü-Punkte.<br>
---
<br>
Konstanten der einzelnen Hilfen.<br>
Am besten mimmt man da hcxxx Namen.<br>
<pre><code=pascal><b><font color="0000BB">const</font></b>
  cmList   = <font color="#0077BB">1002</font>;  <i><font color="#FFFF00">// Datei Liste</font></i>
  cmAbout  = <font color="#0077BB">1001</font>;  <i><font color="#FFFF00">// About anzeigen</font></i>
<br>
  hcFile   = <font color="#0077BB">10</font>;
  hcClose  = <font color="#0077BB">11</font>;
  hcOption = <font color="#0077BB">12</font>;
  hcFormat = <font color="#0077BB">13</font>;
  hcEdit   = <font color="#0077BB">14</font>;
  hcHelp   = <font color="#0077BB">15</font>;
  hcAbout  = <font color="#0077BB">16</font>;</code></pre>
Die Hint-Zeile muss vererbt werden.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;                   <i><font color="#FFFF00">// Rechteck für die Menüzeilen-Position.</font></i>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, NewMenu(
      NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcFile, NewMenu(
        NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcClose, <b><font color="0000BB">nil</font></b>)),
<br>
      NewSubMenu(<font color="#FF0000">'~O~ptionen'</font>, hcOption, NewMenu(
        NewItem(<font color="#FF0000">'~F~ormat'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcFormat,
        NewItem(<font color="#FF0000">'~E~itor'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcEdit, <b><font color="0000BB">nil</font></b>))),
<br>
      NewSubMenu(<font color="#FF0000">'~H~ilfe'</font>, hcHelp, NewMenu(
        NewItem(<font color="#FF0000">'~A~bout...'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcAbout, <b><font color="0000BB">nil</font></b>)), <b><font color="0000BB">nil</font></b>))))));
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
