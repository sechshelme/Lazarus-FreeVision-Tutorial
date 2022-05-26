<html>
    <b><h1>06 Komponenten modifizieren</h1></b>
    <b><h2>00 Button modifizieren</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Man kann auch eine Komponente modifzieren, in diesem Beispiel ist es ein Button.<br>
Dazu muss man einen Nachkommen von TButton erstellen.<br>
Der abgeänderte Button passt sich automatisch an die Länge des Titels an, auch wird er automatisch 2 Zeilen hoch.<br>
<hr><br>
Anstelle des normalen Button nehme ich jetzt den PMyButton.<br>
Man sieht auch, das man anstelle von Rect, nur X und Y angibt.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.MyParameter;
  <b><font color="0000BB">var</font></b>
    Dia: PDialog;
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">35</font>, <font color="#0077BB">15</font>);                    <i><font color="#FFFF00">// Grösse des Dialogs.</font></i>
    R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);                             <i><font color="#FFFF00">// Position des Dialogs.</font></i>
    Dia := <b><font color="0000BB">New</font></b>(PDialog, Init(R, <font color="#FF0000">'Parameter'</font>)); <i><font color="#FFFF00">// Dialog erzeugen.</font></i>
    <b><font color="0000BB">with</font></b> Dia^ <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
      <i><font color="#FFFF00">// oben</font></i>
      Insert(<b><font color="0000BB">new</font></b>(PMyButton, Init(<font color="#0077BB">7</font>, <font color="#0077BB">8</font>, <font color="#FF0000">'sehr langer ~T~ext'</font>, cmValid, bfDefault)));
<br>
      <i><font color="#FFFF00">// mitte</font></i>
      Insert(<b><font color="0000BB">new</font></b>(PMyButton, Init(<font color="#0077BB">7</font>, <font color="#0077BB">4</font>, <font color="#FF0000">'~k~urz'</font>, cmValid, bfDefault)));
<br>
      <i><font color="#FFFF00">// Ok-Button</font></i>
      Insert(<b><font color="0000BB">new</font></b>(PMyButton, Init(<font color="#0077BB">7</font>, <font color="#0077BB">12</font>, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<br>
      <i><font color="#FFFF00">// Schliessen-Button</font></i>
      Insert(<b><font color="0000BB">new</font></b>(PMyButton, Init(<font color="#0077BB">19</font>, <font color="#0077BB">12</font>, <font color="#FF0000">'~A~bbruch'</font>, cmCancel, bfNormal)));
    <b><font color="0000BB">end</font></b>;
    Desktop^.ExecView(Dia);   <i><font color="#FFFF00">// Dialog Modal öffnen.</font></i>
    <b><font color="0000BB">Dispose</font></b>(Dia, Done);       <i><font color="#FFFF00">// Dialog und Speicher frei geben.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
<hr><br>
<b>Unit mit dem neuen Button.</b><br>
<br><br>
Hier wird gezeigt, wie man einen Button abänder kann.<br>
<pre><code><b><font color="0000BB">unit</font></b> MyButton;
</code></pre>
Deklaration des neuen Buttons.<br>
Hier sieht man, das man den Konstruktor überschreiben muss.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyButton = ^TMyButton;
  TMyButton = <b><font color="0000BB">object</font></b>(TButton)
    <b><font color="0000BB">constructor</font></b> Init(x, y: integer; ATitle: TTitleStr; ACommand: word; AFlags: word);
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstruktor sieht man, das aus <b>X</b> und <b>Y</b> ein <b>Rect</b> generiert wird.<br>
<b>StringReplace</b> werden noch die ~ gelöscht, da diese sonst die Länge des Stringes verfälschen.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyButton.Init(x, y: integer; ATitle: TTitleStr; ACommand: word; AFlags: word);
<b><font color="0000BB">var</font></b>
  R: TRect;
<b><font color="0000BB">begin</font></b>
  R.Assign(x, y, x + Length(StringReplace(ATitle, <font color="#FF0000">'~'</font>, <font color="#FF0000">''</font>, [])) + <font color="#0077BB">2</font>, y + <font color="#0077BB">2</font>);
<br>
  <b><font color="0000BB">inherited</font></b> Init(R, ATitle, ACommand, AFlags);
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
</html>
