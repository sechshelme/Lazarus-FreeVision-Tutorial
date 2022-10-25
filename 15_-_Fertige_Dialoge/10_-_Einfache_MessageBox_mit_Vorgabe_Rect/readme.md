# 15 - Fertige Dialoge
## 10 - Einfache MessageBox mit Vorgabe Rect
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Bei der MessageBox, kann man die Grösse auch manuell festlegen.<br>
Dazu muss man <b>MeassgeBoxRect(...)</b> verwenden.<br>
---
Hier wird mir <b>R.Assign</b> die grösse der Box selbst festgelegt.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmAbout: <b><font color="0000BB">begin</font></b>
          R.Assign(<font color="#0077BB">10</font>, <font color="#0077BB">3</font>, <font color="#0077BB">28</font>, <font color="#0077BB">20</font>);  <i><font color="#FFFF00">// Grösse der Box</font></i>
          MessageBoxRect(R, <font color="#FF0000">'Ich bin eine vorgegebene Box'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfOkButton);
        <b><font color="0000BB">end</font></b>;</code></pre>
<br>
