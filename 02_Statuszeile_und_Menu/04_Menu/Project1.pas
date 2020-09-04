//image image.png
(*
Hinzufügen eines Menüs.
*)
//lineal
program Project1;

(*
Für das Menü werden die gleichen Units wie für die Statuszeile gebraucht.
*)
//code+
uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile
//code-

(*
Für ein Menu muss man <b>InitMenuBar</b> vererben.
*)
//code+
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Statuszeile
    procedure InitMenuBar; virtual;      // Menü
  end;
  //code-

  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.

    P0: PStatusDef;           // Pointer ganzer Eintrag.
    P1, P2, P3: PStatusItem;  // Pointer auf die einzelnen Hot-Key.
  begin
    GetExtent(Rect);          // Liefert die Grösse/Position der App, im Normalfall 0, 0, 80, 24.
    Rect.A.Y := Rect.B.Y - 1; // Position der Statuszeile, auf unterste Zeile der App setzen.

    P3 := NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil);
    P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3);
    P1 := NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit, P2);
    P0 := NewStatusDef(0, $FFFF, P1, nil);

    StatusLine := New(PStatusLine, Init(Rect, P0));
  end;

(*
Das Menü erzeugen, das Beispiel hat nur eine einziger Menüpunkt, Beenden.
Beim Menü sind die Zeichen die mit <b>~x~</b> hervorgehoben sind nicht nur Optischen, sonder auch funktionell.
Zum beenden, kann man auch <b>[Alt+s]</b>, <b>[b]</b> drücken.
Es gibt auch direkte HotKey auf die Menüpunkte, hier im Beipiel ist die <b>[Alt+x]</b> für beenden.
Dieses überschneidet sich hier zufällig mit <b>[Alt+x]</b> von der Statuszeile, aber dies ist egal.
Der Aufbau der Menüerzeugung ist ähnlich der Statuszeile.
Beim letzten Menüpunkt kommt immer ein <b>nil</b>.
*)

  //code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;              // Rechteck für die Memüzeile Position.
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1; // Position des Menüs, auf oberste Zeile der App setzen.

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
      NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)), nil))));
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
