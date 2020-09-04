//image image.png
(*
Für die Statuszeile und das Menü gibt es fertige Items, aber ich bevorzuge es, die Items selbst zu erstellen.
Die fetigen Items sind nur in Englisch.
Die Statuszeile ist Textlos, das einzige, sie bringt Schnellkomandos mit. ( cmQuit, cmMenu, cmClose, cmZoom, cmNext, cmPrev )
Bis aus <b>OS shell</b> und <b>Exit</b> passiert nichts.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Statuszeile
    procedure InitMenuBar; virtual;      // Menü
  end;
(*
Mit <b>StdStatusKeys(...</b> wird eine Statuszeile estellt, aber wie oben beschrieben, sieht man keinne Text.
*)
//code+
  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF, StdStatusKeys(nil), nil)));
  end;
//code-

(*
Fur das Menü gibt es 3 fertige Items, für Datei, Bearbeiten und Fenster, aber eben in Englisch.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        StdFileMenuItems (nil)),
      NewSubMenu('~B~earbeiten', hcNoContext, NewMenu(
         StdEditMenuItems (nil)),
      NewSubMenu('~F~enster', hcNoContext, NewMenu(
        StdWindowMenuItems(nil)), nil))))));
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
