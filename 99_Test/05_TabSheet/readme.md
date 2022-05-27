<html>
    <b><h1>99 Test</h1></b>
    <b><h2>05 TabSheet</h2></b>
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
<br>
  TMyAbout = <b><font color="0000BB">object</font></b>(TDialog)
<br>
    <b><font color="0000BB">constructor</font></b> Init;
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstruktor wird der Dialog noch um den Button Msg-box ergänzt, welcher das lokale Ereigniss <b>cmMsg</b> abarbeitet.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyAbout.Init;
<b><font color="0000BB">var</font></b>
  R: TRect;
  Tabdef: PTabDef;
  Tab: PTab;
  bt0, bt1, bt2: PButton;
  Group: PGroup;
<b><font color="0000BB">begin</font></b>
  R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">42</font>, <font color="#0077BB">16</font>);
  R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'About'</font>);
<br>
  R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">4</font>, <font color="#0077BB">12</font>, <font color="#0077BB">6</font>);
  bt0 := <b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'bt~a~'</font>, cmValid, bfDefault));
  R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">6</font>, <font color="#0077BB">12</font>, <font color="#0077BB">8</font>);
  bt1 := <b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'bt~b~'</font>, cmValid, bfDefault));
  R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">8</font>, <font color="#0077BB">12</font>, <font color="#0077BB">19</font>);
  bt2 := <b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'bt~c~'</font>, cmValid, bfDefault));
<br>

  <i><font color="#FFFF00">// Tab</font></i>
  R.Assign(<font color="#0077BB">1</font>, <font color="#0077BB">1</font>, <font color="#0077BB">10</font>, <font color="#0077BB">5</font>);
  Group := <b><font color="0000BB">new</font></b>(PGroup, Init(R));
  Group^.BackgroundChar := <font color="#FF0000">'x'</font>;
<br>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">2</font>, <font color="#0077BB">41</font>, <font color="#0077BB">13</font>);
  Tabdef := NewTabDef(<font color="#FF0000">'Tab~1~'</font>, bt1, NewTabItem(bt0, NewTabItem(bt1, NewTabItem(bt2, <b><font color="0000BB">nil</font></b>))), NewTabDef(<font color="#FF0000">'Tab~2~'</font>, <b><font color="0000BB">nil</font></b>, <b><font color="0000BB">nil</font></b>, <b><font color="0000BB">nil</font></b>));
  Tab := <b><font color="0000BB">new</font></b>(PTab, Init(R, Tabdef));
<br>
  Insert(Tab);
<br>
  <i><font color="#FFFF00">// MessageBox-Button, mit lokalem Ereigniss.</font></i>
  R.Assign(<font color="#0077BB">19</font>, <font color="#0077BB">13</font>, <font color="#0077BB">32</font>, <font color="#0077BB">15</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~M~sg-Box'</font>, cmMsg, bfNormal)));
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  R.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">13</font>, <font color="#0077BB">17</font>, <font color="#0077BB">15</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
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
