<html>
    <b><h1>12 - Editor</h1></b>
    <b><h2>15 - Zwischenablage</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Hier wurde ein Zwischenablage hinzugefügt, somit ist auch kopieren und einfügen im Editor möglich.<br>
Die Zwischeablage ist nicht anderes als ein Editor-Fenster welches die Daten bekommt, wen man kopieren wählt.<br>
Somit kann man dieses sogar sichbar machen.<br>
<hr><br>
Ein Kommando für das öffnen des Zwischenablagefenster.<br>
<pre><code=pascal><b><font color="0000BB">const</font></b>
  cmNewWin = <font color="#0077BB">1001</font>;
  cmRefresh = <font color="#0077BB">1002</font>;
  cmShowClip = <font color="#0077BB">1003</font>;</code></pre>
Hier wird das Fenster für die Zwischenablage deklariert.<br>
Auch kann man bei <b>NewWindows</b> sagen, ob das Fenster nicht sichtbar ezeigt werden soll.<br>
<pre><code=pascal><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    ClipWindow: PEditWindow;
<br>
    <b><font color="0000BB">constructor</font></b> Init;
<br>
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;
<br>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
    <b><font color="0000BB">procedure</font></b> OutOfMemory; <b><font color="0000BB">virtual</font></b>;
<br>
    <b><font color="0000BB">function</font></b> NewWindows(FileName: ShortString; Visible: Boolean = <b><font color="0000BB">False</font></b>): PEditWindow;
    <b><font color="0000BB">procedure</font></b> OpenWindows;
    <b><font color="0000BB">procedure</font></b> SaveAll;
    <b><font color="0000BB">procedure</font></b> CloseAll;
  <b><font color="0000BB">end</font></b>;</code></pre>
Im Menü sind die neuen Bearbeiten-Funktionen dazugekommen.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, NewMenu(
      NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~N~eu'</font>, <font color="#FF0000">'F4'</font>, kbF4, cmNewWin, hcNoContext,
        NewItem(<font color="#FF0000">'~O~effnen...'</font>, <font color="#FF0000">'F3'</font>, kbF3, cmOpen, hcNoContext,
        NewItem(<font color="#FF0000">'~S~peichern'</font>, <font color="#FF0000">'F2'</font>, kbF2, cmSave, hcNoContext,
        NewItem(<font color="#FF0000">'Speichern ~u~nter...'</font>, <font color="#FF0000">''</font>, kbNoKey, cmSaveAs, hcNoContext,
        NewItem(<font color="#FF0000">'~A~lle speichern'</font>, <font color="#FF0000">''</font>, kbNoKey, cmSaveAll, hcNoContext,
        NewLine(
        NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>)))))))),
      NewSubMenu(<font color="#FF0000">'~B~earbeiten'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~R~'</font><font color="#FF0000">#129</font><font color="#FF0000">'ckg'</font><font color="#FF0000">#132</font><font color="#FF0000">'ngig'</font>, <font color="#FF0000">''</font>, kbAltBack, cmUndo, hcUndo,
        NewLine(
        NewItem(<font color="#FF0000">'Aus~s~chneiden'</font>, <font color="#FF0000">'Shift+Del'</font>, kbShiftDel, cmCut, hcCut,
        NewItem(<font color="#FF0000">'~K~opieren'</font>, <font color="#FF0000">'Ctrl+Ins'</font>, kbCtrlIns, cmCopy, hcCopy,
        NewItem(<font color="#FF0000">'~E~inf'</font><font color="#FF0000">#129</font><font color="#FF0000">'gen'</font>, <font color="#FF0000">'Shift+Ins'</font>, kbShiftIns, cmPaste, hcPaste,
        NewItem(<font color="#FF0000">'~L~'</font><font color="#FF0000">#148</font><font color="#FF0000">'schen'</font>, <font color="#FF0000">'Ctrl+Del'</font>, kbCtrlDel, cmClear, hcClear,
        NewLine(
        NewItem(<font color="#FF0000">'~Z~wischenablage'</font>, <font color="#FF0000">''</font>, kbNoKey, cmShowClip, hcCut, <b><font color="0000BB">nil</font></b>))))))))),
      NewSubMenu(<font color="#FF0000">'~S~uchen'</font>, hcNoContext, NewMenu(
        NewItem(<font color="#FF0000">'~S~uchen...'</font>, <font color="#FF0000">'Ctrl+F'</font>, kbCtrlF, cmFind, hcNoContext,
        NewItem(<font color="#FF0000">'~E~rsetzten...'</font>, <font color="#FF0000">'Ctrl+H'</font>, kbCtrlH, cmReplace, hcNoContext,
        NewItem(<font color="#FF0000">'Suche ~n~'</font><font color="#FF0000">#132</font><font color="#FF0000">'chstes'</font>, <font color="#FF0000">'Ctrl+N'</font>, kbCtrlN, cmSearchAgain, hcNoContext, <b><font color="0000BB">nil</font></b>)))),
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
        NewItem(<font color="#FF0000">'~S~chliessen'</font>, <font color="#FF0000">'Alt+F3'</font>, kbAltF3, cmClose, hcNoContext, <b><font color="0000BB">nil</font></b>)))))))))))), <b><font color="0000BB">nil</font></b>)))))));
  <b><font color="0000BB">end</font></b>;</code></pre>
Hier sieht man, wie man ein Fenster unsichbar erzeugen kann.<br>
<pre><code=pascal>  <b><font color="0000BB">function</font></b> TMyApp.NewWindows(FileName: ShortString; Visible: Boolean = <b><font color="0000BB">False</font></b>) : PEditWindow;
  <b><font color="0000BB">var</font></b>
    Win: PEditWindow;
    R: TRect;
  <b><font color="0000BB">const</font></b>
    WinCounter: integer = <font color="#0077BB">0</font>;
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">60</font>, <font color="#0077BB">20</font>);
    Inc(WinCounter);
    Win := <b><font color="0000BB">New</font></b>(PEditWindow, Init(R, FileName, WinCounter));
    <b><font color="0000BB">if</font></b> ValidView(Win) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">if</font></b> Visible <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
        win^.Hide;        <i><font color="#FFFF00">// Fenster verstecken.</font></i>
      <b><font color="0000BB">end</font></b>;
      Result := PEditWindow(MyApp.InsertWindow(win));
    <b><font color="0000BB">end</font></b> <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
      Dec(WinCounter);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
Hier sieht man, wie man das verborgene Zwischenablagefenster sichbar macht.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmNewWin: <b><font color="0000BB">begin</font></b>
          NewWindows(<font color="#FF0000">''</font>);
        <b><font color="0000BB">end</font></b>;
        cmOpen: <b><font color="0000BB">begin</font></b>
          OpenWindows;
        <b><font color="0000BB">end</font></b>;
        cmSaveAll: <b><font color="0000BB">begin</font></b>
          SaveAll;
        <b><font color="0000BB">end</font></b>;
        cmCloseAll: <b><font color="0000BB">begin</font></b>
          CloseAll;
        <b><font color="0000BB">end</font></b>;
        cmRefresh: <b><font color="0000BB">begin</font></b>
          ReDraw;
        <b><font color="0000BB">end</font></b>;
        cmShowClip: <b><font color="0000BB">begin</font></b>     <i><font color="#FFFF00">// Clipboard anzeigen.</font></i>
          ClipWindow^.Select;
          ClipWindow^.Show;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
