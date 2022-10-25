# 03 - Dialoge
## 20 - RadioButton
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Dialog um RadioButtons ergänzen.<br>
---
Das Menü wurde noch ein wenig geändert/ergänzt.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.InitMenuBar;
  <b><font color="0000BB">var</font></b>
    R: TRect;                          <i><font color="#FFFF00">// Rechteck für die Menüzeilen-Position.</font></i>
<br>
    M: PMenu;                          <i><font color="#FFFF00">// Ganzes Menü</font></i>
    SM0, SM1, SM2,                     <i><font color="#FFFF00">// Submenu</font></i>
    M0_0, M0_2, M0_3, M0_4, M0_5,
    M1_0, M2_0: PMenuItem;             <i><font color="#FFFF00">// Einfache Menüpunkte</font></i>
<br>
  <b><font color="0000BB">begin</font></b>
    GetExtent(R);
    R.B.Y := R.A.Y + <font color="#0077BB">1</font>;
<br>
    M2_0 := NewItem(<font color="#FF0000">'~A~bout...'</font>, <font color="#FF0000">''</font>, kbNoKey, cmAbout, hcNoContext, <b><font color="0000BB">nil</font></b>);
    SM2 := NewSubMenu(<font color="#FF0000">'~H~ilfe'</font>, hcNoContext, NewMenu(M2_0), <b><font color="0000BB">nil</font></b>);
<br>
    M1_0 := NewItem(<font color="#FF0000">'~P~arameter...'</font>, <font color="#FF0000">''</font>, kbF2, cmPara, hcNoContext, <b><font color="0000BB">nil</font></b>);
    SM1 := NewSubMenu(<font color="#FF0000">'~O~ption'</font>, hcNoContext, NewMenu(M1_0), SM2);
<br>
    M0_5 := NewItem(<font color="#FF0000">'~B~eenden'</font>, <font color="#FF0000">'Alt-X'</font>, kbAltX, cmQuit, hcNoContext, <b><font color="0000BB">nil</font></b>);
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem(<font color="#FF0000">'S~c~hliessen'</font>, <font color="#FF0000">'Alt-F3'</font>, kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_0 := NewItem(<font color="#FF0000">'~L~iste'</font>, <font color="#FF0000">'F2'</font>, kbF2, cmList, hcNoContext, M0_2);
    SM0 := NewSubMenu(<font color="#FF0000">'~D~atei'</font>, hcNoContext, NewMenu(M0_0), SM1);
<br>
    M := NewMenu(SM0);
<br>
    MenuBar := <b><font color="0000BB">New</font></b>(PMenuBar, Init(R, M));
  <b><font color="0000BB">end</font></b>;</code></pre>
Den Dialog mit RadioButton ergänzen, dies funktioniert fast gleich wie bei den CheckBoxen.<br>
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
<br>
      <i><font color="#FFFF00">// RadioButton</font></i>
      R.Assign(<font color="#0077BB">21</font>, <font color="#0077BB">3</font>, <font color="#0077BB">33</font>, <font color="#0077BB">6</font>);
      View := <b><font color="0000BB">New</font></b>(PRadioButtons, Init(R,
        NewSItem(<font color="#FF0000">'~G~ross'</font>,
        NewSItem(<font color="#FF0000">'~M~ittel'</font>,
        NewSItem(<font color="#FF0000">'~K~lein'</font>,
        <b><font color="0000BB">nil</font></b>)))));
      Insert(View);
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
