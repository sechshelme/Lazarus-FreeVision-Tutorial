<html>
    <b><h1>90 Experimente</h1></b>
    <b><h2>10 2 Desktop</h2></b>
<img src="image.png" alt="Selfhtml"><br><br>
Dialog um Buttons ergänzen.<br>
<hr><br>
Den Dialog mit Buttons ergänzen.<br>
Mit <b>Insert</b> fügt man die Komponenten hinzug, in diesem Fall sind es die Buttons.<br>
Mit bfDefault legt man den Default-Button fest, dieser wird mit <b>[Enter]</b> aktiviert.<br>
bfNormal ist ein gewöhnlicher Button.<br>
Der Dialog wird nun Modal geöffnet, somit können <b>keine</b> weiteren Dialoge geöffnet werden.<br>
dummy hat den Wert, des Button der gedrückt wurde, dies entspricht dem <b>cmxxx</b> Wert.<br>
Die Höhe der Buttons muss immer <b>2</b> sein, ansonsten gibt es eine fehlerhafte Darstellung.<br>
<pre><code>  <b><font color="0000BB">procedure</font></b> TMyApp.MyParameter;
  <b><font color="0000BB">var</font></b>
    Dia: PDialog;
    Rect: TRect;
    dummy: word;
  <b><font color="0000BB">begin</font></b>
    Rect.Assign(<font color="#0077BB">0</font>, <font color="#0077BB">0</font>, <font color="#0077BB">35</font>, <font color="#0077BB">15</font>);                    <i><font color="#FFFF00">// Grösse des Dialogs.</font></i>
    Rect.Move(<font color="#0077BB">23</font>, <font color="#0077BB">3</font>);                             <i><font color="#FFFF00">// Position des Dialogs.</font></i>
    Dia := <b><font color="0000BB">New</font></b>(PDialog, Init(Rect, <font color="#FF0000">'Parameter'</font>)); <i><font color="#FFFF00">// Dialog erzeugen.</font></i>
    <b><font color="0000BB">with</font></b> Dia^ <b><font color="0000BB">do</font></b> <b><font color="0000BB">begin</font></b>
<br>
      <i><font color="#FFFF00">// Ok-Button</font></i>
      Rect.Assign(<font color="#0077BB">7</font>, <font color="#0077BB">12</font>, <font color="#0077BB">17</font>, <font color="#0077BB">14</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(Rect, <font color="#FF0000">'~O~K'</font>, cmOK, bfDefault)));
<br>
      <i><font color="#FFFF00">// Schliessen-Button</font></i>
      Rect.Assign(<font color="#0077BB">19</font>, <font color="#0077BB">12</font>, <font color="#0077BB">32</font>, <font color="#0077BB">14</font>);
      Insert(<b><font color="0000BB">new</font></b>(PButton, Init(Rect, <font color="#FF0000">'~A~bbruch'</font>, cmCancel, bfNormal)));
    <b><font color="0000BB">end</font></b>;
    dummy := Desktop^.ExecView(Dia);   <i><font color="#FFFF00">// Dialog Modal öffnen.</font></i>
    <b><font color="0000BB">Dispose</font></b>(Dia, Done);                <i><font color="#FFFF00">// Dialog und Speicher frei geben.</font></i>
  <b><font color="0000BB">end</font></b>;</code></pre>
<br>
</html>
