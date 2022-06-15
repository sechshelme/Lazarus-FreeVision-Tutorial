<html>
    <b><h1>04 - Dialoge als Komponente</h1></b>
    <b><h2>00 - Ein einfaches About</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Wen man immer wieder die gleichen Dialog braucht, packt man diesen am besten als Komponente in eine Unit.<br>
Dazu schreibt man einen Nachkommen von <b>TDialog</b>.<br>
Als Beispiel wird hier ein About-Dialog gebaut.<br>
<hr><br>
Hier wird der About-Dialog geladen und anschliessend bei Close wieder frei gegeben.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    AboutDialog: PMyAbout;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmAbout: <b><font color="0000BB">begin</font></b>
          AboutDialog := <b><font color="0000BB">New</font></b>(PMyAbout, Init);         <i><font color="#FFFF00">// Neurer Dialog erzeugen.</font></i>
          <b><font color="0000BB">if</font></b> ValidView(AboutDialog) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b> <i><font color="#FFFF00">// Prüfen ob genügend Speicher.</font></i>
            Desktop^.ExecView(AboutDialog);           <i><font color="#FFFF00">// Dialog About ausführen.</font></i>
            <b><font color="0000BB">Dispose</font></b>(AboutDialog, Done);               <i><font color="#FFFF00">// Dialog und Speicher frei geben.</font></i>
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Für den Dialog muss ein neuer Konstruktor erzeugt werden.<br>
Noch ein Hinweis zu StaticText, wen man eine Leerzeile einfügen will, muss man <b>#13#32#13</b> schreiben, bei <b>#13#13</b>, wird nur ein einfacher Zeilenumbruch ausgefühert.<br>
<pre><code><b><font color="0000BB">interface</font></b>
<br>
<b><font color="0000BB">uses</font></b>
  App, Objects, Drivers, Views, Dialogs;
<br>
<b><font color="0000BB">type</font></b>
  PMyAbout = ^TMyAbout;
  TMyAbout = <b><font color="0000BB">object</font></b>(TDialog)
    <b><font color="0000BB">constructor</font></b> Init;  <i><font color="#FFFF00">// Neuer Konstruktor, welche den Dialog mit den Komponenten baut.</font></i>
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstruktor werden die Dialog-Komponeten erzeugt.<br>
<pre><code><b><font color="0000BB">implementation</font></b>
<br>
<b><font color="0000BB">constructor</font></b> TMyAbout.Init;
<b><font color="0000BB">var</font></b>
  R: TRect;
<b><font color="0000BB">begin</font></b>
  R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">42</font>, <font color="#0077BB">11</font>);
  R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
<br>
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'About'</font>);  <i><font color="#FFFF00">// Dialog in verdefinierter Grösse erzeugen.</font></i>
<br>
  <i><font color="#FFFF00">// StaticText</font></i>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">2</font>, <font color="#0077BB">41</font>, <font color="#0077BB">8</font>);
  Insert(<b><font color="0000BB">new</font></b>(PStaticText, Init(R,
    <font color="#FF0000">'Free Vison Tutorial 1.0'</font> + <font color="#FF0000">#13</font> +
    <font color="#FF0000">'2017'</font> + <font color="#FF0000">#13</font> +
    <font color="#FF0000">'Gechrieben von M. Burkhard'</font> + <font color="#FF0000">#13#32#13</font> +
    <font color="#FF0000">'FPC: '</font>+ <font color="#FFFF00">{$I %FPCVERSION%}</font> + <font color="#FF0000">'   OS:'</font>+ <font color="#FFFF00">{$I %FPCTARGETOS%}</font> + <font color="#FF0000">'   CPU:'</font> + <font color="#FFFF00">{$I %FPCTARGETCPU%}</font>)));
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  R.Assign(<font color="#0077BB">27</font>, <font color="#0077BB">8</font>, <font color="#0077BB">37</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
</html>
