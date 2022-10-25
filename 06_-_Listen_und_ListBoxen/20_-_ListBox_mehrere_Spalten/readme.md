# 06 - Listen und ListBoxen
## 20 - ListBox mehrere Spalten
<img src="image.png" alt="Selfhtml"><br><br>
Die <b>ListBox</b> kann auch mehrere Spalten haben.<br>
---
---
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der mehrspaltigen ListBox<br>
<pre><code>unit MyDialog;
</code></pre>
Den <b>Destructor</b> deklarieren, welcher den <b>Speicher</b> der List frei gibt.<br>
<pre><code>type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    ListBox: PListBox;
    StringCollection: PUnSortedStrCollection;
<br>
    constructor Init;
    destructor Done; virtual;  // Wegen Speicher Leak in TList
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
</code></pre>
Komponenten für den Dialog generieren.<br>
Der zweite Parameter bei Init von <b>TListBox</b> gibt die Anzahl Spalten an.<br>
Hier im Beispiel sind es 3.<br>
<pre><code>const
  cmMonat = 1000;  // Lokale Event Konstante</font>
<br>
constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  i: integer;
const
  Tage: array [0..11] of shortstring = (
    'Januar', 'Februar', 'M' + #132'rz', 'April', 'Mai', 'Juni', 'Juli',</font>
    'August', 'September', 'Oktober', 'November', 'Dezember');
<br>
begin
  R.Assign(10, 5, 64, 17);</font>
  inherited Init(R, 'ListBox Demo');</font>
<br>
  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));</font>
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;
<br>
  // ScrollBar für ListBox
  R.Assign(42, 2, 43, 7);</font>
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);
<br>
  // ListBox
  R.A.X := 5;</font>
  Dec(R.B.X, 1);</font>
  ListBox := new(PListBox, Init(R, 3, ScrollBar)); // 3 Spalten</font>
  ListBox^.NewList(StringCollection);
  Insert(ListBox);
<br>
  // Tag-Button
  R.Assign(5, 9, 18, 11);</font>
  Insert(new(PButton, Init(R, '~M~onat', cmMonat, bfNormal)));</font>
<br>
  // Cancel-Button
  R.Move(15, 0);</font>
  Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));</font>
<br>
  // Ok-Button
  R.Move(15, 0);</font>
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));</font>
end;
</code></pre>
Manuell den Speicher der Liste frei geben.<br>
<pre><code>destructor TMyDialog.Done;
begin
  Dispose(ListBox^.List, Done); // Die Liste freigeben
  inherited Done;
end;
</code></pre>
Der EventHandle<br>
Wen man auf <b>[Monat]</b> klickt, wird der fokusierte Eintrag der ListBox angezeigt.<br>
<pre><code>procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // mache etwas
        end;
        cmMonat: begin
          // Eintrag mit Fokus auslesen
          // Und ausgeben
          MessageBox('Monat: ' + PString(ListBox^.GetFocusedItem)^ + ' gew' + #132 + 'hlt', nil, mfOKButton);
          // Event beenden.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;
</code></pre>
<br>
