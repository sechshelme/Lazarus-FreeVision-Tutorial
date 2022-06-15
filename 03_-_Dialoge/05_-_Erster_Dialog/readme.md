<html>
    <b><h1>03 - Dialoge</h1></b>
    <b><h2>05 - Erster Dialog</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Abarbeiten der Events, der Statuszeile und des Menu.<br>
<hr><br>
Für Dialoge muss man noch die Unit <b>Dialogs</b> einfügen.<br>
<pre><code><b><font color="0000BB">uses</font></b>
  App,      <i><font color="#FFFF00">// TApplication</font></i>
  Objects,  <i><font color="#FFFF00">// Fensterbereich (TRect)</font></i>
  Drivers,  <i><font color="#FFFF00">// Hotkey</font></i>
  Views,    <i><font color="#FFFF00">// Ereigniss (cmQuit)</font></i>
  Menus,    <i><font color="#FFFF00">// Statuszeile</font></i>
  Dialogs;  <i><font color="#FFFF00">// Dialoge</font></i></code></pre>
Ein weiteres Kommando für den Aufruf des Dialoges.<br>
<pre><code><b><font color="0000BB">const</font></b>
  cmAbout = <font color="#0077BB">1001</font>;     <i><font color="#FFFF00">// About anzeigen</font></i>
  cmList = <font color="#0077BB">1002</font>;      <i><font color="#FFFF00">// Datei Liste</font></i>
  cmPara = <font color="#0077BB">1003</font>;      <i><font color="#FFFF00">// Parameter</font></i></code></pre>
Neue Funktionen kommen auch in die Klasse.<br>
Hier ein Dialog für Paramtereingabe.<br>
<pre><code><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;                 <i><font color="#FFFF00">// Statuszeile</font></i>
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Menü</font></i>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// Eventhandler</font></i>
<br>
    <b><font color="0000BB">procedure</font></b> MyParameter;                             <i><font color="#FFFF00">// neue Funktion für einen Dialog.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Das Menü wird um Parameter und Schliessen erweitert.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;                          <i><font color="#FFFF00">// Rechteck für die Menüzeilen-Position.</font></i>
<br>
    M: PMenu;                          <i><font color="#FFFF00">// Ganzes Menü</font></i>
    SM0, SM1,                          <i><font color="#FFFF00">// Submenu</font></i>
    M0_0, M0_1, M0_2, M0_3, M0_4, M0_5,
    M1_0: PMenuItem;                   <i><font color="#FFFF00">// Einfache Menüpunkte</font></i>
<br>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    M1_0 := NewItem(<font color="#FF0000">'~A~bout...'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext, <b><font color="0000BB">nil</font></b>);
    SM1 := NewSubMenu(<font color="#FF0000">'~H~ilfe'</font>, hcNoContext, NewMenu(M1_0), <b><font color="0000BB">nil</font></b>);
<br>
    M0_5 := NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>);
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem(<font color="#FF0000">'S~c~hliessen'</font>, <font color="#FF0000">'Alt-F3'</font>, kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_1 := NewItem(<font color="#FF0000">'~P~arameter...'</font>, <font color="#FF0000">''</font>, kbF2, cmPara, hcNoContext, M0_2);
    M0_0 := NewItem(<font color="#FF0000">'~L~iste'</font>, <font color="#FF0000">'F2'</font>, kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(M0_0), SM1);
<br>
    M := NewMenu(SM0);
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, M));
  <b><font color="0000BB">end</font></b>;</code></pre>
Hier wird mit dem Kommando <b>cmPara</b> ein Dialog geöffnet.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmAbout: <b><font color="0000BB">begin</font></b>
        <b><font color="0000BB">end</font></b>;
        cmList: <b><font color="0000BB">begin</font></b>
        <b><font color="0000BB">end</font></b>;
        cmPara: <b><font color="0000BB">begin</font></b>     <i><font color="#FFFF00">// Parameter Dialog öffnen.</font></i>
          MyParameter;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
Bauen eines leeren Dialoges.<br>
Auch da wird <b>TRect</b> gebraucht für die Grösse.<br>
Dies wird bei allen Komponenten gebraucht, egal ob Button, etc.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.MyParameter;
  <b><font color="0000BB">var</font></b>
    Dlg: PDialog;
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">35</font>, <font color="#0077BB">15</font>);                    <i><font color="#FFFF00">// Grösse des Dialogs.</font></i>
    R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);                             <i><font color="#FFFF00">// Position des Dialogs.</font></i>
    Dlg := <b><font color="0000BB">New</font></b>(PDialog, Init(R, <font color="#FF0000">'Parameter'</font>)); <i><font color="#FFFF00">// Dialog erzeugen.</font></i>
    Desktop^.Insert(Dlg);                      <i><font color="#FFFF00">// Dialog der App zuweisen.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
