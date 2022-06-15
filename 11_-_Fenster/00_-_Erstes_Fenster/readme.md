<html>
    <b><h1>11 - Fenster</h1></b>
    <b><h2>00 - Erstes Fenster</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Erstes Memo-Fenster.<br>
<hr><br>
Der Constructor wird vererbt, so das von Anfang an ein neues Fenster erstellt wird.<br>
<pre><code><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    <b><font color="0000BB">constructor</font></b> Init;
<br>
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;
<br>
    <b><font color="0000BB">procedure</font></b> NewWindows;
  <b><font color="0000BB">end</font></b>;</code></pre>
<pre><code>  <b><font color="0000BB">constructor</font></b> TMyApp.Init;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> Init;   <i><font color="#FFFF00">// Der Vorfahre aufrufen.</font></i>
    NewWindows;       <i><font color="#FFFF00">// Fenster erzeugen.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Neues Fenster erzeugen. Fenster werden in der Regel nicht modal geöffnet, da man meistens mehrere davon öffnen will.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.NewWindows;
  <b><font color="0000BB">var</font></b>
    Win: PWindow;
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">60</font>, <font color="#0077BB">20</font>);
    Win := <b><font color="0000BB">New</font></b>(PWindow, Init(R, <font color="#FF0000">'Fenster'</font>, wnNoNumber));
    <b><font color="0000BB">if</font></b> ValidView(Win) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Win);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
