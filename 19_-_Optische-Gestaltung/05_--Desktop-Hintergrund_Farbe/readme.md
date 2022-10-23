<html>
    <b><h1>19 - Optische-Gestaltung</h1></b>
    <b><h2>05 --Desktop-Hintergrund Farbe</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Wen man die Farbe des Hintergrundes änder will, ist ein wenig komplizierter als nur das Zeichen.<br>
Dazu muss man beim Object <b>TBackground</b> die Funktion <b>GetPalette</b> überschreiben.<br>
<br>
<hr><br>
Für das Object <b>TBackground</b> wird ein Nachkomme erzeugt, welcher eine neue <b>GetPalette</b> Funktion bekommt.<br>
<pre><code=pascal><b><font color="0000BB">type</font></b>
  PMyBackground = ^TMyBackground;
  TMyBackground = <b><font color="0000BB">object</font></b>(TBackGround)
    <b><font color="0000BB">function</font></b> GetPalette: PPalette; <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// neu GetPalette</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
In der neuen Funktion wird eine andere Palette zugeordnet.<br>
<pre><code=pascal>  <b><font color="0000BB">function</font></b> TMyBackground.GetPalette: PPalette;
  <b><font color="0000BB">const</font></b>
    P: <b><font color="0000BB">string</font></b>[<font color="#0077BB">1</font>] = <font color="#FF0000">#74</font>;
  <b><font color="0000BB">begin</font></b>
    Result := @P;
  <b><font color="0000BB">end</font></b>;</code></pre>
Der Konstruktor sieht fast gleich aus wie beim Hintergrundzeichen.<br>
Einziger Unterschied anstelle von <b>PBackGround</b> wird <b>PMyBackground</b> genommen.<br>
<pre><code=pascal>  <b><font color="0000BB">constructor</font></b> TMyApp.Init;
  <b><font color="0000BB">var</font></b>
    R:TRect;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> Init;                                       <i><font color="#FFFF00">// Vorfahre aufrufen</font></i>
    GetExtent(R);
<br>
    DeskTop^.Insert(<b><font color="0000BB">New</font></b>(PMyBackground, Init(R, <font color="#FF0000">#3</font>)));  <i><font color="#FFFF00">// Hintergrund einfügen.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
