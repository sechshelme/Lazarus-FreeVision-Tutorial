# 90 - Experimente
## 35 - HistoryViewer
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Bei der TListBox muss man unbedingt mit einem Destructor den Speicher der TList freigeben.<br>
Dies ist nicht Free-Vision üblich. Dies hat auch einen Sinn, da man Listen vielfach global verwendet, <br>
ansonsten müsste man immer eine Kopie davon anlegen.<br>
Dort fehlt der <b>destructor</b>, welcher den Speicher aufräumt.<br>
<hr><br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der ListBox<br>
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
<pre><code>const
  cmTag = 1000;  // Lokale Event Konstante</font>
<br>
constructor TMyDialog.Init;
var
  R: TRect;
  HScrollBar, VScrollBar: PScrollBar;
  i: Integer;
  hw:PHistoryViewer;
const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');</font>
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
  // HScrollBar für ListBox
  R.Assign(5, 7, 31, 8);</font>
  HScrollBar := new(PScrollBar, Init(R));
  Insert(HScrollBar);
<br>
  // VScrollBar für ListBox
  R.Assign(31, 2, 32, 7);</font>
  VScrollBar := new(PScrollBar, Init(R));
  Insert(VScrollBar);
<br>
  //// ListBox
  //R.A.X := 5;
  //Dec(R.B.X, 1);
  //ListBox := new(PListBox, Init(R, 1, VScrollBar));
  //ListBox^.NewList(StringCollection);
  //Insert(ListBox);
<br>
  // ListBox
  R.A.X := 5;</font>
  Dec(R.B.X, 1);</font>
  hw := new(PHistoryViewer, Init(R, HScrollBar, VScrollBar,1));</font>
//  hw^.NewList(StringCollection);
  Insert(hw);
<br>

<br>
  // Tag-Button
  R.Assign(5, 9, 18, 11);</font>
  Insert(new(PButton, Init(R, '~T~ag', cmTag, bfNormal)));</font>
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
//  Dispose(ListBox^.List, Done); // Die Liste freigeben
  inherited Done;
end;
</code></pre>
Der EventHandle<br>
Wen man auf <b>[Tag]</b> klickt, wird der fokusierte Eintrag der ListBox angezeigt.<br>
<pre><code>procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // mache etwas
        end;
        cmTag: begin
          // Eintrag mit Fokus auslesen
          // Und ausgeben
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' gew' + #132 + 'hlt', nil, mfOKButton);
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
