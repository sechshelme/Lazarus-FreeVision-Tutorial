# 02 - Statuszeile und Menu
## 10 - Menu

![image.png](image.png)
Hinzufügen eines Menüs.
---
Für das Menü werden die gleichen Units wie für die Statuszeile gebraucht.

```pascal
uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile
```

Für ein Menu muss man <b>InitMenuBar</b> vererben.

```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Statuszeile
    procedure InitMenuBar; virtual;      // Menü
  end;
```

Das Menü erzeugen, das Beispiel hat nur eine einziger Menüpunkt, Beenden.
Beim Menü sind die Zeichen die mit <b>~x~</b> hervorgehoben sind nicht nur Optischen, sonder auch funktionell.
Zum beenden, kann man auch <b>[Alt+s]</b>, <b>[b]</b> drücken.
Es gibt auch direkte HotKey auf die Menüpunkte, hier im Beipiel ist die <b>[Alt+x]</b> für beenden.
Dieses überschneidet sich hier zufällig mit <b>[Alt+x]</b> von der Statuszeile, aber dies ist egal.
Der Aufbau der Menüerzeugung ist ähnlich der Statuszeile.
Beim letzten Menüpunkt kommt immer ein <b>nil</b>.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;           // Rechteck für die Memüzeile Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1; // Position des Menüs, auf oberste Zeile der App setzen.

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
      NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)), nil))));
  end;
```


