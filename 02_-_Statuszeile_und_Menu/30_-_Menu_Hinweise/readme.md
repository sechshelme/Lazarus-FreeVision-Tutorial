# 02 - Statuszeile und Menu
## 30 - Menu Hinweise
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Hinweise in der Statuszeile der Menü-Punkte.<br>
<hr><br>
Konstanten der einzelnen Hilfen.<br>
Am besten mimmt man da hcxxx Namen.<br>
<pre><code=pascal>const
  cmList   = 1002;  // Datei Liste</font>
  cmAbout  = 1001;  // About anzeigen</font>
<br>
  hcFile   = 10;</font>
  hcClose  = 11;</font>
  hcOption = 12;</font>
  hcFormat = 13;</font>
  hcEdit   = 14;</font>
  hcHelp   = 15;</font>
  hcAbout  = 16;</font></code></pre>
Die Hint-Zeile muss vererbt werden.<br>
<pre><code=pascal>  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;</font>
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcFile, NewMenu(</font>
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcClose, nil)),</font>
<br>
      NewSubMenu('~O~ptionen', hcOption, NewMenu(</font>
        NewItem('~F~ormat', '', kbNoKey, cmAbout, hcFormat,</font>
        NewItem('~E~itor', '', kbNoKey, cmAbout, hcEdit, nil))),</font>
<br>
      NewSubMenu('~H~ilfe', hcHelp, NewMenu(</font>
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcAbout, nil)), nil))))));</font>
  end;</code></pre>
<br>
