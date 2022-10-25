# 01 - Einfuehrung
## 05 - Erster Desktop
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Minimalste Free-Vision Anwendung<br>
<hr><br>
Programm-Name, wie es bei Pascal üblich ist.<br>
```pascalprogram Project1;```
Das überhaupt Free-Vision möglich ist, muss die Unit <b>App</b> eingebunden werden.<br>
```pascaluses
  App;   // TApplication```
Deklaration für die Free-Vision Anwendung.<br>
```pascalvar
  MyApp: TApplication;```
Für die Abarbeitung sind immer die drei Schritte notwendig.<br>
```pascalbegin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.```
<br>
