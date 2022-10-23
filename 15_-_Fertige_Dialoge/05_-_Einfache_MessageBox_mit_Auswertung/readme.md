<html>
    <b><h1>15 - Fertige Dialoge</h1></b>
    <b><h2>05 - Einfache MessageBox mit Auswertung</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Die einfachsten Dialoge sind die fertigen MessageBoxen.<br>
<hr><br>
Konstanten für die verschiedenen Menüeinträge.<br>
<pre><code=pascal><b><font color="0000BB">const</font></b>
  cmAbout        = <font color="#0077BB">1001</font>;
  cmWarning      = <font color="#0077BB">1002</font>;
  cmError        = <font color="#0077BB">1003</font>;
  cmInfo         = <font color="#0077BB">1004</font>;
  cmConformation = <font color="#0077BB">1005</font>;
  cmYesNo        = <font color="#0077BB">1010</font>;
  cmYesNoCancel  = <font color="#0077BB">1011</font>;</code></pre>
Aufruf der MessageBoxn.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmAbout: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Ich bin ein About !'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfOkButton);
        <b><font color="0000BB">end</font></b>;
        cmWarning: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Ich bin eine Warnung-Box'</font>, <b><font color="0000BB">nil</font></b>, mfWarning + mfOkButton);
        <b><font color="0000BB">end</font></b>;
        cmError: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Ich bin eine Fehlermeldung'</font>, <b><font color="0000BB">nil</font></b>, mfError + mfOkButton);
        <b><font color="0000BB">end</font></b>;
        cmInfo: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Ich bin eine Info-Box'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfOkButton);
        <b><font color="0000BB">end</font></b>;
        cmConformation: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Ich bin eine Konfirmation-Box'</font>, <b><font color="0000BB">nil</font></b>, mfConfirmation + mfOkButton);
        <b><font color="0000BB">end</font></b>;
        cmYesNo: <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">case</font></b>
            MessageBox(<font color="#FF0000">'Ich bin Ja/Nein Frage'</font>, <b><font color="0000BB">nil</font></b>, mfConfirmation + mfYesButton + mfNoButton) <b><font color="0000BB">of</font></b>
            cmYes: <b><font color="0000BB">begin</font></b>
              MessageBox(<font color="#FF0000">'Es wurde [JA] geklickt'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfOkButton);
            <b><font color="0000BB">end</font></b>;
            cmNo: <b><font color="0000BB">begin</font></b>
              MessageBox(<font color="#FF0000">'Es wurde [NEIN] geklickt'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfOkButton);
            <b><font color="0000BB">end</font></b>;
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        cmYesNoCancel: <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">case</font></b>
            MessageBox(<font color="#FF0000">'Ich bin Ja/Nein Frage mit Cancel'</font>, <b><font color="0000BB">nil</font></b>, mfConfirmation + mfYesButton + mfNoButton + mfCancelButton) <b><font color="0000BB">of</font></b>
            cmYes: <b><font color="0000BB">begin</font></b>
              MessageBox(<font color="#FF0000">'Es wurde [JA] geklickt'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfOkButton);
            <b><font color="0000BB">end</font></b>;
            cmNo: <b><font color="0000BB">begin</font></b>
              MessageBox(<font color="#FF0000">'Es wurde [NEIN] geklickt'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfOkButton);
            <b><font color="0000BB">end</font></b>;
            cmCancel: <b><font color="0000BB">begin</font></b>
              MessageBox(<font color="#FF0000">'Es wurde [CANCEL] geklickt'</font>, <b><font color="0000BB">nil</font></b>, mfInformation + mfOkButton);
            <b><font color="0000BB">end</font></b>;
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
