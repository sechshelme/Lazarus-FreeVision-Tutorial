# 02 - Statuszeile und Menu
## 30 - Menu Hinweise

<img src="image.png" alt="Selfhtml"><br><br>

---



```pascal
const
  cmList   = 1002;  // Datei Liste
  cmAbout  = 1001;  // About anzeigen

  hcFile   = 10;
  hcClose  = 11;
  hcOption = 12;
  hcFormat = 13;
  hcEdit   = 14;
  hcHelp   = 15;
  hcAbout  = 16;
```



```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcFile, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcClose, nil)),

      NewSubMenu('~O~ptionen', hcOption, NewMenu(
        NewItem('~F~ormat', '', kbNoKey, cmAbout, hcFormat,
        NewItem('~E~itor', '', kbNoKey, cmAbout, hcEdit, nil))),

      NewSubMenu('~H~ilfe', hcHelp, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcAbout, nil)), nil))))));
  end;
```


