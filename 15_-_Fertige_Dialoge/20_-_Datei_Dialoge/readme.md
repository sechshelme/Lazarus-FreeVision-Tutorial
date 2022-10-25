# 15 - Fertige Dialoge
## 20 - Datei Dialoge
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Ein Dialog zum öffnen und speichern von Dateien.<br>
Der <b>PFileDialog</b>.<br>
---
<br>
Verschiedene Datei-Dialoge<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    FileDialog: PFileDialog;
    FileName: shortstring;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmFileOpen: <b><font color="0000BB">begin</font></b>
          FileName := <font color="#FF0000">'*.*'</font>;
          <b><font color="0000BB">New</font></b>(FileDialog, Init(FileName, <font color="#FF0000">'Datei '</font><font color="#FF0000">#148</font><font color="#FF0000">'ffnen'</font>, <font color="#FF0000">'~D~ateiname'</font>, fdOpenButton, <font color="#0077BB">1</font>));
          <b><font color="0000BB">if</font></b> ExecuteDialog(FileDialog, @FileName) <> cmCancel <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
            MessageBox(<font color="#FF0000">'Es wurde "'</font> + FileName + <font color="#FF0000">'" eingegeben'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        cmFileSave: <b><font color="0000BB">begin</font></b>
          FileName := <font color="#FF0000">'*.*'</font>;
          <b><font color="0000BB">New</font></b>(FileDialog, Init(FileName, <font color="#FF0000">'Datei '</font><font color="#FF0000">#148</font><font color="#FF0000">'ffnen'</font>, <font color="#FF0000">'~D~ateiname'</font>, fdOkButton, <font color="#0077BB">1</font>));
          <b><font color="0000BB">if</font></b> ExecuteDialog(FileDialog, @FileName) <> cmCancel <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
            MessageBox(<font color="#FF0000">'Es wurde "'</font> + FileName + <font color="#FF0000">'" eingegeben'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        cmFileHelp: <b><font color="0000BB">begin</font></b>
          FileName := <font color="#FF0000">'*.*'</font>;
          <b><font color="0000BB">New</font></b>(FileDialog, Init(FileName, <font color="#FF0000">'Datei '</font><font color="#FF0000">#148</font><font color="#FF0000">'ffnen'</font>, <font color="#FF0000">'~D~ateiname'</font>, fdOkButton + fdOpenButton + fdReplaceButton + fdClearButton + fdHelpButton, <font color="#0077BB">1</font>));
          <b><font color="0000BB">if</font></b> ExecuteDialog(FileDialog, @FileName) <> cmCancel <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
            MessageBox(<font color="#FF0000">'Es wurde "'</font> + FileName + <font color="#FF0000">'" eingegeben'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;</code></pre>
<br>
