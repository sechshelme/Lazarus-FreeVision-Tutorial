# 02 - Statuszeile und Menu
## 15 - Menu erweitert
<img src="image.png" alt="Selfhtml"><br><br>
Hinzufügen mehrere Menüpunkte.<br>
Hier wird dies auch der Übersicht zu liebe gesplittet gemacht.<br>
---
Für eigene Kommandos, muss man noch Kommdocode definieren.<br>
Es empfiehlt sich Werte &gt; 1000 zu verwenden, so das es keine Überschneidungen mit den Standard-Codes gibt.<br>
<pre><code=pascal><b><font color="0000BB">const</font></b>
  cmList = <font color="#0077BB">1002</font>;      <i><font color="#FFFF00">// Datei Liste</font></i>
  cmAbout = <font color="#0077BB">1001</font>;     <i><font color="#FFFF00">// About anzeigen</font></i></code></pre>
Für ein Menu muss man <b>InitMenuBar</b> vererben.<br>
<pre><code=pascal><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;   <i><font color="#FFFF00">// Statuszeile</font></i>
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;      <i><font color="#FFFF00">// Menü</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Mam kann die Menüeinträge auch gesplittet über Pointer machen.<br>
Ob man es verschachtelt oder splittet, ist Geschmacksache.<br>
Mit <b>NewLine</b> kann man eine Leerzeile einfügen.<br>
Es empfiehlt sich wen bei einem Menüpunkt ein Dialog aufgeht, Hinter der Bezeichnung <b>...</b> zu schreiben.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;                          <i><font color="#FFFF00">// Rechteck für die Menüzeilen-Position.</font></i>
<br>
    M: PMenu;                          <i><font color="#FFFF00">// Ganzes Menü</font></i>
    SM0, SM1,                          <i><font color="#FFFF00">// Submenu</font></i>
    M0_0, M0_1, M0_2, M1_0: PMenuItem; <i><font color="#FFFF00">// Einfache Menüpunkte</font></i>
<br>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    M1_0 := NewItem(<font color="#FF0000">'~A~bout...'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext, <b><font color="0000BB">nil</font></b>);
    SM1 := NewSubMenu(<font color="#FF0000">'~H~ilfe'</font>, hcNoContext, NewMenu(M1_0), <b><font color="0000BB">nil</font></b>);
<br>
    M0_2 := NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>);
    M0_1 := NewLine(M0_2);
    M0_0 := NewItem(<font color="#FF0000">'~L~iste'</font>, <font color="#FF0000">'F2'</font>, kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(M0_0), SM1);
<br>
    M := NewMenu(SM0);
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, M));
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
