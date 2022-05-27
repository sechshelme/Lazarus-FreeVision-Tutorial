<html>
    <b><h1>19 Optische-Gestaltung</h1></b>
    <b><h2>00-Desktop-Hintergrund Zeichen</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Beim Desktophintergrund kann man ein beliebiges Hintergrund-Zeichen zuordnen. Als Default ist das Zeichen <b>#176</b>.<br>
<hr><br>
Der Hintergrund fügt man ähnlich zu, wie ein Fenster/Dialog, dies geschieht auch mit <b>Insert</b>.<br>
Mit <b>#3</b> füllt es den Hintergrund mit Herzen auf.<br>
<pre><code>  <b><font color="0000BB">constructor</font></b> TMyApp.Init;
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> Init;                                      <i><font color="#FFFF00">// Vorfahre aufrufen</font></i>
    GetExtent(R);
<br>
    DeskTop^.Insert(<b><font color="0000BB">New</font></b>(PBackGround, Init(R, <font color="#FF0000">#3</font>)));   <i><font color="#FFFF00">// Hintergrund einfügen.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
