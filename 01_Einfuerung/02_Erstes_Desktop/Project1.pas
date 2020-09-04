//image image.png

(*
Minimalste Free-Vision Anwendung
*)
//lineal
(*
Programm-Name, wie es bei Pascal üblich ist.
*)
//code+
program Project1;
//code-

(*
Das überhaupt Free-Vision möglich ist, muss die Unit <b>App</b> eingebunden werden.
*)
//code+
uses
  App;   // TApplication
//code-

(*
Deklaration für die Free-Vision Anwendung.
*)
//code+
var
  MyApp: TApplication;
  //code-

(*
Für die Abarbeitung sind immer die drei Schritte notwendig.
*)
  //code+
begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
//code-

