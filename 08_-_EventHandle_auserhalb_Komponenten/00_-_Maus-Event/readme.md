# 08 - EventHandle auserhalb Komponenten
## 00 - Maus-Event
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Man kann einen EventHandle im Dialog/Fenster abfangen, wen man die Maus bewegt/klickt.<br>
Im Hauptprogramm hat es dafür nichts besonders, dies alles läuft lokal im Dialog/Fenster ab.<br>
---
<br>
Im Hauptprogramm wird nur der Dialog gebaut, aufgerufe und geschlossen.<br>
<pre><code=pascal>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">var</font></b>
    MouseDialog: PMyMouse;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmMouseAktion: <b><font color="0000BB">begin</font></b>
          MouseDialog := <b><font color="0000BB">New</font></b>(PMyMouse, Init);
          <b><font color="0000BB">if</font></b> ValidView(MouseDialog) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b> <i><font color="#FFFF00">// Prüfen ob genügend Speicher.</font></i>
            Desktop^.ExecView(MouseDialog);           <i><font color="#FFFF00">// Dialog Mausaktion ausführen.</font></i>
            <b><font color="0000BB">Dispose</font></b>(MouseDialog, Done);               <i><font color="#FFFF00">// Dialog und Speicher frei geben.</font></i>
          <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
---
<br>
<b>Unit mit dem Mausaktions-Dialog.</b><br>
<br><br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
In dem Object sind die <b>PEditLine</b> globel deklariert, da diese später bei Mausaktionen modifiziert werden.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyMouse = ^TMyMouse;
  TMyMouse = <b><font color="0000BB">object</font></b>(TDialog)
    EditMB,
    EditX, EditY: PInputLine;
<br>
    <b><font color="0000BB">constructor</font></b> Init;
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Es wird ein Dialog mit EditLine, Label und Button gebaut.<br>
Einzig besonderes dort, die <b>Editlline</b> wird der Status auf <b>ReadOnly</b> gesetzt eigene Eingaben sind dort unerwünscht.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyMouse.Init;
<b><font color="0000BB">var</font></b>
  R: TRect;
<b><font color="0000BB">begin</font></b>
  R.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">42</font>, <font color="#0077BB">13</font>);
  R.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);
  <b><font color="0000BB">inherited</font></b> Init(R, <font color="#FF0000">'Mausaktion'</font>);
<br>
  <i><font color="#FFFF00">// PosX</font></i>
  R.Assign(<font color="#0077BB">25</font>, <font color="#0077BB">2</font>, <font color="#0077BB">30</font>, <font color="#0077BB">3</font>);
  EditX := <b><font color="0000BB">new</font></b>(PInputLine, Init(R, <font color="#0077BB">5</font>));
  Insert(EditX);
  EditX^.State := sfDisabled <b><font color="0000BB">or</font></b> EditX^.State;    <i><font color="#FFFF00">// ReadOnly</font></i>
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">2</font>, <font color="#0077BB">20</font>, <font color="#0077BB">3</font>);
  Insert(<b><font color="0000BB">New</font></b>(PLabel, Init(R, <font color="#FF0000">'MausPosition ~X~:'</font>, EditX)));
<br>
  <i><font color="#FFFF00">// PosY</font></i>
  R.Assign(<font color="#0077BB">25</font>, <font color="#0077BB">4</font>, <font color="#0077BB">30</font>, <font color="#0077BB">5</font>);
  EditY := <b><font color="0000BB">new</font></b>(PInputLine, Init(R, <font color="#0077BB">5</font>));
  EditY^.State := sfDisabled <b><font color="0000BB">or</font></b> EditY^.State;    <i><font color="#FFFF00">// ReadOnly</font></i>
  Insert(EditY);
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">4</font>, <font color="#0077BB">20</font>, <font color="#0077BB">5</font>);
  Insert(<b><font color="0000BB">New</font></b>(PLabel, Init(R, <font color="#FF0000">'MausPosition ~Y~:'</font>, EditY)));
<br>
  <i><font color="#FFFF00">// Maus-Tasten</font></i>
  R.Assign(<font color="#0077BB">25</font>, <font color="#0077BB">7</font>, <font color="#0077BB">32</font>, <font color="#0077BB">8</font>);
  EditMB := <b><font color="0000BB">new</font></b>(PInputLine, Init(R, <font color="#0077BB">7</font>));
  EditMB^.State := sfDisabled <b><font color="0000BB">or</font></b> EditMB^.State;  <i><font color="#FFFF00">// ReadOnly</font></i>
  EditMB^.Data^:= <font color="#FF0000">'oben'</font>;                        <i><font color="#FFFF00">// Anfangs ist die Taste oben.</font></i>
  Insert(EditMB);
  R.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">7</font>, <font color="#0077BB">20</font>, <font color="#0077BB">8</font>);
  Insert(<b><font color="0000BB">New</font></b>(PLabel, Init(R, <font color="#FF0000">'~M~austaste:'</font>, EditMB)));
<br>
  <i><font color="#FFFF00">// Ok-Button</font></i>
  R.Assign(<font color="#0077BB">27</font>, <font color="#0077BB">10</font>, <font color="#0077BB">37</font>, <font color="#0077BB">12</font>);
  Insert(<b><font color="0000BB">new</font></b>(PButton, Init(R, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<b><font color="0000BB">end</font></b>;
</code></pre>
Im EventHandle sieht man gut, das dort die Mausaktionen abgefangen werden.<br>
Die Maus-Daten werden an die <b>EditLines</b> ausgegeben.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyMouse.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">var</font></b>
  Mouse : TPoint;
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evMouseDown: <b><font color="0000BB">begin</font></b>                 <i><font color="#FFFF00">// Taste wurde gedrückt.</font></i>
      EditMB^.Data^:= <font color="#FF0000">'unten'</font>;
      EditMB^.Draw;
    <b><font color="0000BB">end</font></b>;
    evMouseUp: <b><font color="0000BB">begin</font></b>                   <i><font color="#FFFF00">// Taste wurde losgelassen.</font></i>
      EditMB^.Data^:= <font color="#FF0000">'oben'</font>;
      EditMB^.Draw;
    <b><font color="0000BB">end</font></b>;
    evMouseMove: <b><font color="0000BB">begin</font></b>                 <i><font color="#FFFF00">// Maus wurde bewegt.</font></i>
      MakeLocal (Event.Where, Mouse);  <i><font color="#FFFF00">// Mausposition ermitteln.</font></i>
      EditX^.Data^:= IntToStr(Mouse.X);
      EditX^.Draw;
      EditY^.Data^:= IntToStr(Mouse.Y);
      EditY^.Draw;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;
<br>
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
