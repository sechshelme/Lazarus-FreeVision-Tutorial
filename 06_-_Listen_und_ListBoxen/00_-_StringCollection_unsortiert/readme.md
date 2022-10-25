# 06 - Listen und ListBoxen
## 00 - StringCollection unsortiert
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Wen die Stringliste unsortiert bleiben soll, verwendet man <b>PUnSortedStrCollection</b>.<br>
Nur <b>PCollection</b> reicht <b>nicht</b>, da diese bei <b>Dispose</b> abschmiert.<br>
---
<br>
---
<br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der UnSortedStrCollection.<br>
Deklaration des Dialog, nichts Besonderes.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyDialog = ^TMyDialog;
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
    <b><font color="0000BB">constructor</font></b> Init;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Es wird eine UnSortedStrCollection gebaut und<br>
als Demonstration wird deren Inhalt in ein StaticText geschrieben.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyDialog.Init;
<b><font color="0000BB">var</font></b>
  R: TRect;
  s: shortstring;
  i: Integer;
  StringCollection: PUnSortedStrCollection;
<br>
<b><font color="0000BB">const</font></b>
  Tage: <b><font color="0000BB">array</font></b> [<font color="#0077BB">0</font>..<font color="#0077BB">6</font>] <b><font color="0000BB">of</font></b> shortstring = (
    <font color="#FF0000">'Montag'</font>, <font color="#FF0000">'Dienstag'</font>, <font color="#FF0000">'Mittwoch'</font>, <font color="#FF0000">'Donnerstag'</font>, <font color="#FF0000">'Freitag'</font>, <font color="#FF0000">'Samstag'</font>, <font color="#FF0000">'Sonntag'</font>);
<br>
<b><font color="0000BB">begin</font></b>
  R.Assign(<font color="#0077BB">10</font>, <font color="#0077BB">5</font>, <font color="#0077BB">50</font>, <font color="#0077BB">19</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'StringCollection Demo'</font>);
<br>
  <i><font color="#FFFF00">// StringCollection</font></i>
  StringCollection := <b><font color="0000BB">new</font></b>(PUnSortedStrCollection, Init(<font color="#0077BB">5</font>, <font color="#0077BB">5</font>));
  <b><font color="0000BB">for</font></b> i := <font color="#0077BB">0</font> <b><font color="0000BB">to</font></b> Length(Tage) - <font color="#0077BB">1</font> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
    StringCollection^.Insert(NewStr(Tage[i]));
  <b><font color="0000BB">end</font></b>;
  s := <font color="#FF0000">''</font>;
<br>
  <b><font color="0000BB">for</font></b> i := <font color="#0077BB">0</font> <b><font color="0000BB">to</font></b> StringCollection^.Count - <font color="#0077BB">1</font> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
    s := s + PString(StringCollection^.At(i))^ + <font color="#FF0000">#13</font>;
  <b><font color="0000BB">end</font></b>;
<br>
  <b><font color="0000BB">Dispose</font></b>(StringCollection, Done); <i><font color="#FFFF00">// Die Liste freigeben</font></i>
<br>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">2</font>, <font color="#0077BB">36</font>, <font color="#0077BB">12</font>);
  Insert(<b><font color="0000BB">new</font></b>(PStaticText, Init(R, s)));
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">11</font>, <font color="#0077BB">18</font>, <font color="#0077BB">13</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
