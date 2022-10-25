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
<pre><code=pascal>type
  TParameterData = record
    Druck,
    Schrift: longword;
    Hinweis: string[50];</font>
  end;</code></pre>
Hier wird noch der Constructor vererbt, diesen Nachkomme wird gebraucht um die Dialogdaten mit Standard Werte zu laden.<br>
<pre><code=pascal>type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Daten für Parameter-Dialog
    constructor Init;                                  // Neuer Constructor
<br>
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
<br>
    procedure MyParameter;                             // neue Funktion für einen Dialog.
  end;</code></pre>
Der Constructoer welcher die Werte für den Dialog ladet.<br>
Die Datenstruktur für die RadioButtons ist einfach. 0 ist der erste Button, 1 der Zweite, 2 der Dritte, usw.<br>
Bei den Checkboxen macht man es am besten Binär. Im Beispiel werden der erste und dritte CheckBox gesetzt.<br>
<pre><code=pascal>  constructor TMyApp.Init;
  begin
    inherited Init;     // Vorfahre aufrufen
    with ParameterData do begin
      Druck := %0101;</font>
      Schrift := 2;</font>
      Hinweis := 'Hello world';</font>
    end;
  end;</code></pre>
Der Dialog wird jetzt mit Werten geladen.<br>
Dies macht man, sobald man fertig ist mit Komponenten ertstellen.<br>
<pre><code=pascal>  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
    dummy: word;
    View: PView;
  begin
    R.Assign(0, 0, 35, 15);</font>
    R.Move(23, 3);</font>
    Dlg := New(PDialog, Init(R, 'Parameter'));</font>
    with Dlg^ do begin
<br>
      // CheckBoxen
      R.Assign(2, 3, 18, 7);</font>
      View := New(PCheckBoxes, Init(R,
        NewSItem('~D~atei',</font>
        NewSItem('~Z~eile',</font>
        NewSItem('D~a~tum',</font>
        NewSItem('~Z~eit',</font>
        nil))))));
      Insert(View);
      // Label für CheckGroup.
      R.Assign(2, 2, 10, 3);</font>
      Insert(New(PLabel, Init(R, 'Dr~u~cken', View)));</font>
<br>
      // RadioButton
      R.Assign(21, 3, 33, 6);</font>
      View := New(PRadioButtons, Init(R,
        NewSItem('~G~ross',</font>
        NewSItem('~M~ittel',</font>
        NewSItem('~K~lein',</font>
        nil)))));
      Insert(View);
      // Label für RadioGroup.
      R.Assign(20, 2, 31, 3);</font>
      Insert(New(PLabel, Init(R, '~S~chrift', View)));</font>
<br>
      // Edit Zeile
      R.Assign(3, 10, 32, 11);</font>
      View := New(PInputLine, Init(R, 50));</font>
      Insert(View);
      // Label für Edit Zeile
      R.Assign(2, 9, 10, 10);</font>
      Insert(New(PLabel, Init(R, '~H~inweis', View)));</font>
<br>
      // Ok-Button
      R.Assign(7, 12, 17, 14);</font>
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
<br>
      // Schliessen-Button
      R.Assign(19, 12, 32, 14);</font>
      Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));</font>
    end;
    Dlg^.SetData(ParameterData);      // Dialog mit den Werten laden.
    dummy := Desktop^.ExecView(Dlg);  // Dialog ausführen.
    if dummy = cmOK then begin        // Wen Dialog mit Ok beenden, dann Daten vom Dialog in Record laden.
      Dlg^.GetData(ParameterData);
    end;
<br>
    Dispose(Dlg, Done);               // Dialog und Speicher frei geben.
  end;</code></pre>
<br>
