# 19 - Optische-Gestaltung
## 15 --Hintergrund auf Dialog
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Bei Bedarf, kann man auch ein Hintergrund-Muster auf einen Dialog/Fenster legen.<br>
<hr><br>
Hier wird der <b>PBackGround</b> auf einen Dialog gelegt, dies funktioniert genau gleich, wie auf dem Desktop.<br>
Dies kann auch der benutzerdefiniert <b>PMyBackground</b> sein.<br>
<b>Wichtig</b> ist, der Background <b>MUSS</b> zuerst in den Dialog eingefügt werden,<br>
ansonsten übermahlt er die anderen Komponenten.<br>
<pre><code=pascal>  procedure TMyApp.MyOption;
  var
    Dlg: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 35, 15);</font>
    R.Move(23, 3);</font>
    Dlg := New(PDialog, Init(R, 'Parameter'));</font>
<br>
    with Dlg^ do begin
<br>
      // BackGround --> Immer zuerst
      GetExtent(R);
      R.Grow(-1, -1);</font>
      Insert(New(PBackGround, Init(R, #3)));  // Hintergrund einfügen.</font>
<br>
      // Ok-Button
      R.Assign(20, 11, 30, 13);</font>
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
    end;
<br>
    if ValidView(Dlg) <> nil then begin
      Desktop^.ExecView(Dlg);
      Dispose(Dlg, Done);
    end;
  end;</code></pre>
<br>
