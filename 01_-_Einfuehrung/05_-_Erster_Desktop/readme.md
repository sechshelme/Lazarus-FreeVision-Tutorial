# 01 - Einfuehrung
## 05 - Erster Desktop
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Minimalste Free-Vision Anwendung<br>
<hr><br>
Programm-Name, wie es bei Pascal üblich ist.<br>
LineEnding+```pascal
program Project1;
```
<br>
Das überhaupt Free-Vision möglich ist, muss die Unit <b>App</b> eingebunden werden.<br>
LineEnding+```pascal
uses
  App;   // TApplication
```
<br>
Deklaration für die Free-Vision Anwendung.<br>
LineEnding+```pascal
var
  MyApp: TApplication;
```
<br>
Für die Abarbeitung sind immer die drei Schritte notwendig.<br>
LineEnding+```pascal
begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
```
<br>

