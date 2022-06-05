<html>
    <b><h1>99 Test</h1></b>
    <b><h2>15 ListBox Heap</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird gezeigt, wie man Komponenten zu Laufzeit ändern kann.<br>
Dafür wird ein Button verwendet, bei dem sich die Bezeichnung bei jedem Klick erhöht.<br>
Neues Fenster erzeugen. Fenster werden in der Regel nicht modal geöffnet, da man meistens mehrere davon öffnen will.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.NewWindows(Titel: ShortString);
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
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit dem Zähler-Button.<br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.<br>
Direkt mit <b>Insert(New(...</b> geht nicht mehr.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyDialog = ^TMyDialog;
<br>
  <font color="#FFFF00">{ TMyDialog }</font>
<br>
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
    ListBox: PListBox;
    StringCollection: PUnSortedStrCollection;
<br>
    <b><font color="0000BB">constructor</font></b> Init;
    <b><font color="0000BB">destructor</font></b> Done; <b><font color="0000BB">virtual</font></b>;  <i><font color="#FFFF00">// Wegen Speicher Leak in TList</font></i>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.<br>
<b>CounterButton</b> wird für die Modifikation gebraucht.<br>
<pre><code><b><font color="0000BB">const</font></b>
  cmMonat = <font color="#0077BB">1000</font>;  <i><font color="#FFFF00">// Lokale Event Konstante</font></i>
  cmNewFocus = <font color="#0077BB">1001</font>;
  cmNewBack = <font color="#0077BB">1002</font>;
  cmDelete = <font color="#0077BB">1003</font>;
<br>
<b><font color="0000BB">constructor</font></b> TMyDialog.Init;
<b><font color="0000BB">var</font></b>
  R: TRect;
  ScrollBar: PScrollBar;
  i: integer;
<b><font color="0000BB">const</font></b>
  Tage: <b><font color="0000BB">array</font></b> [<font color="#0077BB">0</font>..<font color="#0077BB">11</font>] <b><font color="0000BB">of</font></b> shortstring = (
    <font color="#FF0000">'Januar'</font>, <font color="#FF0000">'Februar'</font>, <font color="#FF0000">'M'</font> + <font color="#FF0000">#132</font><font color="#FF0000">'rz'</font>, <font color="#FF0000">'April'</font>, <font color="#FF0000">'Mai'</font>, <font color="#FF0000">'Juni'</font>, <font color="#FF0000">'Juli'</font>,
    <font color="#FF0000">'August'</font>, <font color="#FF0000">'September'</font>, <font color="#FF0000">'Oktober'</font>, <font color="#FF0000">'November'</font>, <font color="#FF0000">'Dezember'</font>);
<br>
<b><font color="0000BB">begin</font></b>
  R.Assign(<font color="#0077BB">10</font>, <font color="#0077BB">3</font>, <font color="#0077BB">64</font>, <font color="#0077BB">20</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'ListBox Demo'</font>);
<br>
  <i><font color="#FFFF00">// StringCollection</font></i>
  StringCollection := <b><font color="0000BB">new</font></b>(PUnSortedStrCollection, Init(<font color="#0077BB">5</font>, <font color="#0077BB">5</font>));
  <b><font color="0000BB">for</font></b> i := <font color="#0077BB">0</font> <b><font color="0000BB">to</font></b> Length(Tage) - <font color="#0077BB">1</font> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
    StringCollection^.Insert(NewStr(Tage[i]));
  <b><font color="0000BB">end</font></b>;
<br>
  <i><font color="#FFFF00">// ScrollBar für ListBox</font></i>
  R.Assign(<font color="#0077BB">22</font>, <font color="#0077BB">2</font>, <font color="#0077BB">23</font>, <font color="#0077BB">16</font>);
  ScrollBar := <b><font color="0000BB">new</font></b>(PScrollBar, Init(R));
  Insert(ScrollBar);
<br>
  <i><font color="#FFFF00">// ListBox</font></i>
  R.A.X := <font color="#0077BB">5</font>;
  Dec(R.B.X, <font color="#0077BB">1</font>);
  ListBox := <b><font color="0000BB">new</font></b>(PListBox, Init(R, <font color="#0077BB">1</font>, ScrollBar));
  ListBox^.NewList(StringCollection);
  Insert(ListBox);
<br>
  <i><font color="#FFFF00">// Tag-Button</font></i>
  R.A.X := R.B.X + <font color="#0077BB">5</font>;
  R.B.X := R.A.X + <font color="#0077BB">14</font>;
  R.A.Y := <font color="#0077BB">2</font>;
  R.B.Y := R.A.Y + <font color="#0077BB">2</font>;
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~M~onat'</font>, cmMonat, bfNormal)));
<br>
  <i><font color="#FFFF00">// Neu Button bei fukosierten Eintrag</font></i>
  R.Move(<font color="#0077BB">0</font>, <font color="#0077BB">2</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~N~eu fokus'</font>, cmNewFocus, bfNormal)));
<br>
  <i><font color="#FFFF00">// Neu-Button am Ende der List</font></i>
  R.Move(<font color="#0077BB">0</font>, <font color="#0077BB">2</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~N~eu hinten'</font>, cmNewBack, bfNormal)));
<br>
  <i><font color="#FFFF00">// Enfernen</font></i>
  R.Move(<font color="#0077BB">0</font>, <font color="#0077BB">2</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~E~ntfernen'</font>, cmDelete, bfNormal)));
<br>
  <i><font color="#FFFF00">// Cancel-Button</font></i>
  R.Move(<font color="#0077BB">0</font>, <font color="#0077BB">3</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~A~bbruch'</font>, cmCancel, bfNormal)));
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  R.Move(<font color="#0077BB">0</font>, <font color="#0077BB">2</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
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
          <i><font color="#FFFF00">// mache etwas</font></i>
        <b><font color="0000BB">end</font></b>;
        cmNewFocus: <b><font color="0000BB">begin</font></b>
          <i><font color="#FFFF00">// Fügt beim markierten Eintrag einen neuen Eintrag ein</font></i>
          ListBox^.List^.AtInsert(ListBox^.Focused, NewStr(<font color="#FF0000">'neu'</font>));
          ListBox^.SetRange(ListBox^.List^.Count);
          ListBox^.Draw;
        <b><font color="0000BB">end</font></b>;
        cmNewBack: <b><font color="0000BB">begin</font></b>
          <i><font color="#FFFF00">// Fügt hinten einen neuen Eintrag ein</font></i>
          ListBox^.Insert(NewStr(<font color="#FF0000">'neu'</font>));
          ListBox^.Draw;
        <b><font color="0000BB">end</font></b>;
        cmDelete: <b><font color="0000BB">begin</font></b>
          <i><font color="#FFFF00">// Löscht den fokusierte Eintrag</font></i>
          ListBox^.FreeItem(ListBox^.Focused);
          ListBox^.Draw;
        <b><font color="0000BB">end</font></b>;
        cmMonat: <b><font color="0000BB">begin</font></b>
          <i><font color="#FFFF00">// Eintrag mit Fokus ausgeben</font></i>
          <b><font color="0000BB">if</font></b> ListBox^.List^.Count &gt; <font color="#0077BB">0</font> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
            MessageBox(<font color="#FF0000">'Monat: '</font> + PString(ListBox^.GetFocusedItem)^ + <font color="#FF0000">' gew'</font> + <font color="#FF0000">#132</font> + <font color="#FF0000">'hlt'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          <b><font color="0000BB">end</font></b>;
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
</html>