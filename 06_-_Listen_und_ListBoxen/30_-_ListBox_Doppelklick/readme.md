<html>
    <b><h1>06 - Listen und ListBoxen</h1></b>
    <b><h2>30 - ListBox Doppelklick</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Will man bei einer <b>ListBox</b> den Doppelklick auswerten, muss man die ListBox vererben und einen neuen Handleevent einfügen.<br>
<hr><br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der ListBox<br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Das Vererben der ListBox.<br>
Wen man schon vererbt, habe ich auch gleich den <b>Destructor</b> eingefügt, welcher am Schluss die Liste aufräumt.<br>
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
Der neue <b>HandleEvent</b> der beuen ListBox, welcher den Doppelklick abfängt und ihn als [Ok] interprediert.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TNewListBox.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">if</font></b> (Event.What = evMouseDown) <b><font color="0000BB">and</font></b> (Event.double) <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
    Event.What := evCommand;
    Event.Command := cmOK;
    PutEvent(Event);
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<b><font color="0000BB">end</font></b>;
</code></pre>
Manuell den Speicher der Liste frei geben.<br>
<pre><code><b><font color="0000BB">destructor</font></b> TNewListBox.Done;
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">Dispose</font></b>(List, Done); <i><font color="#FFFF00">// Die Liste freigeben</font></i>
  <b><font color="0000BB">inherited</font></b> Done;
<b><font color="0000BB">end</font></b>;
</code></pre>
Der EventHandle des Dialogs.<br>
Hier wird einfach ein [Ok] bei dem Doppelklick abgearbeitet.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyDialog.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evCommand: <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        <i><font color="#FFFF00">// Bei Doppelklick auf die ListBox oder beim [Ok] klicken.</font></i>
        cmOK: <b><font color="0000BB">begin</font></b>
          MessageBox(<font color="#FF0000">'Wochentag: '</font> + PString(ListBox^.GetFocusedItem)^ + <font color="#FF0000">' gew'</font> + <font color="#FF0000">#132</font> + <font color="#FF0000">'hlt'</font>, <b><font color="0000BB">nil</font></b>, mfOKButton);
        <b><font color="0000BB">end</font></b>;
        cmTag: <b><font color="0000BB">begin</font></b>
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
</html>
