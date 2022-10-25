# 99 - Test
## 15 - ListBox Heap
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird gezeigt, wie man Komponenten zu Laufzeit ändern kann.<br>
Dafür wird ein Button verwendet, bei dem sich die Bezeichnung bei jedem Klick erhöht.<br>
Neues Fenster erzeugen. Fenster werden in der Regel nicht modal geöffnet, da man meistens mehrere davon öffnen will.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.NewWindows(Titel: ShortString);
  <b><font color="0000BB">var</font></b>
    Win: PWindow;
    R: TRect;
  <b><font color="0000BB">begin</font></b>
    R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">60</font>, <font color="#0077BB">20</font>);
    Win := <b><font color="0000BB">New</font></b>(PWindow, Init(R, Titel, wnNoNumber));
    <b><font color="0000BB">if</font></b> ValidView(Win) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Win);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
---
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit dem Zähler-Button.<br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.<br>
Direkt mit <b>Insert(New(...</b> geht nicht mehr.<br>
<pre><code><b><font color="0000BB">type</font></b>
<br>
  PNewListBox = ^TNewListBox;
<br>
  <font color="#FFFF00">{ TNewListBox }</font>
<br>
  TNewListBox = <b><font color="0000BB">object</font></b>(TListBox)
    <b><font color="0000BB">destructor</font></b> Done; <b><font color="0000BB">virtual</font></b>;
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
<br>
  PMyDialog = ^TMyDialog;
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
    ListBox: PNewListBox;
    StringCollection: PUnSortedStrCollection;
    <b><font color="0000BB">constructor</font></b> Init;
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.<br>
<b>CounterButton</b> wird für die Modifikation gebraucht.<br>
<pre><code><b><font color="0000BB">const</font></b>
  cmTag = <font color="#0077BB">1000</font>;  <i><font color="#FFFF00">// Lokale Event Konstante</font></i>
</code></pre>
Im EventHandle, wird die Zahl im Button beim Drücken erhöht.<br>
Das sieht man, warum man den <b>CounterButton</b> braucht, ohne dem hätte man keinen Zugriff auf <b>Titel</b>.<br>
Wichtig, wen man eine Komponente ändert, muss man mit <b>Draw</b> die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyDialog.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evCommand: <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmOK: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Wochentag: '</font> + PString(ListBox^.GetFocusedItem)^ + <font color="#FF0000">' gew'</font> + <font color="#FF0000">#132</font> + <font color="#FF0000">'hlt'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
        <b><font color="0000BB">end</font></b>;
        cmTag: <b><font color="0000BB">begin</font></b>
          <i><font color="#FFFF00">// Eintrag mit Fokus auslesen</font></i>
          <i><font color="#FFFF00">// Und ausgeben</font></i>
          MessageBox(<font color="#FF0000">'Wochentag: '</font> + PString(ListBox^.GetFocusedItem)^ + <font color="#FF0000">' gew'</font> + <font color="#FF0000">#132</font> + <font color="#FF0000">'hlt'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          <i><font color="#FFFF00">// Event beenden.</font></i>
          ClearEvent(Event);
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
