# 03 - Dialoge
## 30 - InputLine (Edit-Zeile)
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Einfügen eine Edit-Zeile.<br>
<hr><br>
Die Check und Radio-GroupButton mit Label ergänzen.<br>
Dies funktioniert fast gleich, wie ein normales Label. einziger Unterschied, anstelle von <b>nil</b> gibt man den Pointer auf die Group mit.<br>
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
      R.Assign(<font color="#0077BB">3</font>,<font color="#0077BB">10</font>,<font color="#0077BB">32</font>,<font color="#0077BB">11</font>);
      View:=<b><font color="0000BB">New</font></b>(PInputLine,Init(R,<font color="#0077BB">50</font>));
      Insert(View);
      <i><font color="#FFFF00">// Label für Edit Zeile</font></i>
      R.Assign(<font color="#0077BB">2</font>,<font color="#0077BB">9</font>,<font color="#0077BB">10</font>,<font color="#0077BB">10</font>);
      Insert(<b><font color="0000BB">New</font></b>(PLabel,Init(R,<font color="#FF0000">'~H~inweis'</font>,View)));
<br>
      <i><font color="#FFFF00">// Ok-Button</font></i>
      R.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">12</font>, <font color="#0077BB">17</font>, <font color="#0077BB">14</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<br>
      <i><font color="#FFFF00">// Schliessen-Button</font></i>
      R.Assign(<font color="#0077BB">19</font>, <font color="#0077BB">12</font>, <font color="#0077BB">32</font>, <font color="#0077BB">14</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~A~bbruch'</font>, cmCancel, bfNormal)));
    <b><font color="0000BB">end</font></b>;
    dummy := Desktop^.ExecView(Dlg);   <i><font color="#FFFF00">// Dialog Modal öffnen.</font></i>
    <b><font color="0000BB">Dispose</font></b>(Dlg, Done);                <i><font color="#FFFF00">// Dialog und Speicher frei geben.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
