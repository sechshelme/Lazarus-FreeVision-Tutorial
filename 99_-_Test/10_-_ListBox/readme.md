# 99 - Test
## 10 - ListBox
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird gezeigt, wie man Komponenten zu Laufzeit ändern kann.<br>
Dafür wird ein Button verwendet, bei dem sich die Bezeichnung bei jedem Klick erhöht.<br>
---
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
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
  <b><font color="0000BB">const</font></b>
    cmTag = <font color="#0077BB">1000</font>;
  <b><font color="0000BB">var</font></b>
    ListBox: PListBox;
<br>
    <b><font color="0000BB">constructor</font></b> Init;
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.<br>
<b>CounterButton</b> wird für die Modifikation gebraucht.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyDialog.Init;
<b><font color="0000BB">var</font></b>
  R: TRect;
  ScrollBar: PScrollBar;
  StringCollection: PCollection;
<br>
<b><font color="0000BB">begin</font></b>
  R.Assign(<font color="#0077BB">10</font>, <font color="#0077BB">5</font>, <font color="#0077BB">67</font>, <font color="#0077BB">17</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'ListBox Demo'</font>);
<br>
  Title := NewStr(<font color="#FF0000">'dfsfdsa'</font>);
<br>
  <i><font color="#FFFF00">// ListBox</font></i>
  R.Assign(<font color="#0077BB">31</font>, <font color="#0077BB">2</font>, <font color="#0077BB">32</font>, <font color="#0077BB">7</font>);
  ScrollBar := <b><font color="0000BB">new</font></b>(PScrollBar, Init(R));
  Insert(ScrollBar);
<br>
  StringCollection := <b><font color="0000BB">new</font></b>(PCollection, Init(<font color="#0077BB">0</font>, <font color="#0077BB">1</font>));
  StringCollection^.Insert(NewStr(<font color="#FF0000">'Montag'</font>));
  StringCollection^.Insert(NewStr(<font color="#FF0000">'Dienstag'</font>));
  StringCollection^.Insert(NewStr(<font color="#FF0000">'Mittwoch'</font>));
  StringCollection^.Insert(NewStr(<font color="#FF0000">'Donnerstag'</font>));
  StringCollection^.Insert(NewStr(<font color="#FF0000">'Freitag'</font>));
  StringCollection^.Insert(NewStr(<font color="#FF0000">'Samstag'</font>));
  StringCollection^.Insert(NewStr(<font color="#FF0000">'Sonntag'</font>));
<br>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">2</font>, <font color="#0077BB">31</font>, <font color="#0077BB">7</font>);
  ListBox := <b><font color="0000BB">new</font></b>(PListBox, Init(R, <font color="#0077BB">1</font>, ScrollBar));
  ListBox^.NewList(StringCollection);
<br>
  Insert(ListBox);
  ListBox^.Insert(NewStr(<font color="#FF0000">'aaaaaaaaa'</font>));
<br>
  ListBox^.List^.Insert(NewStr(<font color="#FF0000">'bbbbbbb'</font>));
  ListBox^.SetRange(ListBox^.List^.Count);
<br>

<br>
  <i><font color="#FFFF00">// Cancel-Button</font></i>
  R.Assign(<font color="#0077BB">19</font>, <font color="#0077BB">9</font>, <font color="#0077BB">32</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~T~ag'</font>, cmTag, bfNormal)));
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  R.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">9</font>, <font color="#0077BB">17</font>, <font color="#0077BB">10</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
</code></pre>
Im EventHandle, wird die Zahl im Button beim Drücken erhöht.<br>
Das sieht man, warum man den <b>CounterButton</b> braucht, ohne dem hätte man keinen Zugriff auf <b>Titel</b>.<br>
Wichtig, wen man eine Komponente ändert, muss man mit <b>Draw</b> die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyDialog.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">var</font></b>
  s: <b><font color="0000BB">string</font></b>;
<br>
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evCommand: <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmTag: <b><font color="0000BB">begin</font></b>
          str(ListBox^.Focused + <font color="#0077BB">1</font>, s);
          MessageBox(<font color="#FF0000">'Wochentag: '</font> + s + <font color="#FF0000">' gew'</font> + <font color="#FF0000">#132</font> + <font color="#FF0000">'hlt'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
          ClearEvent(Event);   <i><font color="#FFFF00">// Event beenden.</font></i>
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;
<br>
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
