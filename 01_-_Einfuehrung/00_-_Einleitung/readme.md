# 01 - Einfuehrung
## 00 - Einleitung
<b>Free Vision</b> ist die freie Variante von Turbo-Vision, welche bei Turbo-Pascal dabei war.<br>
Viele denken, das FV etwas veraltetes aus dem DOS-Zeitalter sei.<br>
Für normale Desktop-Anwendungen stimmt dies zu.<br>
Aber es gibt Anwendungen, wo dies heutzutage noch sehr praktisch ist.<br>
Sehr gutes Beispiel ist bei einem <b>Telnet</b>-Zugriff.<br>
Oder bei einem Server, der keine grafische Oberfläche hat.<br>
<br>
Welcher Linux-Freak hat sich nicht schon mit <b>vi</b> oder <b>nemo</b> rumärgern müssen.<br>
Hätte Linux ein FV-Editor an Board, währe das Leben viel leichter. ;-)<br>
<br>
Aus diesem Grund beschäftige ich mich mit momentan mit <b>Free Vision</b>.<br>
Vieles dafür habe ich in den Quellen von FV abgeguckt, auch habe ich noch etwas auf einer alten Diskette von einem Tubo-Pascal Buch gefunden.<br>
Auch im Internet findet man noch das eine und andere.<br>
Da ich meine Erfahrung teilen will, erstelle ich dieses Tutorial.<br>
<br>
Ich hoffe das Ganze ist verständlich, obwohl es sicher viele Rechtschreibe-Fehler hat. :-D<br>
<br>
Wen jemand noch Anregungen und Fehler sieht, kann er seine Kritik im deutschen Lazarus-Forum miteilen. ;-)<br>
<a href="">http://www.lazarusforum.de/viewtopic.php?f=22&t=11063&p=98205&hilit=freevision#p98205</a>
<br>
Die Sourcen zum Tutorial, kann man alle auf der Hauptseite herunterladen.<br>
Es ist eine Zip.<br>
---
<b>Hinweise zu den Coden:</b><br>
<br>
Free Vision verwendet Codepage 437.<br>
Aus diese Grund sollte man für eine fehlerfreie Darstellung der Umaute, diese als Char-Konstante verwenden.<br>
```pascal>ä = #132  Ä = #142</font>
ö = #148  Ö = #153</font>
ü = #129  Ü = #154</font>```
<br>
<b>Genereller Hinweis:</b><br>
Wen man zur Laufzeit Texte ändern will, zB. <b>Label</b>, <b>StaticText</b>, ist Vorsicht geboten.<br>
Da die Texte <b>PString</b> gespeichert sind, ist darauf zu achten, das man im Konstruktor (Init) schon genügend Speiher für die Texte reserviert.<br>
Am einfachsten geht dies so, somit hat es dann genügend Platz noch für <b>world</b>.<br>
```pascal>  StaticText := new(PStaticText, Init(Rect, 'Hallo           '));</font>
  StaticText^.Text^ := 'Hello world';</font>```
<br>
<b>TListBox</b><br>
Bei der Komponenten <b>TListBox<b> ist Vorsicht geboten, die <b>TList</b> welche man hier zuordnet, muss man selbst in einem <b>Destructor</b> aufräumen.<br>
Beispiele gibt es im Kapitel <b>Listen und ListBoxen</b>.<br>
<br>
<b>Genereller Hinweis 64Bit:</b><br>
Bei 64Bit Coden, kann es Fehler geben, <s>das betrifft vor allem Funktionen, welche <b>FormatStr</b> verwenden.</s><br>
Das sieht man leider gut mit der Zeilen und Spalten-Anzeige der Fenster.<br>
<br>
<b>Turbo-Vision</b><br>
In diesem Tutorial gibt es Sachen, welche <b>nicht</b> 100% kompatibel zu <b>Turbo-Vision</b> sind.<br>
Gewisse Komponenten und Funktionen wurden erst mit <b>Free-Vision</b> von <b>FPC</b> eingeführt.<br>
da gehört zB. <b>TabSheet dazu.</b><br>
Es gibt auch Funktionen, welche es nur in Turbo-Vision gibt.<br>
<br>
