# 02 - Statuszeile und Menu
## 00 - Status Zeile
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Ändern der Status-Zeile.<br>
Die Statuszeile wird gebraucht um wichtige Information und HotKey anzuzeigen.<br>
<hr><br>
Für die Statuszeile werden noch verschiedene Units gebraucht.<br>
<br>
```pascal
uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile
```
<br>
Wen man etwas ändern will, muss man TApplication vererben.<br>
Hier im Beispiel, wird die Statuszeile abgeändert, dazu muss man die Procedure <b>InitStatusLine</b> überschreiben.<br>
<br>
```pascal
  procedure TMyApp.InitStatusLine;
  var
    R: TRect;           // Rechteck für die Statuszeilen Position.
  begin
    GetExtent(R);       // Liefert die Grösse/Position der App, im Normalfall 0, 0, 80, 24.
    R.A.Y := R.B.Y - 1; // Position der Statuszeile, auf unterste Zeile der App setzen.
<br>
    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF, NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit, nil), nil)));
  end;
```
<br>
Das die neue Statuszeile verwendet wird muss man den Nachkomme anstelle von <b>TApplication</b> deklarieren.<br>
<br>
```pascal
var
  MyApp: TMyApp;
```
<br>
Die  bleibt gleich.<br>
<br>
```pascal
begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
```
<br>

