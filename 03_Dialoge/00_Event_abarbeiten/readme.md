<html>
    <b><h1>03 Dialoge</h1></b>
    <b><h2>00 Event abarbeiten</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Abarbeiten der Events, der Statuszeile und des Menu.<br>
<hr><br>
Kommmandos die abgearbeitet werden.<br>
<pre><code><b><font color="0000BB">const</font></b>
  cmAbout = <font color="#0077BB">1001</font>;     <i><font color="#FFFF00">// About anzeigen</font></i>
  cmList = <font color="#0077BB">1002</font>;      <i><font color="#FFFF00">// Datei Liste</font></i></code></pre>
Der EventHandler ist auch ein Nachkommen.<br>
<pre><code><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;                 <i><font color="#FFFF00">// Statuszeile</font></i>
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Menü</font></i>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// Eventhandler</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Abarbeiten der eigenen cmxxx Kommandos.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmAbout: <b><font color="0000BB">begin</font></b>    <i><font color="#FFFF00">// Mache was mit cmAbout.</font></i>
        <b><font color="0000BB">end</font></b>;
        cmList: <b><font color="0000BB">begin</font></b>     <i><font color="#FFFF00">// Mache was mit cmList.</font></i>
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
