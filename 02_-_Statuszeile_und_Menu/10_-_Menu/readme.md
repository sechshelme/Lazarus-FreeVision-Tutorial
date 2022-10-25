# 02 - Statuszeile und Menu
## 10 - Menu
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>
---
<br>

```pascal
uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile
```
<br>

<br>
```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Statuszeile
    procedure InitMenuBar; virtual;      // Menü
  end;
```
<br>

<br>

<br>

<br>

<br>
```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;           // Rechteck für die Memüzeile Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1; // Position des Menüs, auf oberste Zeile der App setzen.
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
      NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)), nil))));
  end;
```
<br>

