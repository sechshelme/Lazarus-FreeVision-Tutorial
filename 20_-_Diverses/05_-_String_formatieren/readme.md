<html>
    <b><h1>20 - Diverses</h1></b>
    <b><h2>05 - String formatieren</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Mit <b>FormatStr</b> können Strings formatiert werden.<br>
Dabei sind filgende Formatierungen möglich:<br>
%c: Char<br>
%s: String<br>
%d: Ganzzahlen<br>
%x: Hexadezimal<br>
%#: Formatierungen<br>
Bei Realzahlen muss man sich folgendermassen behelfen:<br>
<pre><code><b><font color="0000BB">procedure</font></b> Str(<b><font color="0000BB">var</font></b> X: TNumericType[:NumPlaces[:Decimals]];<b><font color="0000BB">var</font></b> S: <b><font color="0000BB">String</font></b>);</code></pre>
<hr><br>
<hr><br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Deklaration des Dialogs.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyDialog = ^TMyDialog;
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
    <b><font color="0000BB">constructor</font></b> Init;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Bei Integern ist es wichtig, das man diese als <b>PtrInt</b> deklariert.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyDialog.Init;
<b><font color="0000BB">const</font></b>
  acht = <font color="#0077BB">8</font>;
  vier = <font color="#0077BB">16</font>;
  Mo = <font color="#FF0000">'Montag'</font>;
  Fr = <font color="#FF0000">'Freitag'</font>;
<br>
<b><font color="0000BB">var</font></b>
  R: TRect;
  Params:<b><font color="0000BB">record</font></b>
    s1, s2: PString;
    i1, i2: PtrInt;
  <b><font color="0000BB">end</font></b>;
  s: ShortString;
</code></pre>
Hier sieht man, die Formatierung mit <b>FormatStr</b>.<br>
<pre><code><b><font color="0000BB">begin</font></b>
  Params.s1 := NewStr(Mo);
  Params.s2 := NewStr(Fr);
  Params.i1 := acht;
  Params.i2 := vier;
<br>
  FormatStr(s, <font color="#FF0000">'Gearbeitet wird zwischen %s und %s'</font><font color="#FF0000">#13</font>+
    <font color="#FF0000">'und dies zwischen %d:00 und %d:00 Uhr.'</font>, (@Params)^);
<br>
  R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">52</font>, <font color="#0077BB">13</font>);
  R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'<b><font color="0000BB">String</font></b> formatieren'</font>);
<br>
  <i><font color="#FFFF00">// ---Statictext;</font></i>
  R.Assign(<font color="#0077BB">3</font>, <font color="#0077BB">2</font>, <font color="#0077BB">50</font>, <font color="#0077BB">5</font>);
  Insert(<b><font color="0000BB">new</font></b>(PStaticText, Init(R, s)));
<br>
  <i><font color="#FFFF00">// ---Ok-Button</font></i>
  R.Assign(<font color="#0077BB">20</font>, <font color="#0077BB">8</font>, <font color="#0077BB">32</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
</html>
