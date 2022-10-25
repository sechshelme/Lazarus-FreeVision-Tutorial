# 01 - Einfuehrung
## 05 - Erster Desktop
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Minimalste Free-Vision Anwendung<br>
<hr><br>
Programm-Name, wie es bei Pascal üblich ist.<br>
<pre><code=pascal><b><font color="0000BB">program</font></b> Project1;</code></pre>
Das überhaupt Free-Vision möglich ist, muss die Unit <b>App</b> eingebunden werden.<br>
<pre><code=pascal><b><font color="0000BB">uses</font></b>
  App;   <i><font color="#FFFF00">// TApplication</font></i></code></pre>
Deklaration für die Free-Vision Anwendung.<br>
<pre><code=pascal><b><font color="0000BB">var</font></b>
  MyApp: TApplication;</code></pre>
Für die Abarbeitung sind immer die drei Schritte notwendig.<br>
<pre><code=pascal><b><font color="0000BB">begin</font></b>
  MyApp.Init;   <i><font color="#FFFF00">// Inizialisieren</font></i>
  MyApp.Run;    <i><font color="#FFFF00">// Abarbeiten</font></i>
  MyApp.Done;   <i><font color="#FFFF00">// Freigeben</font></i>
<b><font color="0000BB">end</font></b>.</code></pre>
<br>
