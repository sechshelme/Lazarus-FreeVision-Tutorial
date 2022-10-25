# 90 - Experimente
## 20 - Einfache MessageBox mit Dlg
<img src="image.png" alt="Selfhtml"><br><br>
Bei der MessageBox, kann man die Grösse auch manuell festlegen.<br>
Dazu muss man <b>MeassgeBoxRect(...)</b> verwenden.<br>
---
Hier wird mir <b>R.Assign</b> die grösse der Box selbst festgelegt.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    R: TRect;
    Dlg: PDialog;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmAbout: <b><font color="0000BB">begin</font></b>
          R.Assign(<font color="#0077BB">12</font>, <font color="#0077BB">3</font>, <font color="#0077BB">58</font>, <font color="#0077BB">20</font>);  <i><font color="#FFFF00">// Grösse der Box</font></i>
          Dlg := <b><font color="0000BB">New</font></b>(PDialog, Init(R, <font color="#FF0000">'Parameter'</font>));
          <b><font color="0000BB">with</font></b> Dlg^ <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
<br>
            <i><font color="#FFFF00">// CheckBoxen</font></i>
            R.Assign(<font color="#0077BB">4</font>, <font color="#0077BB">3</font>, <font color="#0077BB">18</font>, <font color="#0077BB">7</font>);
            Insert(<b><font color="0000BB">New</font></b>(PCheckBoxes, Init(R, NewSItem(<font color="#FF0000">'~D~atei'</font>, NewSItem(<font color="#FF0000">'~Z~eile'</font>,
              NewSItem(<font color="#FF0000">'D~a~tum'</font>, NewSItem(<font color="#FF0000">'~Z~eit'</font>, <b><font color="0000BB">nil</font></b>)))))));
<br>
            <i><font color="#FFFF00">// BackGround</font></i>
            GetExtent(R);
            R.Grow(-<font color="#0077BB">1</font>, -<font color="#0077BB">1</font>);
<i><font color="#FFFF00">//            Insert(New(PBackGround, Init(R, #3)));  // Hintergrund einfügen.</font></i>
<br>
            <i><font color="#FFFF00">// My-Button</font></i>
            R.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">12</font>, <font color="#0077BB">17</font>, <font color="#0077BB">14</font>);
            Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~M~yButton'</font>, cmMyBotton, bfDefault)));
<br>
          <b><font color="0000BB">end</font></b>;
<br>

          R.Assign(<font color="#0077BB">22</font>, <font color="#0077BB">3</font>, <font color="#0077BB">42</font>, <font color="#0077BB">10</font>);  <i><font color="#FFFF00">// Grösse der Box</font></i>
          MessageBoxRectDlg(Dlg, R, <font color="#FF0000">'Ich bin eine vorgegebene Box'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfYesButton + mfNoButton);
          <b><font color="0000BB">Dispose</font></b>(Dlg, Done);
        <b><font color="0000BB">end</font></b>;
        cmMyBotton: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Eigener Button gedrückt'</font>, <b><font color="0000BB">nil</font></b>, mfInformation);
<br>
        <b><font color="0000BB">end</font></b>
<br>

        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;</code></pre>
<br>
