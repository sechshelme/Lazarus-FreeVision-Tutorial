# 03 - Dialoge
## 35 - Werte im Dialog merken
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Bis jetzt gingen die Werte im Dialog immer wieder verloren, wen man diesen schliesste und wieder öffnete.<br>
Aus diesem Grund werden jetzt die Werte in einen Record gespeichert.<br>
<hr><br>
  In diesem Record werden die Werte des Dialoges gespeichert.<br>
  Die Reihenfolge der Daten im Record <b>muss</b> genau gleich sein, wie bei der Erstellung der Komponenten, ansonten gibt es einen Kräsch.<br>
  Bei Turbo-Pascal musste ein <b>Word</b> anstelle von <b>LongWord</b> genommen werden, dies ist wichtig beim Portieren alter Anwendungen.<br>
<pre><code=pascal><b><font color="0000BB">type</font></b>
  TParameterData = <b><font color="0000BB">record</font></b>
    Druck,
    Schrift: longword;
    Hinweis: <b><font color="0000BB">string</font></b>[<font color="#0077BB">50</font>];
  <b><font color="0000BB">end</font></b>;</code></pre>
Hier wird noch der Constructor vererbt, diesen Nachkomme wird gebraucht um die Dialogdaten mit Standard Werte zu laden.<br>
<pre><code=pascal><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    ParameterData: TParameterData;                     <i><font color="#FFFF00">// Daten für Parameter-Dialog</font></i>
    <b><font color="0000BB">constructor</font></b> Init;                                  <i><font color="#FFFF00">// Neuer Constructor</font></i>
<br>
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;                 <i><font color="#FFFF00">// Statuszeile</font></i>
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Menü</font></i>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// Eventhandler</font></i>
<br>
    <b><font color="0000BB">procedure</font></b> MyParameter;                             <i><font color="#FFFF00">// neue Funktion für einen Dialog.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Der Constructoer welcher die Werte für den Dialog ladet.<br>
Die Datenstruktur für die RadioButtons ist einfach. 0 ist der erste Button, 1 der Zweite, 2 der Dritte, usw.<br>
Bei den Checkboxen macht man es am besten Binär. Im Beispiel werden der erste und dritte CheckBox gesetzt.<br>
<pre><code=pascal>  <b><font color="0000BB">constructor</font></b> TMyApp.Init;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> Init;     <i><font color="#FFFF00">// Vorfahre aufrufen</font></i>
    <b><font color="0000BB">with</font></b> ParameterData <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
      Druck := %<font color="#0077BB">0101</font>;
      Schrift := <font color="#0077BB">2</font>;
      Hinweis := <font color="#FF0000">'Hello world'</font>;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
Der Dialog wird jetzt mit Werten geladen.<br>
Dies macht man, sobald man fertig ist mit Komponenten ertstellen.<br>
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
    Dlg^.SetData(ParameterData);      <i><font color="#FFFF00">// Dialog mit den Werten laden.</font></i>
    dummy := Desktop^.ExecView(Dlg);  <i><font color="#FFFF00">// Dialog ausführen.</font></i>
    <b><font color="0000BB">if</font></b> dummy = cmOK <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>        <i><font color="#FFFF00">// Wen Dialog mit Ok beenden, dann Daten vom Dialog in Record laden.</font></i>
      Dlg^.GetData(ParameterData);
    <b><font color="0000BB">end</font></b>;
<br>
    <b><font color="0000BB">Dispose</font></b>(Dlg, Done);               <i><font color="#FFFF00">// Dialog und Speicher frei geben.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
