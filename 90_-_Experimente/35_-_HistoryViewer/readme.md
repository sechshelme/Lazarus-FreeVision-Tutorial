# 90 - Experimente
## 35 - HistoryViewer
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Bei der TListBox muss man unbedingt mit einem Destructor den Speicher der TList freigeben.<br>
Dies ist nicht Free-Vision üblich. Dies hat auch einen Sinn, da man Listen vielfach global verwendet, <br>
ansonsten müsste man immer eine Kopie davon anlegen.<br>
Dort fehlt der <b>destructor</b>, welcher den Speicher aufräumt.<br>
---
---
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der ListBox<br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Den <b>Destructor</b> deklarieren, welcher den <b>Speicher</b> der List frei gibt.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyDialog = ^TMyDialog;
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
    ListBox: PListBox;
    StringCollection: PUnSortedStrCollection;
<br>
    <b><font color="0000BB">constructor</font></b> Init;
    <b><font color="0000BB">destructor</font></b> Done; <b><font color="0000BB">virtual</font></b>;  <i><font color="#FFFF00">// Wegen Speicher Leak in TList</font></i>
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Komponenten für den Dialog generieren.<br>
<pre><code><b><font color="0000BB">const</font></b>
  cmTag = <font color="#0077BB">1000</font>;  <i><font color="#FFFF00">// Lokale Event Konstante</font></i>
<br>
<b><font color="0000BB">constructor</font></b> TMyDialog.Init;
<b><font color="0000BB">var</font></b>
  R: TRect;
  HScrollBar, VScrollBar: PScrollBar;
  i: Integer;
  hw:PHistoryViewer;
<b><font color="0000BB">const</font></b>
  Tage: <b><font color="0000BB">array</font></b> [<font color="#0077BB">0</font>..<font color="#0077BB">6</font>] <b><font color="0000BB">of</font></b> shortstring = (
    <font color="#FF0000">'Montag'</font>, <font color="#FF0000">'Dienstag'</font>, <font color="#FF0000">'Mittwoch'</font>, <font color="#FF0000">'Donnerstag'</font>, <font color="#FF0000">'Freitag'</font>, <font color="#FF0000">'Samstag'</font>, <font color="#FF0000">'Sonntag'</font>);
<br>
<b><font color="0000BB">begin</font></b>
  R.Assign(<font color="#0077BB">10</font>, <font color="#0077BB">5</font>, <font color="#0077BB">64</font>, <font color="#0077BB">17</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'ListBox Demo'</font>);
<br>
  <i><font color="#FFFF00">// StringCollection</font></i>
  StringCollection := <b><font color="0000BB">new</font></b>(PUnSortedStrCollection, Init(<font color="#0077BB">5</font>, <font color="#0077BB">5</font>));
  <b><font color="0000BB">for</font></b> i := <font color="#0077BB">0</font> <b><font color="0000BB">to</font></b> Length(Tage) - <font color="#0077BB">1</font> <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
    StringCollection^.Insert(NewStr(Tage[i]));
  <b><font color="0000BB">end</font></b>;
<br>
  <i><font color="#FFFF00">// HScrollBar für ListBox</font></i>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">7</font>, <font color="#0077BB">31</font>, <font color="#0077BB">8</font>);
  HScrollBar := <b><font color="0000BB">new</font></b>(PScrollBar, Init(R));
  Insert(HScrollBar);
<br>
  <i><font color="#FFFF00">// VScrollBar für ListBox</font></i>
  R.Assign(<font color="#0077BB">31</font>, <font color="#0077BB">2</font>, <font color="#0077BB">32</font>, <font color="#0077BB">7</font>);
  VScrollBar := <b><font color="0000BB">new</font></b>(PScrollBar, Init(R));
  Insert(VScrollBar);
<br>
  <i><font color="#FFFF00">//// ListBox</font></i>
  <i><font color="#FFFF00">//R.A.X := 5;</font></i>
  <i><font color="#FFFF00">//Dec(R.B.X, 1);</font></i>
  <i><font color="#FFFF00">//ListBox := new(PListBox, Init(R, 1, VScrollBar));</font></i>
  <i><font color="#FFFF00">//ListBox^.NewList(StringCollection);</font></i>
  <i><font color="#FFFF00">//Insert(ListBox);</font></i>
<br>
  <i><font color="#FFFF00">// ListBox</font></i>
  R.A.X := <font color="#0077BB">5</font>;
  Dec(R.B.X, <font color="#0077BB">1</font>);
  hw := <b><font color="0000BB">new</font></b>(PHistoryViewer, Init(R, HScrollBar, VScrollBar,<font color="#0077BB">1</font>));
<i><font color="#FFFF00">//  hw^.NewList(StringCollection);</font></i>
  Insert(hw);
<br>

<br>
  <i><font color="#FFFF00">// Tag-Button</font></i>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">9</font>, <font color="#0077BB">18</font>, <font color="#0077BB">11</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~T~ag'</font>, cmTag, bfNormal)));
<br>
  <i><font color="#FFFF00">// Cancel-Button</font></i>
  R.Move(<font color="#0077BB">15</font>, <font color="#0077BB">0</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~C~ancel'</font>, cmCancel, bfNormal)));
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  R.Move(<font color="#0077BB">15</font>, <font color="#0077BB">0</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
</code></pre>
Manuell den Speicher der Liste frei geben.<br>
<pre><code><b><font color="0000BB">destructor</font></b> TMyDialog.Done;
<b><font color="0000BB">begin</font></b>
<i><font color="#FFFF00">//  Dispose(ListBox^.List, Done); // Die Liste freigeben</font></i>
  <b><font color="0000BB">inherited</font></b> Done;
<b><font color="0000BB">end</font></b>;
</code></pre>
Der EventHandle<br>
Wen man auf <b>[Tag]</b> klickt, wird der fokusierte Eintrag der ListBox angezeigt.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyDialog.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evCommand: <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmOK: <b><font color="0000BB">begin</font></b>
          <i><font color="#FFFF00">// mache etwas</font></i>
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
