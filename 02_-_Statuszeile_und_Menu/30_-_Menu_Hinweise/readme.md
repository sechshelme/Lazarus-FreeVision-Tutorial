# 02 - Statuszeile und Menu
## 30 - Menu Hinweise
<br>
Hinweise in der Statuszeile der Menü-Punkte.<br>
<hr><br>
Konstanten der einzelnen Hilfen.<br>
Am besten mimmt man da hcxxx Namen.<br>
```pascal
const
  cmList   = 1002;  // Datei Liste
  cmAbout  = 1001;  // About anzeigen
<br>
  hcFile   = 10;
  hcClose  = 11;
  hcOption = 12;
  hcFormat = 13;
  hcEdit   = 14;
  hcHelp   = 15;
  hcAbout  = 16;
```
Die Hint-Zeile muss vererbt werden.<br>
```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcFile, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcClose, nil)),
<br>
      NewSubMenu('~O~ptionen', hcOption, NewMenu(
        NewItem('~F~ormat', '', kbNoKey, cmAbout, hcFormat,
        NewItem('~E~itor', '', kbNoKey, cmAbout, hcEdit, nil))),
<br>
      NewSubMenu('~H~ilfe', hcHelp, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcAbout, nil)), nil))))));
  end;
```
<br>
