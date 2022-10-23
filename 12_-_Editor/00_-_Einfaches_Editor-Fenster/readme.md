<html>
    <b><h1>12 - Editor</h1></b>
    <b><h2>00 - Einfaches Editor-Fenster</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Das Fenster ist nun ein Text-Editor, das man diese Funktion erreicht, nimmt man ein <b>PEditWindow</b>.<br>
Die Verwaltung der Fenster ist gleich, wie bei einem <b>TWindow</b>.<br>
<hr><br>
Einfügen eines leeren Editorfensters.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.NewWindows;
  <b><font color="0000BB">var</font></b>
    Win: PEditWindow;
    R: TRect;
  <b><font color="0000BB">const</font></b>
    WinCounter: integer = <font color="#0077BB">0</font>;      <i><font color="#FFFF00">// Zählt Fenster</font></i>
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">60</font>, <font color="#0077BB">20</font>);
    Inc(WinCounter);
    Win := <b><font color="0000BB">New</font></b>(PEditWindow, Init(R, <font color="#FF0000">''</font>, WinCounter));
<br>
    <b><font color="0000BB">if</font></b> ValidView(Win) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Win);
    <b><font color="0000BB">end</font></b> <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>                <i><font color="#FFFF00">// Fügt das Fenster ein.</font></i>
      Dec(WinCounter);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
