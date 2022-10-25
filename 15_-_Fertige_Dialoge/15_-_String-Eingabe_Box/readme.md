# 15 - Fertige Dialoge
## 15 - String-Eingabe Box
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Es gibt auch einen fertigen Dialog für eine String-Eingabe.<br>
Es gibt noch <b>InputBoxRect</b>, dort kann man die Grösser der Box selbst festlegen.<br>
---
<br>
So sieht der Code für die String-Eingabe aus.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    s:ShortString;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmInputLine: <b><font color="0000BB">begin</font></b>
          s := <font color="#FF0000">'Hello world !'</font>;
          <i><font color="#FFFF00">// Die InputBox</font></i>
          <b><font color="0000BB">if</font></b> InputBox(<font color="#FF0000">'Eingabe'</font>, <font color="#FF0000">'Wert:'</font>, s, <font color="#0077BB">255</font>) = cmOK <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
            MessageBox(<font color="#FF0000">'Es wurde "'</font> + s + <font color="#FF0000">'" eingegeben'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;</code></pre>
<br>
