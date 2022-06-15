<html>
    <b><h1>02 - Statuszeile und Menu</h1></b>
    <b><h2>35 - Menu und Statuszeile tauschen</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Man kann zur Laufzeit das komplette Menü und Statuszeile austauschen.<br>
ZB. um die Anwendung mehrsprachig zu machen.<br>
Dazu wird die aktuelle Komponente entfernt und die neue eingefügt.<br>
In dem Beispiel gibt es je eine deutsche und englische Komponente.<br>
<hr><br>
Deklaration der Komponenten<br>
<pre><code>  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;                 <i><font color="#FFFF00">// Statuszeile</font></i>
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Menü</font></i>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// Eventhandler</font></i>
  <b><font color="0000BB">private</font></b>
    menuGer, menuEng: PMenuView;          <i><font color="#FFFF00">// Die beiden Menüs</font></i>
    StatusGer, StatusEng: PStatusLine;    <i><font color="#FFFF00">// Die beiden Stauszeilen</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Inizialisieren der beiden Statuszeilen.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitStatusLine;
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.A.Y := R.B.Y - <font color="#0077BB">1</font>;
<br>
    <i><font color="#FFFF00">// Statuszeile deutsch</font></i>
    StatusGer := <b><font color="0000BB">New</font></b>(PStatusLine, Init(R, NewStatusDef(<font color="#0077BB">0</font>, <font color="#0077BB">$</font>FFFF,
      NewStatusKey(<font color="#FF0000">'~Alt+X~ Programm beenden'</font>, kbAltX, cmQuit,
      NewStatusKey(<font color="#FF0000">'~F10~ Menue'</font>, kbF10, cmMenu,
      NewStatusKey(<font color="#FF0000">'~F1~ Hilfe'</font>, kbF1, cmHelp, <b><font color="0000BB">nil</font></b>))), <b><font color="0000BB">nil</font></b>)));
<br>
    <i><font color="#FFFF00">// Statuszeile englisch</font></i>
    StatusEng := <b><font color="0000BB">New</font></b>(PStatusLine, Init(R, NewStatusDef(<font color="#0077BB">0</font>, <font color="#0077BB">$</font>FFFF,
      NewStatusKey(<font color="#FF0000">'~Alt+X~ <b><font color="0000BB">Exit</font></b>'</font>, kbAltX, cmQuit,
      NewStatusKey(<font color="#FF0000">'~F10~ Menu'</font>, kbF10, cmMenu,
      NewStatusKey(<font color="#FF0000">'~F1~ Help'</font>, kbF1, cmHelp, <b><font color="0000BB">nil</font></b>))), <b><font color="0000BB">nil</font></b>)));
<br>
    StatusLine := StatusGer; <i><font color="#FFFF00">// Deutsch per Default</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Inizialisieren der beiden Menüs.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    <i><font color="#FFFF00">// Menü deutsch</font></i>
    menuGer := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, NewMenu(
      NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'S~c~hliessen'</font>, <font color="#FF0000">'Alt-F3'</font>, kbAltF3, cmClose, hcNoContext,
        NewLine(
        NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>)))),
      NewSubMenu(<font color="#FF0000">'~O~ptionen'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~P~arameter...'</font>, <font color="#FF0000">''</font>, kbF2, cmPara, hcNoContext,
        NewLine(
        NewItem(<font color="#FF0000">'~D~eutsch'</font>, <font color="#FF0000">'Alt-D'</font>, kbAltD, cmMenuGerman, hcNoContext,
        NewItem(<font color="#FF0000">'~E~nglisch'</font>, <font color="#FF0000">'Alt-E'</font>, kbAltE, cmMenuEnlish, hcNoContext, <b><font color="0000BB">nil</font></b>))))),
      NewSubMenu(<font color="#FF0000">'~H~ilfe'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~A~bout...'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext, <b><font color="0000BB">nil</font></b>)), <b><font color="0000BB">nil</font></b>))))));
<br>
    <i><font color="#FFFF00">// Menü englisch</font></i>
    menuEng := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, NewMenu(
      NewSubMenu(<font color="#FF0000">'~F~ile'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~C~lose'</font>, <font color="#FF0000">'Alt-F3'</font>, kbAltF3, cmClose, hcNoContext,
        NewLine(
        NewItem(<font color="#FF0000">'E~x~it'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>)))),
      NewSubMenu(<font color="#FF0000">'~O~ptions'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~P~arameters...'</font>, <font color="#FF0000">''</font>, kbF2, cmPara, hcNoContext,
        NewLine(
        NewItem(<font color="#FF0000">'German'</font>, <font color="#FF0000">'Alt-D'</font>, kbAltD, cmMenuGerman, hcNoContext,
        NewItem(<font color="#FF0000">'English'</font>, <font color="#FF0000">'Alt-E'</font>, kbAltE, cmMenuEnlish, hcNoContext, <b><font color="0000BB">nil</font></b>))))),
      NewSubMenu(<font color="#FF0000">'~H~elp'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~A~bout...'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext, <b><font color="0000BB">nil</font></b>)), <b><font color="0000BB">nil</font></b>))))));
<br>
    MenuBar := menuGer; <i><font color="#FFFF00">// Deutsch per Default</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Austauschen der Komponenten<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    Rect: TRect;              <i><font color="#FFFF00">// Rechteck für die Statuszeilen Position.</font></i>
<br>
  <b><font color="0000BB">begin</font></b>
    GetExtent(Rect);
<br>
    Rect.A.Y := Rect.B.Y - <font color="#0077BB">1</font>;
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmAbout: <b><font color="0000BB">begin</font></b>
          <i><font color="#FFFF00">// Ein About Dialog</font></i>
        <b><font color="0000BB">end</font></b>;
<br>
        <i><font color="#FFFF00">// Menü auf englisch</font></i>
        cmMenuEnlish: <b><font color="0000BB">begin</font></b>
<br>
          <i><font color="#FFFF00">// Menü tauschen</font></i>
          Delete(MenuBar);          <i><font color="#FFFF00">// Altes Menü entfernen</font></i>
          MenuBar := menuEng;       <i><font color="#FFFF00">// Neues Menü zuordnen</font></i>
          Insert(MenuBar);          <i><font color="#FFFF00">// Neues Menü einfügen</font></i>
<br>
          <i><font color="#FFFF00">// Statuszeile tauschen</font></i>
          Delete(StatusLine);       <i><font color="#FFFF00">// Alte Statuszeile entfernen</font></i>
          StatusLine := StatusEng;  <i><font color="#FFFF00">// Neue Statuszeile zuordnen</font></i>
          Insert(StatusLine);       <i><font color="#FFFF00">// Neue Statuszeile einfügen</font></i>
        <b><font color="0000BB">end</font></b>;
<br>
        <i><font color="#FFFF00">// Menü auf deutsch</font></i>
        cmMenuGerman: <b><font color="0000BB">begin</font></b>
          Delete(MenuBar);
          MenuBar := menuGer;
          Insert(MenuBar);
<br>
          Delete(StatusLine);
          StatusLine := StatusGer;
          Insert(StatusLine);
        <b><font color="0000BB">end</font></b>;
        cmPara: <b><font color="0000BB">begin</font></b>
          <i><font color="#FFFF00">// Ein Parameter Dialog</font></i>
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
