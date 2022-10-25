# 03 - Dialoge
## 45 - Werte des Dialoges auf Platte speichern
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Das die Werte des Dialoges auch nach beenden der Anwendung erhalten bleiben, speichern wir die Daten auf die Platte.<br>
Es wird nicht überprüft, ob geschrieben werden kann, etc.<br>
Wen man dies will müsste man mit <b>IOResult</b>, etc. überprüfen.<br>
---
<br>
Hier kommt noch <b>sysutils</b> hinzu, sie wird für <b>FileExits</b> gebraucht.<br>
<pre><code=pascal><b><font color="0000BB">uses</font></b>
  SysUtils, <i><font color="#FFFF00">// Für Dateioperationen</font></i></code></pre>
Die Datei, in welcher sich die Daten für den Dialog befinden.<br>
<pre><code=pascal><b><font color="0000BB">const</font></b>
  DialogDatei = <font color="#FF0000">'parameter.cfg'</font>;</code></pre>
Zu Beginn werden die Daten, wen vorhaden von der Platte geladen, ansonten werden sie erzeugt.<br>
<pre><code=pascal>  <b><font color="0000BB">constructor</font></b> TMyApp.Init;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> Init;
    <i><font color="#FFFF00">// Prüfen ob Datei vorhanden.</font></i>
    <b><font color="0000BB">if</font></b> FileExists(DialogDatei) <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <i><font color="#FFFF00">// Daten von Platte laden.</font></i>
      AssignFile(fParameterData, DialogDatei);
      Reset(fParameterData);
      <b><font color="0000BB">Read</font></b>(fParameterData, ParameterData);
      CloseFile(fParameterData);
      <i><font color="#FFFF00">// ansonsten Default-Werte nehmen.</font></i>
    <b><font color="0000BB">end</font></b> <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">with</font></b> ParameterData <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
        Druck := %<font color="#0077BB">0101</font>;
        Schrift := <font color="#0077BB">2</font>;
        Hinweis := <font color="#FF0000">'Hello world !'</font>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
Die Daten werden auf die Platte gespeichert, wen <b>Ok</b> gedrückt wird.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.MyParameter;
  <b><font color="0000BB">var</font></b>
    Dlg: PDialog;
    R: TRect;
    dummy: word;
    View: PView;
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">35</font>, <font color="#0077BB">15</font>);
    R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
    Dlg := <b><font color="0000BB">New</font></b>(PDialog, Init(R, <font color="#FF0000">'Parameter'</font>));
    <b><font color="0000BB">with</font></b> Dlg^ <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
<br>
      <i><font color="#FFFF00">// CheckBoxen</font></i>
      R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">3</font>, <font color="#0077BB">18</font>, <font color="#0077BB">7</font>);
      View := <b><font color="0000BB">New</font></b>(PCheckBoxes, Init(R,
        NewSItem(<font color="#FF0000">'~D~atei'</font>,
        NewSItem(<font color="#FF0000">'~Z~eile'</font>,
        NewSItem(<font color="#FF0000">'D~a~tum'</font>,
        NewSItem(<font color="#FF0000">'~Z~eit'</font>,
        <b><font color="0000BB">nil</font></b>))))));
      Insert(View);
      <i><font color="#FFFF00">// Label für CheckGroup.</font></i>
      R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">2</font>, <font color="#0077BB">10</font>, <font color="#0077BB">3</font>);
      Insert(<b><font color="0000BB">New</font></b>(PLabel, Init(R, <font color="#FF0000">'Dr~u~cken'</font>, View)));
<br>
      <i><font color="#FFFF00">// RadioButton</font></i>
      R.Assign(<font color="#0077BB">21</font>, <font color="#0077BB">3</font>, <font color="#0077BB">33</font>, <font color="#0077BB">6</font>);
      View := <b><font color="0000BB">New</font></b>(PRadioButtons, Init(R,
        NewSItem(<font color="#FF0000">'~G~ross'</font>,
        NewSItem(<font color="#FF0000">'~M~ittel'</font>,
        NewSItem(<font color="#FF0000">'~K~lein'</font>,
        <b><font color="0000BB">nil</font></b>)))));
      Insert(View);
      <i><font color="#FFFF00">// Label für RadioGroup.</font></i>
      R.Assign(<font color="#0077BB">20</font>, <font color="#0077BB">2</font>, <font color="#0077BB">31</font>, <font color="#0077BB">3</font>);
      Insert(<b><font color="0000BB">New</font></b>(PLabel, Init(R, <font color="#FF0000">'~S~chrift'</font>, View)));
<br>
      <i><font color="#FFFF00">// Edit Zeile</font></i>
      R.Assign(<font color="#0077BB">3</font>, <font color="#0077BB">10</font>, <font color="#0077BB">32</font>, <font color="#0077BB">11</font>);
      View := <b><font color="0000BB">New</font></b>(PInputLine, Init(R, <font color="#0077BB">50</font>));
      Insert(View);
      <i><font color="#FFFF00">// Label für Edit Zeile</font></i>
      R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">9</font>, <font color="#0077BB">10</font>, <font color="#0077BB">10</font>);
      Insert(<b><font color="0000BB">New</font></b>(PLabel, Init(R, <font color="#FF0000">'~H~inweis'</font>, View)));
<br>
      <i><font color="#FFFF00">// Ok-Button</font></i>
      R.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">12</font>, <font color="#0077BB">17</font>, <font color="#0077BB">14</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<br>
      <i><font color="#FFFF00">// Schliessen-Button</font></i>
      R.Assign(<font color="#0077BB">19</font>, <font color="#0077BB">12</font>, <font color="#0077BB">32</font>, <font color="#0077BB">14</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~A~bbruch'</font>, cmCancel, bfNormal)));
    <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">if</font></b> ValidView(Dlg) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b> <i><font color="#FFFF00">// Prüfen ob genügend Speicher.</font></i>
      Dlg^.SetData(ParameterData);      <i><font color="#FFFF00">// Dialog mit den Werten laden.</font></i>
      dummy := Desktop^.ExecView(Dlg);  <i><font color="#FFFF00">// Dialog ausführen.</font></i>
      <b><font color="0000BB">if</font></b> dummy = cmOK <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>        <i><font color="#FFFF00">// Wen Dialog mit Ok beenden, dann Daten vom Dialog in Record laden.</font></i>
        Dlg^.GetData(ParameterData);
<br>
        <i><font color="#FFFF00">// Daten auf Platte speichern.</font></i>
        AssignFile(fParameterData, DialogDatei);
        Rewrite(fParameterData);
        <b><font color="0000BB">Write</font></b>(fParameterData, ParameterData);
        CloseFile(fParameterData);
      <b><font color="0000BB">end</font></b>;
<br>
      <b><font color="0000BB">Dispose</font></b>(Dlg, Done);               <i><font color="#FFFF00">// Dialog und Speicher frei geben.</font></i>
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
