//image image.png
(*
Ändern der Status-Zeile, mit mehreren Optionen.
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
    procedure InitStatusLine; virtual;
  end;

(*
In der Statuszeile sind auch mehrere Hot-Key möglich.
Die Deklaration könnte man verschachtelt in einer Zeile schreiben.
Im Beispiel wird es gesplittet gemacht.
*)
  //code+
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
  //code-

(*
Die Deklaration und Ausführung bleibt gleich.
*)
  //code+
var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
//code-
