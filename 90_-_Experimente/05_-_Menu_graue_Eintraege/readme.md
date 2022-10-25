# 90 - Experimente
## 05 - Menu graue Eintraege
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>
---
<br>

<br>
```pascal
  procedure TMyApp.InitStatusLine;
  var
    R: TRect;              // Rechteck für die Statuszeilen Position.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;
<br>
    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));
  end;
```
<br>

<br>

```Datei
  Beenden
Demo
  Einfach 1
  Verschachtelt
    Menu 0
    Menu 1
    Menu 2
  Einfach 2
Hilfe
  About
```
<br>

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
<br>
      NewSubMenu('Dem~o~', hcNoContext, NewMenu(
        NewItem('Einfach ~1~', '', kbNoKey, cmAbout, hcNoContext,
        NewSubMenu('~V~erschachtelt', hcNoContext, NewMenu(
          NewItem('Menu ~0~', '', kbNoKey, cmAbout, hcNoContext,
          NewItem('Menu ~1~', '', kbNoKey, cmAbout, hcNoContext,
          NewItem('Menu ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),
        NewItem('Einfach ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),
<br>
      NewSubMenu('~H~ilfe', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));
<br>
    MenuBar^.Menu^.Items^.Next^.SubMenu^.Items^.Next^.Disabled:=True;
  end;
```
<br>

