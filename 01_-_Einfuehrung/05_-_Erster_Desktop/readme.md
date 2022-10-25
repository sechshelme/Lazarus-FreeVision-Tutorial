# 01 - Einfuehrung
## 05 - Erster Desktop
<br>
Minimalste Free-Vision Anwendung<br>
<hr><br>
Programm-Name, wie es bei Pascal üblich ist.<br>
```pascal
program Project1;
```
Das überhaupt Free-Vision möglich ist, muss die Unit <b>App</b> eingebunden werden.<br>
```pascal
uses
  App;   // TApplication
```
Deklaration für die Free-Vision Anwendung.<br>
```pascal
var
  MyApp: TApplication;
```
Für die Abarbeitung sind immer die drei Schritte notwendig.<br>
```pascal
begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
```
<br>
