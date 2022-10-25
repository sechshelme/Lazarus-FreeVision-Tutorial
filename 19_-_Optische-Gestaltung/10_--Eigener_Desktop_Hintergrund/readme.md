# 19 - Optische-Gestaltung
## 10 --Eigener Desktop Hintergrund
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Man hat sogar die Möglichkeit, den ganzen Background selbst zu zeichnen.<br>
Da man alles selbst zeichent kann man sich den Umweg über <b>TBackGround</b> sparen und direkt <B>TView</b> vererben.<br>
<b>TBackGround</b> ist ein direkter Nachkomme von <b>TView</b>.<br>
---
<br>
Für das Object <b>TView</b> wird ein Nachkomme erzeugt, welcher eine neue <b>Draw</b> Procedure bekommt.<br>
<pre><code=pascal><b><font color="0000BB">type</font></b>
  PMyBackground = ^TMyBackground;
  TMyBackground = <b><font color="0000BB">object</font></b>(TView)
    <b><font color="0000BB">procedure</font></b> Draw; <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// neu Draw-Procedure.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
In der neuen Funktion wird ein Byte-Muster in Form einer Backsteinwand gezeichnet.<br>
Die Möglickeiten sind unbegrenzt, man kann ein ganzes Bild erzeugen.<br>
Das was man ausgeben will, kommt Zeilenweise in den <b>TDrawBuffer</b>.<br>
Anschliessend wird mit <b>WriteLine(...</b> der Buffer gezeichnet.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyBackground.Draw;
  <b><font color="0000BB">const</font></b>
    b1 : <b><font color="0000BB">array</font></b> [<font color="#0077BB">0</font>..<font color="#0077BB">3</font>] <b><font color="0000BB">of</font></b> Byte = (<font color="#0077BB">196</font>, <font color="#0077BB">193</font>, <font color="#0077BB">196</font>, <font color="#0077BB">194</font>); <i><font color="#FFFF00">// obere Backsteinreihe.</font></i>
    b2 : <b><font color="0000BB">array</font></b> [<font color="#0077BB">0</font>..<font color="#0077BB">3</font>] <b><font color="0000BB">of</font></b> Byte = (<font color="#0077BB">196</font>, <font color="#0077BB">194</font>, <font color="#0077BB">196</font>, <font color="#0077BB">193</font>); <i><font color="#FFFF00">// untere Backsteinreihe.</font></i>
<br>
  <b><font color="0000BB">var</font></b>
    Buf1, Buf2: TDrawBuffer;
    i: integer;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">for</font></b> i := <font color="#0077BB">0</font> <b><font color="0000BB">to</font></b> Size.X - <font color="#0077BB">1</font> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
      Buf1[i] := b1[i <b><font color="0000BB">mod</font></b> <font color="#0077BB">4</font>] + <font color="#0077BB">$46</font> <b><font color="0000BB">shl</font></b> <font color="#0077BB">8</font>;
      Buf2[i] := b2[i <b><font color="0000BB">mod</font></b> <font color="#0077BB">4</font>] + <font color="#0077BB">$46</font> <b><font color="0000BB">shl</font></b> <font color="#0077BB">8</font>;
    <b><font color="0000BB">end</font></b>;
<br>
    <b><font color="0000BB">for</font></b> i := <font color="#0077BB">0</font> <b><font color="0000BB">to</font></b> Size.Y <b><font color="0000BB">div</font></b> <font color="#0077BB">2</font> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
      WriteLine(<font color="#0077BB">0</font>, i * <font color="#0077BB">2</font> + <font color="#0077BB">0</font>, Size.X, <font color="#0077BB">1</font>, Buf1);
      WriteLine(<font color="#0077BB">0</font>, i * <font color="#0077BB">2</font> + <font color="#0077BB">1</font>, Size.X, <font color="#0077BB">1</font>, Buf2);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
Der Konstruktor sieht gleich aus wie bei der Hintergrund-Zeichenfarbe.<br>
Dem ist Egal ob <b>TMyBackground</b> ein Nachkomme von <b>TView</b> oder <b>TBackground</b> ist.<br>
<pre><code=pascal>  <b><font color="0000BB">constructor</font></b> TMyApp.Init;
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> Init;                                <i><font color="#FFFF00">// Vorfahre aufrufen</font></i>
    GetExtent(R);
<br>
    DeskTop^.Insert(<b><font color="0000BB">New</font></b>(PMyBackground, Init(R)));  <i><font color="#FFFF00">// Hintergrund einfügen.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
