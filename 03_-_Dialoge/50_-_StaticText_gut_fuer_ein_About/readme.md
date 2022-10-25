# 03 - Dialoge
## 50 - StaticText gut fuer ein About
<img src="image.png" alt="Selfhtml"><br><br>
Hier wird ein About-Dialog erstellt, das sieht man gut für was man Label gebrauchen kann.<br>
<hr><br>
Die Datei, in welcher sich die Daten für den Dialog befinden.<br>
<pre><code=pascal><b><font color="0000BB">const</font></b>
  DialogDatei = <font color="#FF0000">'parameter.cfg'</font>;</code></pre>
Eine neue Funktion <b>About</b> ist hinzugekommen.<br>
<pre><code=pascal><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    ParameterData: TParameterData;                     <i><font color="#FFFF00">// Parameter für Dialog.</font></i>
    fParameterData: <b><font color="0000BB">file</font></b> <b><font color="0000BB">of</font></b> TParameterData;            <i><font color="#FFFF00">// File-Hander füe das speichern/laden der Daten des Dialoges.</font></i>
<br>
    <b><font color="0000BB">constructor</font></b> Init;                                  <i><font color="#FFFF00">// Neuer Constructor</font></i>
<br>
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;                 <i><font color="#FFFF00">// Statuszeile</font></i>
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Menü</font></i>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// Eventhandler</font></i>
    <b><font color="0000BB">procedure</font></b> OutOfMemory; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Wird aufgerufen, wen Speicher überläuft.</font></i>
<br>
    <b><font color="0000BB">procedure</font></b> MyParameter;                             <i><font color="#FFFF00">// neue Funktion für einen Dialog.</font></i>
    <b><font color="0000BB">procedure</font></b> About;                                   <i><font color="#FFFF00">// About Dialog.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Hier wird das About augerufen, wen im Menü About gewält wird.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmAbout: <b><font color="0000BB">begin</font></b>
          About;   <i><font color="#FFFF00">// About Dialog aufrufen</font></i>
        <b><font color="0000BB">end</font></b>;
        cmList: <b><font color="0000BB">begin</font></b>
        <b><font color="0000BB">end</font></b>;
        cmPara: <b><font color="0000BB">begin</font></b>
          MyParameter;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
About Dialog erstellen.<br>
Mit <b>TRext.Grow(...</b> kann man das Rect verkleinern und vergrössern.<br>
Mit <b>#13</b> kann man eine Zeilenumbruch einfügen.<br>
Mit <b>#3</b> wird der Text horizontal im Rect zentriert.<br>
Mit <b>#2</b> wird der Text rechtbündig geschrieben.<br>
<br>
Mit <b>PLabel</b> könnte man auch Text ausgeben, aber für festen Text eignet sich <b>PStaticText</b> besser.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.About;
  <b><font color="0000BB">var</font></b>
    Dlg: PDialog;
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">42</font>, <font color="#0077BB">11</font>);
    R.Move(<font color="#0077BB">1</font>, <font color="#0077BB">1</font>);
    Dlg := <b><font color="0000BB">New</font></b>(PDialog, Init(R, <font color="#FF0000">'About'</font>));
    <b><font color="0000BB">with</font></b> Dlg^ <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
      Options := Options <b><font color="0000BB">or</font></b> ofCentered; <i><font color="#FFFF00">// Dialog zentrieren</font></i>
<br>
      <i><font color="#FFFF00">// StaticText einfügen.</font></i>
      R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">2</font>, <font color="#0077BB">40</font>, <font color="#0077BB">8</font>);
      Insert(<b><font color="0000BB">New</font></b>(PStaticText, Init(R,
        <font color="#FF0000">#13</font> +
        <font color="#FF0000">'Free Vison Tutorial 1.0'</font> + <font color="#FF0000">#13</font> +
        <font color="#FF0000">'2017'</font> + <font color="#FF0000">#13</font> +
        <font color="#FF0000">#3</font> + <font color="#FF0000">'Zentriert'</font> + <font color="#FF0000">#13</font> +
        <font color="#FF0000">#2</font> + <font color="#FF0000">'Rechts'</font>)));
      R.Assign(<font color="#0077BB">16</font>, <font color="#0077BB">8</font>, <font color="#0077BB">26</font>, <font color="#0077BB">10</font>);
      Insert(<b><font color="0000BB">New</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
    <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">if</font></b> ValidView(Dlg) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.ExecView(Dlg);           <i><font color="#FFFF00">// Modal aufrufen, Funktionsergebniss wird nicht ausgewrtet.</font></i>
      <b><font color="0000BB">Dispose</font></b>(Dlg, Done);               <i><font color="#FFFF00">// Dialog frei geben.</font></i>
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
