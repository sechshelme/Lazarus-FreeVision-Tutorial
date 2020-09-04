//image image.png
(*
Hinzufügen mehrere Menüpunkte.
Hier wird dies auch der Übersicht zu liebe gesplittet gemacht.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile

(*
Für eigene Kommandos, muss man noch Kommdocode definieren.
Es empfiehlt sich Werte > 1000 zu verwenden, so das es keine Überschneidungen mit den Standard-Codes gibt.
*)
//code+
const
  cmList = 1002;      // Datei Liste
  cmAbout = 1001;     // About anzeigen
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
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    P3 := NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil);
    P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3);
    P1 := NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit, P2);
    P0 := NewStatusDef(0, $FFFF, P1, nil);

    StatusLine := New(PStatusLine, Init(Rect, P0));
  end;

(*
Mam kann die Menüeinträge auch gesplittet über Pointer machen.
Ob man es verschachtelt oder splittet, ist Geschmacksache.
Mit <b>NewLine</b> kann man eine Leerzeile einfügen.
Es empfiehlt sich wen bei einem Menüpunkt ein Dialog aufgeht, Hinter der Bezeichnung <b>...</b> zu schreiben.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;                       // Rechteck für die Menüzeilen-Position.

    M: PMenu;                          // Ganzes Menü
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M1_0: PMenuItem; // Einfache Menüpunkte

  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M1_0), nil);

    M0_2 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_1 := NewLine(M0_2);
    M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(Rect, M));
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
