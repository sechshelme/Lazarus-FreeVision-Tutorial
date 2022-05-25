<html>
    <b><h1>04 Dialoge als Komponente</h1></b>
    <b><h2>08 Event an Dialog uebergeben</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird gezeigt, wie man ein Event an eine andere Komponente senden kann.<br>
In diesem Fall wird ein Event an die Dialoge gesendet. In den Dialogen wird dann ein Counter hochgezählt.<br>
Events für den Buttonklick.<br>
<pre><code><b><font color="0000BB">const</font></b>
  cmDia1   = <font color="#0077BB">1001</font>;
  cmDia2   = <font color="#0077BB">1002</font>;
  cmDiaAll = <font color="#0077BB">1003</font>;</code></pre>
Hier werden die 2 passiven Ausgabe-Dialoge erstellt, dies befinden sich in dem Object TMyDialog.<br>
Auserdem wird ein Dialog erstellt, welcher 3 Button erhält, welche dann die Kommandos an die anderen Dialoge sendet.<br>
<pre><code>  <b><font color="0000BB">constructor</font></b> TMyApp.Init;
  <b><font color="0000BB">var</font></b>
    Rect: TRect;
    Dia: PDialog;
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> init;
<br>
    <i><font color="#FFFF00">// erster passsiver Dialog</font></i>
    Rect.Assign(<font color="#0077BB">45</font>, <font color="#0077BB">2</font>, <font color="#0077BB">70</font>, <font color="#0077BB">9</font>);
    Dialog1 := <b><font color="0000BB">New</font></b>(PMyDialog, Init(Rect, <font color="#FF0000">'Dialog 1'</font>));
    Dialog1^.SetState(sfDisabled, <b><font color="0000BB">True</font></b>);    <i><font color="#FFFF00">// Dialog auf ReadOnly.</font></i>
    <b><font color="0000BB">if</font></b> ValidView(Dialog1) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b> <i><font color="#FFFF00">// Prüfen ob genügend Speicher.</font></i>
      Desktop^.Insert(Dialog1);
    <b><font color="0000BB">end</font></b>;
<br>
    <i><font color="#FFFF00">// zweiter passsiver Dialog</font></i>
    Rect.Assign(<font color="#0077BB">45</font>, <font color="#0077BB">12</font>, <font color="#0077BB">70</font>, <font color="#0077BB">19</font>);
    Dialog2 := <b><font color="0000BB">New</font></b>(PMyDialog, Init(Rect, <font color="#FF0000">'Dialog 2'</font>));
    Dialog2^.SetState(sfDisabled, <b><font color="0000BB">True</font></b>);
    <b><font color="0000BB">if</font></b> ValidView(Dialog2) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Dialog2);
    <b><font color="0000BB">end</font></b>;
<br>
    <i><font color="#FFFF00">// Steuerdialog</font></i>
    Rect.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">5</font>, <font color="#0077BB">30</font>, <font color="#0077BB">20</font>);
    Dia := <b><font color="0000BB">New</font></b>(PDialog, Init(Rect, <font color="#FF0000">'Steuerung'</font>));
<br>
    <b><font color="0000BB">with</font></b> Dia^ <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
      Rect.Assign(<font color="#0077BB">6</font>, <font color="#0077BB">2</font>, <font color="#0077BB">18</font>, <font color="#0077BB">4</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(Rect, <font color="#FF0000">'Dialog ~1~'</font>, cmDia1, bfNormal)));
<br>
      Rect.Assign(<font color="#0077BB">6</font>, <font color="#0077BB">5</font>, <font color="#0077BB">18</font>, <font color="#0077BB">7</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(Rect, <font color="#FF0000">'Dialog ~2~'</font>, cmDia2, bfNormal)));
<br>
      Rect.Assign(<font color="#0077BB">6</font>, <font color="#0077BB">8</font>, <font color="#0077BB">18</font>, <font color="#0077BB">10</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(Rect, <font color="#FF0000">'~A~lle'</font>, cmDiaAll, bfNormal)));
<br>
      Rect.Assign(<font color="#0077BB">6</font>, <font color="#0077BB">12</font>, <font color="#0077BB">18</font>, <font color="#0077BB">14</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(Rect, <font color="#FF0000">'~B~eenden'</font>, cmQuit, bfNormal)));
    <b><font color="0000BB">end</font></b>;
<br>
    <b><font color="0000BB">if</font></b> ValidView(Dia) <> <b><font color="0000BB">nil</font></b> <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      Desktop^.Insert(Dia);
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;</code></pre>
Hier werden mit <b>Message</b>, die Kommandos an die Dialoge gesendet.<br>
Gibt man als ersten Parameter die View des Dialoges an, dann wird nur dieser Dialog angesprochen.<br>
Gibt man <b>@Self</b> an, dann werden die Kommandos an alle Dialoge gesendet.<br>
Beim 4. Paramter kann man noch einen Pointer auf einen Bezeichner übergeben,<br>
die kann zB. ein String oder ein Record, etc. sein.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
  <b><font color="0000BB">begin</font></b>
    <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
    <b><font color="0000BB">if</font></b> Event.What = evCommand <b><font color="0000BB">then</font></b> <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmDia1: <b><font color="0000BB">begin</font></b>
          Message(Dialog1, evBroadcast, cmCounterUp, <b><font color="0000BB">nil</font></b>); <i><font color="#FFFF00">// Kommando Dialog 1</font></i>
        <b><font color="0000BB">end</font></b>;
        cmDia2: <b><font color="0000BB">begin</font></b>
          Message(Dialog2, evBroadcast, cmCounterUp, <b><font color="0000BB">nil</font></b>); <i><font color="#FFFF00">// Kommando Dialog 2</font></i>
        <b><font color="0000BB">end</font></b>;
        cmDiaAll: <b><font color="0000BB">begin</font></b>
          Message(@<b><font color="0000BB">Self</font></b>, evBroadcast, cmCounterUp, <b><font color="0000BB">nil</font></b>);   <i><font color="#FFFF00">// Kommando an alle Dialoge</font></i>
        <b><font color="0000BB">end</font></b>;
        <b><font color="0000BB">else</font></b> <b><font color="0000BB">begin</font></b>
          <b><font color="0000BB">Exit</font></b>;
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
    ClearEvent(Event);
  <b><font color="0000BB">end</font></b>;</code></pre>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der Zähler-Ausgabe.<br>
<pre><code><b><font color="0000BB">unit</font></b> MyDialog;
</code></pre>
Deklaration des Object der passiven Dialoge.<br>
<pre><code><b><font color="0000BB">type</font></b>
  PMyDialog = ^TMyDialog;
  TMyDialog = <b><font color="0000BB">object</font></b>(TDialog)
  <b><font color="0000BB">var</font></b>
    CounterInputLine: PInputLine; <i><font color="#FFFF00">// Ausgabe Zeile für den Counter.</font></i>
<br>
    <b><font color="0000BB">constructor</font></b> Init(<b><font color="0000BB">var</font></b> Bounds: TRect; ATitle: TTitleStr);
    <b><font color="0000BB">procedure</font></b> HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent); <b><font color="0000BB">virtual</font></b>;
  <b><font color="0000BB">end</font></b>;
</code></pre>
Im Konstructor wird eine Ausgabezeile erzeugt.<br>
<pre><code><b><font color="0000BB">constructor</font></b> TMyDialog.Init(<b><font color="0000BB">var</font></b> Bounds: TRect; ATitle: TTitleStr);
<b><font color="0000BB">var</font></b>
  Rect: TRect;
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> Init(Bounds, ATitle);
<br>
  Rect.Assign(<font color="#0077BB">5</font>, <font color="#0077BB">2</font>, <font color="#0077BB">10</font>, <font color="#0077BB">3</font>);
  CounterInputLine := <b><font color="0000BB">new</font></b>(PInputLine, Init(Rect, <font color="#0077BB">20</font>));
  CounterInputLine^.Data^ := <font color="#FF0000">'0'</font>;
  Insert(CounterInputLine);
<b><font color="0000BB">end</font></b>;
</code></pre>
Im EventHandle wird das Kommando empfangen, welches mit <b>Message</b> gesendet wurde.<br>
Als Beweis dafür, wir die Zahl in der Ausgabezeile un eins erhöht.<br>
<pre><code><b><font color="0000BB">procedure</font></b> TMyDialog.HandleEvent(<b><font color="0000BB">var</font></b> Event: TEvent);
<b><font color="0000BB">var</font></b>
  Counter: integer;
<b><font color="0000BB">begin</font></b>
  <b><font color="0000BB">inherited</font></b> HandleEvent(Event);
<br>
  <b><font color="0000BB">case</font></b> Event.What <b><font color="0000BB">of</font></b>
    evBroadcast: <b><font color="0000BB">begin</font></b>
      <b><font color="0000BB">case</font></b> Event.Command <b><font color="0000BB">of</font></b>
        cmCounterUp: <b><font color="0000BB">begin</font></b>                              <i><font color="#FFFF00">// cmCounterUp wurde mit Message gesendet.</font></i>
          Counter := StrToInt(CounterInputLine^.Data^); <i><font color="#FFFF00">// Ausgabezeile auslesen.</font></i>
          Inc(Counter);                                 <i><font color="#FFFF00">// Counter erhöhen.</font></i>
          CounterInputLine^.Data^ := IntToStr(Counter); <i><font color="#FFFF00">// Neue Zahl ausgeben.</font></i>
          CounterInputLine^.Draw;                       <i><font color="#FFFF00">// Asugabezeile aktualisieren.</font></i>
        <b><font color="0000BB">end</font></b>;
      <b><font color="0000BB">end</font></b>;
    <b><font color="0000BB">end</font></b>;
  <b><font color="0000BB">end</font></b>;
<br>
<b><font color="0000BB">end</font></b>;
</code></pre>
<br>
</html>
