//image image.png
(*
Ändern der Status-Zeile.
Die Statuszeile wird gebraucht um wichtige Information und HotKey anzuzeigen.
*)
//lineal
program Project1;

(*
Für die Statuszeile werden noch verschiedene Units gebraucht.
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
Wen man etwas ändern will, muss man TApplication vererben.
Hier im Beispiel, wird die Statuszeile abgeändert, dazu muss man die Procedure <b>InitStatusLine</b> überschreiben.
*)
//code+
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;
  end;
  //code.

(*
Die neue Methode für die Statuszeile.
<b>GetExtent(Rect);</b> liefert die Grösse des Fensters.
<b>A</b> ist die Position Links-Oben und <b>B</b ist Rechts-Unten.
Das man den Hotkey besser sieht, schreibt man ihn in <b>~xxx~</b>.
*)
  //code+
  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.
  begin
    GetExtent(Rect);          // Liefert die Grösse/Position der App, im Normalfall 0, 0, 80, 24.
    Rect.A.Y := Rect.B.Y - 1; // Position der Statuszeile, auf unterste Zeile der App setzen.

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF, NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit, nil), nil)));
  end;
  //code-

(*
Das die neue Statuszeile verwendet wird muss man den Nachkomme anstelle von <b>TApplication</b> deklarieren.
*)
  //code+
var
  MyApp: TMyApp;
  //code-
(*
Die  bleibt gleich.
*)
  //code+
begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
//code-
