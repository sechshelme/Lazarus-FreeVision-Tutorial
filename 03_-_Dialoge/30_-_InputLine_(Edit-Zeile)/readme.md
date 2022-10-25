# 03 - Dialoge
## 30 - InputLine (Edit-Zeile)
<img src="image.png" alt="Selfhtml"><br><br>
Einfügen eine Edit-Zeile.<br>
---
Die Check und Radio-GroupButton mit Label ergänzen.<br>
Dies funktioniert fast gleich, wie ein normales Label. einziger Unterschied, anstelle von <b>nil</b> gibt man den Pointer auf die Group mit.<br>
```pascal>  procedure TMyApp.MyParameter;
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
      R.Assign(3,10,32,11);</font>
      View:=New(PInputLine,Init(R,50));</font>
      Insert(View);
      // Label für Edit Zeile
      R.Assign(2,9,10,10);</font>
      Insert(New(PLabel,Init(R,'~H~inweis',View)));</font>
<br>
      // Ok-Button
      R.Assign(7, 12, 17, 14);</font>
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
<br>
      // Schliessen-Button
      R.Assign(19, 12, 32, 14);</font>
      Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));</font>
    end;
    dummy := Desktop^.ExecView(Dlg);   // Dialog Modal öffnen.
    Dispose(Dlg, Done);                // Dialog und Speicher frei geben.
  end;```
<br>
