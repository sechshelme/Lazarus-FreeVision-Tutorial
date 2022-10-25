# 02 - Statuszeile und Menu
## 10 - Menu
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Hinzufügen eines Menüs.<br>
<hr><br>
Für das Menü werden die gleichen Units wie für die Statuszeile gebraucht.<br>
```pascal
uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile
```
Für ein Menu muss man <b>InitMenuBar</b> vererben.<br>
```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Statuszeile
    procedure InitMenuBar; virtual;      // Menü
  end;
```
Das Menü erzeugen, das Beispiel hat nur eine einziger Menüpunkt, Beenden.<br>
Beim Menü sind die Zeichen die mit <b>~x~</b> hervorgehoben sind nicht nur Optischen, sonder auch funktionell.<br>
Zum beenden, kann man auch <b>[Alt+s]</b>, <b>[b]</b> drücken.<br>
Es gibt auch direkte HotKey auf die Menüpunkte, hier im Beipiel ist die <b>[Alt+x]</b> für beenden.<br>
Dieses überschneidet sich hier zufällig mit <b>[Alt+x]</b> von der Statuszeile, aber dies ist egal.<br>
Der Aufbau der Menüerzeugung ist ähnlich der Statuszeile.<br>
Beim letzten Menüpunkt kommt immer ein <b>nil</b>.<br>
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
