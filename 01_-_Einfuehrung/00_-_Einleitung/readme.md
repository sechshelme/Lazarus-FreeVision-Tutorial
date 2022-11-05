# 01 - Einfuehrung
## 00 - Einleitung

**Free Vision** ist die freie Variante von Turbo-Vision, welche bei Turbo-Pascal dabei war.
Viele denken, das FV etwas veraltetes aus dem DOS-Zeitalter sei.
Für normale Desktop-Anwendungen stimmt dies zu.
Aber es gibt Anwendungen, wo dies heutzutage noch sehr praktisch ist.
Sehr gutes Beispiel ist bei einem **Telnet**-Zugriff.
Oder bei einem Server, der keine grafische Oberfläche hat.

Welcher Linux-Freak hat sich nicht schon mit **vi** oder **nemo** rumärgern müssen.
Hätte Linux ein FV-Editor an Board, währe das Leben viel leichter. ;-)

Aus diesem Grund beschäftige ich mich mit momentan mit **Free Vision**.
Vieles dafür habe ich in den Quellen von FV abgeguckt, auch habe ich noch etwas auf einer alten Diskette von einem Tubo-Pascal Buch gefunden.
Auch im Internet findet man noch das eine und andere.
Da ich meine Erfahrung teilen will, erstelle ich dieses Tutorial.

Ich hoffe das Ganze ist verständlich, obwohl es sicher viele Rechtschreibe-Fehler hat. :-D

Wen jemand noch Anregungen und Fehler sieht, kann er seine Kritik im deutschen Lazarus-Forum miteilen. ;-)
<a href="">http://www.lazarusforum.de/viewtopic.php?f=22&t=11063&p=98205&hilit=freevision#p98205</a>

Die Sourcen zum Tutorial, kann man alle auf der Hauptseite herunterladen.
Es ist eine Zip.

---
**Hinweise zu den Coden:**

Free Vision verwendet Codepage 437.
Aus diese Grund sollte man für eine fehlerfreie Darstellung der Umaute, diese als Char-Konstante verwenden.

```pascal
ä = #132  Ä = #142
ö = #148  Ö = #153
ü = #129  Ü = #154
```


**Genereller Hinweis:**
Wen man zur Laufzeit Texte ändern will, zB. **Label**, **StaticText**, ist Vorsicht geboten.
Da die Texte **PString** gespeichert sind, ist darauf zu achten, das man im Konstruktor (Init) schon genügend Speiher für die Texte reserviert.
Am einfachsten geht dies so, somit hat es dann genügend Platz noch für **world**.

```pascal
  StaticText := new(PStaticText, Init(Rect, 'Hallo           '));
  StaticText^.Text^ := 'Hello world';
```


**TListBox**
Bei der Komponenten **TListBox** ist Vorsicht geboten, die **TList** welche man hier zuordnet, muss man selbst in einem **Destructor** aufräumen.
Beispiele gibt es im Kapitel **Listen und ListBoxen**.

**Genereller Hinweis 64Bit:**
Bei 64Bit Coden, kann es Fehler geben, <s>das betrifft vor allem Funktionen, welche **FormatStr** verwenden.</s>
Das sieht man leider gut mit der Zeilen und Spalten-Anzeige der Fenster.

**Turbo-Vision**
In diesem Tutorial gibt es Sachen, welche **nicht** 100% kompatibel zu **Turbo-Vision** sind.
Gewisse Komponenten und Funktionen wurden erst mit **Free-Vision** von **FPC** eingeführt.
da gehört zB. **TabSheet dazu.**
Es gibt auch Funktionen, welche es nur in Turbo-Vision gibt.

