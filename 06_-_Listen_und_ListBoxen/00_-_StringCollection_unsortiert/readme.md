# 06 - Listen und ListBoxen
## 00 - StringCollection unsortiert
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Wen die Stringliste unsortiert bleiben soll, verwendet man <b>PUnSortedStrCollection</b>.<br>
Nur <b>PCollection</b> reicht <b>nicht</b>, da diese bei <b>Dispose</b> abschmiert.<br>
<hr><br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der UnSortedStrCollection.<br>
Deklaration des Dialog, nichts Besonderes.<br>
<pre><code>type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;
</code></pre>
Es wird eine UnSortedStrCollection gebaut und<br>
als Demonstration wird deren Inhalt in ein StaticText geschrieben.<br>
<pre><code>constructor TMyDialog.Init;
var
  R: TRect;
  s: shortstring;
  i: Integer;
  StringCollection: PUnSortedStrCollection;
<br>
const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');</font>
<br>
begin
  R.Assign(10, 5, 50, 19);</font>
  inherited Init(R, 'StringCollection Demo');</font>
<br>
  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));</font>
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;
  s := '';</font>
<br>
  for i := 0 to StringCollection^.Count - 1 do begin</font>
    s := s + PString(StringCollection^.At(i))^ + #13;</font>
  end;
<br>
  Dispose(StringCollection, Done); // Die Liste freigeben
<br>
  R.Assign(5, 2, 36, 12);</font>
  Insert(new(PStaticText, Init(R, s)));
<br>
  // Ok-Button
  R.Assign(5, 11, 18, 13);</font>
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
end;
</code></pre>
<br>
