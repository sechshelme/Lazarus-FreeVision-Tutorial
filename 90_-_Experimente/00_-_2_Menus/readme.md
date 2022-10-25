# 90 - Experimente
## 00 - 2 Menus
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Dialog um Buttons ergänzen.<br>
<hr><br>
Den Dialog mit Buttons ergänzen.<br>
Mit <b>Insert</b> fügt man die Komponenten hinzug, in diesem Fall sind es die Buttons.<br>
Mit bfDefault legt man den Default-Button fest, dieser wird mit <b>[Enter]</b> aktiviert.<br>
bfNormal ist ein gewöhnlicher Button.<br>
Der Dialog wird nun Modal geöffnet, somit können <b>keine</b> weiteren Dialoge geöffnet werden.<br>
dummy hat den Wert, des Button der gedrückt wurde, dies entspricht dem <b>cmxxx</b> Wert.<br>
Die Höhe der Buttons muss immer <b>2</b> sein, ansonsten gibt es eine fehlerhafte Darstellung.<br>
<pre><code=pascal>  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    R: TRect;
    dummy: word;
  begin
    R.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    R.Move(23, 3);                             // Position des Dialogs.
    Dia := New(PDialog, Init(R, 'Parameter')); // Dialog erzeugen.</font>
    with Dia^ do begin
<br>
      // Ok-Button
      R.Assign(7, 12, 17, 14);</font>
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
<br>
      // Schliessen-Button
      R.Assign(19, 12, 32, 14);</font>
      Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));</font>
    end;
    dummy := Desktop^.ExecView(Dia);   // Dialog Modal öffnen.
    Dispose(Dia, Done);                // Dialog und Speicher frei geben.
  end;</code></pre>
<br>
