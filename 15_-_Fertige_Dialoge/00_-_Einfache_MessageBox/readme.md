# 15 - Fertige Dialoge
## 00 - Einfache MessageBox
<img src="image.png" alt="Selfhtml"><br><br>
Die einfachsten Dialoge sind die fertigen MessageBoxen.<br>
---
Aufruf einer MessageBox.<br>
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
          MessageBox(<font color="#FF0000">'Ich bin eine Info-Box'</font>, <b><font color="0000BB">nil</font></b>, mfConfirmation + mfOkButton);
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
