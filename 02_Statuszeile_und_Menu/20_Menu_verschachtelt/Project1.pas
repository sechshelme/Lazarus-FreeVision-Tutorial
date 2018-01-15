//image image.png
(*
Menupunkt kann man auch ineinander verschachteln.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile

const
  cmList = 1002;      // Datei Liste
  cmAbout = 1001;     // About anzeigen

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Statuszeile
    procedure InitMenuBar; virtual;      // Menü
  end;
(*
Bei der Statuszeile habe ich die Einträge verschachtelt, somit braucht man keine Zeiger.
Ich finde dies auch übersichtlicher, als ein Variablen-Urwald.
*)
//code+
  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));
  end;
//code-

(*
Folgendes Beispiel demonstriert ein verschachteltes Menü.
Die Erzeugung ist auch verschachtelt.
//codetext+
Datei
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
//codetext-
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;                   // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),

      NewSubMenu('Dem~o~', hcNoContext, NewMenu(
        NewItem('Einfach ~1~', '', kbNoKey, cmAbout, hcNoContext,
        NewSubMenu('~V~erschachtelt', hcNoContext, NewMenu(
          NewItem('Menu ~0~', '', kbNoKey, cmAbout, hcNoContext,
          NewItem('Menu ~1~', '', kbNoKey, cmAbout, hcNoContext,
          NewItem('Menu ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),
        NewItem('Einfach ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),

      NewSubMenu('~H~ilfe', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
