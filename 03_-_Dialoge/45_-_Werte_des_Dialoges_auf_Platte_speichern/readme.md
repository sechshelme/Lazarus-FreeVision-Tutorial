# 03 - Dialoge
## 45 - Werte des Dialoges auf Platte speichern
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Das die Werte des Dialoges auch nach beenden der Anwendung erhalten bleiben, speichern wir die Daten auf die Platte.<br>
Es wird nicht überprüft, ob geschrieben werden kann, etc.<br>
Wen man dies will müsste man mit <b>IOResult</b>, etc. überprüfen.<br>
<hr><br>
Hier kommt noch <b>sysutils</b> hinzu, sie wird für <b>FileExits</b> gebraucht.<br>
<pre><code=pascal>uses
  SysUtils, // Für Dateioperationen</code></pre>
Die Datei, in welcher sich die Daten für den Dialog befinden.<br>
<pre><code=pascal>const
  DialogDatei = 'parameter.cfg';</font></code></pre>
Zu Beginn werden die Daten, wen vorhaden von der Platte geladen, ansonten werden sie erzeugt.<br>
<pre><code=pascal>  constructor TMyApp.Init;
  begin
    inherited Init;
    // Prüfen ob Datei vorhanden.
    if FileExists(DialogDatei) then begin
      // Daten von Platte laden.
      AssignFile(fParameterData, DialogDatei);
      Reset(fParameterData);
      Read(fParameterData, ParameterData);
      CloseFile(fParameterData);
      // ansonsten Default-Werte nehmen.
    end else begin
      with ParameterData do begin
        Druck := %0101;</font>
        Schrift := 2;</font>
        Hinweis := 'Hello world !';</font>
      end;
    end;
  end;</code></pre>
Die Daten werden auf die Platte gespeichert, wen <b>Ok</b> gedrückt wird.<br>
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
    if ValidView(Dlg) <> nil then begin // Prüfen ob genügend Speicher.
      Dlg^.SetData(ParameterData);      // Dialog mit den Werten laden.
      dummy := Desktop^.ExecView(Dlg);  // Dialog ausführen.
      if dummy = cmOK then begin        // Wen Dialog mit Ok beenden, dann Daten vom Dialog in Record laden.
        Dlg^.GetData(ParameterData);
<br>
        // Daten auf Platte speichern.
        AssignFile(fParameterData, DialogDatei);
        Rewrite(fParameterData);
        Write(fParameterData, ParameterData);
        CloseFile(fParameterData);
      end;
<br>
      Dispose(Dlg, Done);               // Dialog und Speicher frei geben.
    end;
  end;</code></pre>
<br>
