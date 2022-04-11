<html>
    <b><h1>04 Dialoge als Komponente</h1></b>
    <b><h2>02 Dialog mit lokalem Ereigniss</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
In den vererbten Dialogen ist es möglich Buttons einzubauen, welche lokal im Dialog eine Aktion ausführen.<br>
Im Beispiel wir eine MessageBox aufgerufen.<br>
<hr><br>
Im Hauptprogramm ändert sich nichts daran, dem ist egal, ob lokal noch etwas gemacht wird.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    AboutDialog: PMyAbout;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>                   <i><font color="#FFFF00">// About Dialog</font></i>
        cmAbout: <b><font color="0000BB">begin</font></b>
          AboutDialog := <b><font color="0000BB">New</font></b>(PMyAbout, Init);
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
<br><br>
Dort sieht man gut, das es ein Button für lokale Ereignisse hat.<br>
Wichtig ist, bei den Nummernvergabe, das sich dies nicht mit einem anderen Eventnummer überschneidet.<br>
Vor allem dann, wen der Dialog nicht Modal geöffnet wird.<br>
Ausser es ist gewünscht, wen man zB. über das Menü auf den Dialog zugreifen will.<br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Für den Dialog kommt noch ein HandleEvent hinzu.<br>
<pre><code><b><font color="0000BB">const</font></b>
    cmMsg = <font color="#0077BB">1003</font>;  <i><font color="#FFFF00">//</font></i>
<br>
<b><font color="0000BB">type</font></b>
  PMyAbout = ^TMyAbout;
  TMyAbout = <b><font color="0000BB">object</font></b>(TDialog)
<br>
    <b><font color="0000BB">constructor</font></b> Init;
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstruktor wird der Dialog noch um den Button Msg-box ergänzt, welcher das lokale Ereigniss <b>cmMsg</b> abarbeitet.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyAbout.Init;
<b><font color="0000BB">var</font></b>
  Rect: TRect;
<b><font color="0000BB">begin</font></b>
  Rect.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">42</font>, <font color="#0077BB">11</font>);
  Rect.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
  <b><font color="0000BB">inherited</font></b> Init(Rect, <font color="#FF0000">'About'</font>);
<br>
  <i><font color="#FFFF00">// StaticText</font></i>
  Rect.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">2</font>, <font color="#0077BB">41</font>, <font color="#0077BB">8</font>);
  Insert(<b><font color="0000BB">new</font></b>(PStaticText, Init(Rect,
    <font color="#FF0000">'Free Vison Tutorial 1.0'</font> + <font color="#FF0000">#13</font> +
    <font color="#FF0000">'2017'</font> + <font color="#FF0000">#13</font> +
    <font color="#FF0000">'Gechrieben von M. Burkhard'</font>+ <font color="#FF0000">#13#32#13</font> +
    <font color="#FF0000">'FPC: '</font>+ <font color="#FFFF00">{$I %FPCVERSION%}</font> + <font color="#FF0000">'   OS:'</font>+ <font color="#FFFF00">{$I %FPCTARGETOS%}</font> + <font color="#FF0000">'   CPU:'</font> + <font color="#FFFF00">{$I %FPCTARGETCPU%}</font>)));
<br>
  <i><font color="#FFFF00">// MessageBox-Button, mit lokalem Ereigniss.</font></i>
  Rect.Assign(<font color="#0077BB">19</font>, <font color="#0077BB">8</font>, <font color="#0077BB">32</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(Rect, <font color="#FF0000">'~M~sg-Box'</font>, cmMsg, bfNormal)));
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  Rect.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">8</font>, <font color="#0077BB">17</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(Rect, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
</code></pre>
Im neuen EventHandle, werden loake Ereigniss (cmMsg) abarbeitet.<br>
Andere Ereignisse, zB. <b>cmOk</b> wird an das Hauptprogramm weiter gereicht, welches dann den Dialog auch schliesst.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyAbout.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evCommand: <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        <i><font color="#FFFF00">// Lokales Ereigniss ausführen.</font></i>
        cmMsg: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Ich bin eine MessageBox !'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          ClearEvent(Event);  <i><font color="#FFFF00">// Event beenden.</font></i>
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;
<br>
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
</html>
