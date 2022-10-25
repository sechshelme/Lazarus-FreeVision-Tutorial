# 20 - Diverses
## 10 - InputLine Validate
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Hier wird eine Bereichsbegrenzung für <b>PInputLine</b> gezeigt.<br>
Bei der ersten Zeile ist nur eine Zahl zwischen 0 und 99 erlaubt.<br>
Bei der zweiten Zeile muss es ein Wochentag ( Montag - Freitag ) sein.<br>
Für den zweiten Fall wäre eine ListBox idealer, mir geht zum zeigen wie es mit der <b>PInputLine</b> geht.<br>
---
<br>
---
<br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Ein Dialog mit <b>PInputLine</b> welche eine Prüfung bekommen.<br>
Wen man <b>Ok</b> drückt, wird ein Validate-Prüfungen ausgeführt.<br>
Bei <b>Abbruch</b> gibt es keine Prüfung.<br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Die Deklaration des Dialoges, hier wird nur das Init überschrieben, welches die Komponenten, für den Dialog erzeugt.<br>
So nebenbei werden noch die beiden Validate überschrieben.<br>
Dies wird nur gemacht, das eine deutsche Fehlermeldung bei falscher Eingabe kommt.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyDialog = ^TMyDialog;
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
    <b><font color="0000BB">constructor</font></b> Init;
  <b><font color="0000BB">end</font></b>;
<br>
  PMyRangeValidator = ^TMyRangeValidator;
  TMyRangeValidator = <b><font color="0000BB">object</font></b>(TRangeValidator)
    <b><font color="0000BB">procedure</font></b> Error; <b><font color="0000BB">Virtual</font></b>;   <i><font color="#FFFF00">// Überschreibt die englische Fehlermeldung.</font></i>
  <b><font color="0000BB">end</font></b>;
<br>
  PMyStringLookUpValidator = ^TMyStringLookUpValidator;
  TMyStringLookUpValidator = <b><font color="0000BB">object</font></b>(TStringLookUpValidator)
    <b><font color="0000BB">procedure</font></b> Error; <b><font color="0000BB">Virtual</font></b>;   <i><font color="#FFFF00">// Überschreibt die englische Fehlermeldung.</font></i>
  <b><font color="0000BB">end</font></b>;
</code></pre>
Die beiden neuen Fehlermeldungen.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyRangeValidator.Error;
<b><font color="0000BB">var</font></b>
  Params: <b><font color="0000BB">array</font></b>[<font color="#0077BB">0</font>..<font color="#0077BB">1</font>] <b><font color="0000BB">Of</font></b> Longint;
<b><font color="0000BB">begin</font></b>
  Params[<font color="#0077BB">0</font>] := Min;
  Params[<font color="#0077BB">1</font>] := Max;
  MessageBox(<font color="#FF0000">'Wert nicht im Bereich %d bis %d'</font>, @Params, mfError <b><font color="0000BB">or</font></b> mfOKButton);
<b><font color="0000BB">end</font></b>;
<br>
<b><font color="0000BB">procedure</font></b> TMyStringLookUpValidator.Error;
<b><font color="0000BB">begin</font></b>
  MessageBox(<font color="#FF0000">'Eingabe nicht <b><font color="0000BB">in</font></b> g'</font><font color="#FF0000">#129</font><font color="#FF0000">'ltiger Liste'</font>, <b><font color="0000BB">nil</font></b>, mfError <b><font color="0000BB">or</font></b> mfOKButton);
<b><font color="0000BB">end</font></b>;
</code></pre>
Hier sieht man, das eine Validate-Prüfung zu den <b>PInputLines</b> dazu kommt.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyDialog.Init;
<b><font color="0000BB">const</font></b>
  <i><font color="#FFFF00">// Wochentage, als String, welche in der PInputLine erlaubt sind.</font></i>
  WochenTag:<b><font color="0000BB">array</font></b>[<font color="#0077BB">0</font>..<font color="#0077BB">6</font>] <b><font color="0000BB">of</font></b> <b><font color="0000BB">String</font></b> = (<font color="#FF0000">'Montag'</font>, <font color="#FF0000">'Dienstag'</font>, <font color="#FF0000">'Mittwoch'</font>, <font color="#FF0000">'Donnerstag'</font>, <font color="#FF0000">'Freitag'</font>, <font color="#FF0000">'Samstag'</font>, <font color="#FF0000">'Sonntag'</font>);
<b><font color="0000BB">var</font></b>
  R: TRect;
  i: Integer;
  InputLine: PInputLine;               <i><font color="#FFFF00">// Die Eingabe Zeilen.</font></i>
  StringCollektion: PStringCollection; <i><font color="#FFFF00">// Stringliste, welche die erlaubten Strings enthält.</font></i>
<b><font color="0000BB">begin</font></b>
  <i><font color="#FFFF00">// Der Dialog selbst.</font></i>
  R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">42</font>, <font color="#0077BB">11</font>);
  R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'Validate'</font>);
<br>
  <i><font color="#FFFF00">// --- InputLine mit Bereichsbegrenzung 0-99.</font></i>
  R.Assign(<font color="#0077BB">25</font>, <font color="#0077BB">2</font>, <font color="#0077BB">36</font>, <font color="#0077BB">3</font>);
  InputLine := <b><font color="0000BB">new</font></b>(PInputLine, Init(R, <font color="#0077BB">6</font>));
  <i><font color="#FFFF00">// Validate-Prüfung 0-99.</font></i>
  InputLine^.SetValidator(<b><font color="0000BB">new</font></b>(PMyRangeValidator, Init(<font color="#0077BB">0</font>, <font color="#0077BB">99</font>)));
  Insert(InputLine);
  R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">2</font>, <font color="#0077BB">22</font>, <font color="#0077BB">3</font>);
  Insert(<b><font color="0000BB">New</font></b>(PLabel, Init(R, <font color="#FF0000">'~B~ereich: 0-99'</font>, InputLine)));
<br>
  <i><font color="#FFFF00">// --- Wochentage</font></i>
  <i><font color="#FFFF00">// Stringliste erzeugen.</font></i>
  StringCollektion := <b><font color="0000BB">new</font></b>(PStringCollection, Init(<font color="#0077BB">10</font>, <font color="#0077BB">2</font>));
  <i><font color="#FFFF00">// Stringliste mit den Wochentagen laden.</font></i>
  <b><font color="0000BB">for</font></b> i := <font color="#0077BB">0</font> <b><font color="0000BB">to</font></b> <font color="#0077BB">6</font> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
    StringCollektion^.Insert(NewStr(WochenTag[i]));
  <b><font color="0000BB">end</font></b>;
  R.Assign(<font color="#0077BB">25</font>, <font color="#0077BB">4</font>, <font color="#0077BB">36</font>, <font color="#0077BB">5</font>);
  InputLine := <b><font color="0000BB">new</font></b>(PInputLine, Init(R, <font color="#0077BB">10</font>));
  <i><font color="#FFFF00">// Überprüfung mit der Stringliste.</font></i>
  InputLine^.SetValidator(<b><font color="0000BB">new</font></b>(PMyStringLookUpValidator, Init(StringCollektion)));
  Insert(InputLine);
  R.Assign(<font color="#0077BB">2</font>, <font color="#0077BB">4</font>, <font color="#0077BB">22</font>, <font color="#0077BB">5</font>);
  Insert(<b><font color="0000BB">New</font></b>(PLabel, Init(R, <font color="#FF0000">'~W~ochentage:'</font>, InputLine)));
<br>
  <i><font color="#FFFF00">// ---Ok-Button</font></i>
  R.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">8</font>, <font color="#0077BB">19</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<br>
  <i><font color="#FFFF00">// --- Abbrechen-Button</font></i>
  R.Assign(<font color="#0077BB">24</font>, <font color="#0077BB">8</font>, <font color="#0077BB">36</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~A~bbrechen'</font>, cmCancel, bfNormal)));
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
