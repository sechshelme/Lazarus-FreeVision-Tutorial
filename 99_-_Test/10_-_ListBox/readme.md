# 99 - Test
## 10 - ListBox
<br>
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird gezeigt, wie man Komponenten zu Laufzeit ändern kann.<br>
Dafür wird ein Button verwendet, bei dem sich die Bezeichnung bei jedem Klick erhöht.<br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit dem Zähler-Button.<br>
<pre><code>unit MyDialog;
</code></pre>
Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.<br>
Direkt mit <b>Insert(New(...</b> geht nicht mehr.<br>
<pre><code>type
  PMyDialog = ^TMyDialog;
<br>
  TMyDialog = object(TDialog)
  const
    cmTag = 1000;</font>
  var
    ListBox: PListBox;
<br>
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
</code></pre>
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.<br>
<b>CounterButton</b> wird für die Modifikation gebraucht.<br>
<pre><code>constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  StringCollection: PCollection;
<br>
begin
  R.Assign(10, 5, 67, 17);</font>
  inherited Init(R, 'ListBox Demo');</font>
<br>
  Title := NewStr('dfsfdsa');</font>
<br>
  // ListBox
  R.Assign(31, 2, 32, 7);</font>
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);
<br>
  StringCollection := new(PCollection, Init(0, 1));</font>
  StringCollection^.Insert(NewStr('Montag'));</font>
  StringCollection^.Insert(NewStr('Dienstag'));</font>
  StringCollection^.Insert(NewStr('Mittwoch'));</font>
  StringCollection^.Insert(NewStr('Donnerstag'));</font>
  StringCollection^.Insert(NewStr('Freitag'));</font>
  StringCollection^.Insert(NewStr('Samstag'));</font>
  StringCollection^.Insert(NewStr('Sonntag'));</font>
<br>
  R.Assign(5, 2, 31, 7);</font>
  ListBox := new(PListBox, Init(R, 1, ScrollBar));</font>
  ListBox^.NewList(StringCollection);
<br>
  Insert(ListBox);
  ListBox^.Insert(NewStr('aaaaaaaaa'));</font>
<br>
  ListBox^.List^.Insert(NewStr('bbbbbbb'));</font>
  ListBox^.SetRange(ListBox^.List^.Count);
<br>

<br>
  // Cancel-Button
  R.Assign(19, 9, 32, 10);</font>
  Insert(new(PButton, Init(R, '~T~ag', cmTag, bfNormal)));</font>
<br>
  // Ok-Button
  R.Assign(7, 9, 17, 10);</font>
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
end;
</code></pre>
Im EventHandle, wird die Zahl im Button beim Drücken erhöht.<br>
Das sieht man, warum man den <b>CounterButton</b> braucht, ohne dem hätte man keinen Zugriff auf <b>Titel</b>.<br>
Wichtig, wen man eine Komponente ändert, muss man mit <b>Draw</b> die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.<br>
<pre><code>procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  s: string;
<br>
begin
  inherited HandleEvent(Event);
<br>
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmTag: begin
          str(ListBox^.Focused + 1, s);</font>
          MessageBox('Wochentag: ' + s + ' gew' + #132 + 'hlt', nil, mfOKButton);
          ClearEvent(Event);   // Event beenden.
        end;
      end;
    end;
  end;
<br>
end;
</code></pre>
<br>
