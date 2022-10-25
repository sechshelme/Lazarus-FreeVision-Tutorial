# 15 - Fertige Dialoge
## 25 - Ordner wechseln
<img src="image.png" alt="Selfhtml"><br><br>
Ordner Wechsel Dialog.<br>
Der <b>PChDirDialog</b>.<br>
---
Der Ordnerwechsel Dialog<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    ChDirDialog: PChDirDialog;
    Ordner: ShortString;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmChDir: <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">New</font></b>(ChDirDialog, Init(fdOpenButton, <font color="#0077BB">1</font>));
          <b><font color="0000BB">if</font></b> ExecuteDialog(ChDirDialog, <b><font color="0000BB">nil</font></b>) <> cmCancel <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
            MessageBox(<font color="#FF0000">'Ordner wurde gewechselt'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;</code></pre>
<br>
