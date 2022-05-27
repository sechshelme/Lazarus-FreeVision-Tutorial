<html>
    <b><h1>19 Optische-Gestaltung</h1></b>
    <b><h2>15-Hintergrund auf Dialog</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Bei Bedarf, kann man auch ein Hintergrund-Muster auf einen Dialog/Fenster legen.<br>
<hr><br>
Hier wird der <b>PBackGround</b> auf einen Dialog gelegt, dies funktioniert genau gleich, wie auf dem Desktop.<br>
Dies kann auch der benutzerdefiniert <b>PMyBackground</b> sein.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.MyOption;
  <b><font color="0000BB">var</font></b>
    Dia: PDialog;
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">35</font>, <font color="#0077BB">15</font>);
    R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
    Dia := <b><font color="0000BB">New</font></b>(PDialog, Init(R, <font color="#FF0000">'Parameter'</font>));
<br>
    <b><font color="0000BB">with</font></b> Dia^ <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
<br>
      <i><font color="#FFFF00">// BackGround</font></i>
      GetExtent(R);
      R.Grow(-<font color="#0077BB">1</font>, -<font color="#0077BB">1</font>);
      Dia^.Insert(<b><font color="0000BB">New</font></b>(PBackGround, Init(R, <font color="#FF0000">#3</font>)));  <i><font color="#FFFF00">// Hintergrund einfügen.</font></i>
<br>
      <i><font color="#FFFF00">// Ok-Button</font></i>
      R.Assign(<font color="#0077BB">20</font>, <font color="#0077BB">11</font>, <font color="#0077BB">30</font>, <font color="#0077BB">13</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
    <b><font color="0000BB">end</font></b>;
<br>
    <b><font color="0000BB">if</font></b> ValidView(Dia) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.ExecView(Dia);
      <b><font color="0000BB">Dispose</font></b>(Dia, Done);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
