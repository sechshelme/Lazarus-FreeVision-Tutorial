<html>
    <b><h1>03 Dialoge</h1></b>
    <b><h2>40 Freien Speicher ueberpruefen</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Überprüfen ob genügend Speicher frei ist, um den Dialog zu erzeugen.<br>
Auf den heutigen Rechner wird die wohl nicht mehr der Fall sein, das der Speicher wegen eines Dialoges überläuft.<br>
<hr><br>
Die virtuelle Procedure <b>OutOfMemory</b>, wen doch mal der Speicher überläuft.<br>
Wen man diese Methode nicht überschreibt, dann wird keine Fehlermeldung ausgegeben, nur weis dann der Nutzer nicht, wieso sein View nicht erscheint.<br>
<pre><code><b><font color="0000BB">type</font></b>
  TMyApp = <b><font color="0000BB">object</font></b>(TApplication)
    ParameterData: TParameterData;                     <i><font color="#FFFF00">// Parameter für Dialog.</font></i>
    <b><font color="0000BB">constructor</font></b> Init;                                  <i><font color="#FFFF00">// Neuer Constructor</font></i>
<br>
    <b><font color="0000BB">procedure</font></b> InitStatusLine; <b><font color="0000BB">virtual</font></b>;                 <i><font color="#FFFF00">// Statuszeile</font></i>
    <b><font color="0000BB">procedure</font></b> InitMenuBar; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Menü</font></i>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>; <i><font color="#FFFF00">// Eventhandler</font></i>
    <b><font color="0000BB">procedure</font></b> OutOfMemory; <b><font color="0000BB">virtual</font></b>;                    <i><font color="#FFFF00">// Wird aufgerufen, wen Speicher überläuft.</font></i>
<br>
    <b><font color="0000BB">procedure</font></b> MyParameter;                             <i><font color="#FFFF00">// neue Funktion für einen Dialog.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
Die Procedure wird aufgerufen, wen zu wenig Speicher vorhanden ist.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.OutOfMemory;
  <b><font color="0000BB">begin</font></b>
    MessageBox(<font color="#FF0000">'Zu wenig Arbeitsspeicher !'</font>, <b><font color="0000BB">nil</font></b>, mfError + mfOkButton);
  <b><font color="0000BB">end</font></b>;</code></pre>
Der Dialog wird jetzt mit Werten geladen.<br>
Dies macht man, sobald man fertig ist mit Komponenten ertstellen.<br>
Mit <b>ValidView(...</b> prüft man ob genügend Specher vorhanden ist, um die Komponente zu erzeugen.<br>
Wen nicht, kommt <b>nil<(b> zurück. Dabei spielt es keine Rolle, ob man <b>OutOfMemory</b> überschreibt.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.MyParameter;
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
      <b><font color="0000BB">end</font></b>;
<br>
      <b><font color="0000BB">Dispose</font></b>(Dlg, Done);               <i><font color="#FFFF00">// Dialog und Speicher frei geben.</font></i>
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>