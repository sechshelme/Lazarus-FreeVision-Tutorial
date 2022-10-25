# 01 - Einfuehrung
## 05 - Erster Desktop
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Minimalste Free-Vision Anwendung<br>
<hr><br>
Programm-Name, wie es bei Pascal üblich ist.<br>
<pre><code=pascal>program Project1;</code></pre>
Das überhaupt Free-Vision möglich ist, muss die Unit <b>App</b> eingebunden werden.<br>
<pre><code=pascal>uses
  App;   // TApplication</code></pre>
Deklaration für die Free-Vision Anwendung.<br>
<pre><code=pascal>var
  MyApp: TApplication;</code></pre>
Für die Abarbeitung sind immer die drei Schritte notwendig.<br>
<pre><code=pascal>begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.</code></pre>
<br>
