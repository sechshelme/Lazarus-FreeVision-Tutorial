# 30 - Gadgets
## 05 - Eine Uhr
<br>
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird ein kleines Gadgets geladen, welches eine <b>Uhr</b> anzeigt.<br>
<hr><br>
    Erzeugt ein kleines Fenster rechts-unten, welches die Uhr anzeigt.<br>
<pre><code=pascal>    GetExtent(R);
    R.A.X := R.B.X - 9;</font>
    R.A.Y := R.B.Y - 1;</font>
    Heap := New(PClockView, Init(R));
    Insert(Heap); </code></pre>
Den Dialog mit dem Speicher Leak aufrufen.<br>
<pre><code=pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        // Dialog mit der ListBox, welcher ein Speicher Leak hat.
        cmDialog: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin
            Desktop^.ExecView(MyDialog);   // Dialog ausführen.
            Dispose(MyDialog, Done);       // Dialog und Speicher frei geben.
          end;
        end;
        // Ein FileOpenDialog, bei dem alles in Ordnung ist.
        cmFileTest:begin
          FileName := '*.*';</font>
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOpenButton, 1));</font>
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            NewWindows(FileName); // Neues Fenster mit der ausgewählten Datei.
          end;
        end
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;</code></pre>
Die Idle Routine, welche im Leerlauf den Heap prüft und anzeigt.<br>
<pre><code=pascal>  procedure TMyApp.Idle;
<br>
    function IsTileable(P: PView): Boolean;
    begin
      Result := (P^.Options and ofTileable <> 0) and (P^.State and sfVisible <> 0);</font>
    end;
<br>
  begin
    inherited Idle;
    Heap^.Update;
    if Desktop^.FirstThat(@IsTileable) <> nil then begin
      EnableCommands([cmTile, cmCascade])
    end else begin
      DisableCommands([cmTile, cmCascade]);
    end;
  end;</code></pre>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit dem dem Speicher Leak<br>
<pre><code>unit MyDialog;
</code></pre>
Den <b>Destructor</b> deklarieren, welcher das <b>Speicher Leak</b> behebt.<br>
<pre><code>type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
  const
    cmTag = 1000;  // Lokale Event Konstante</font>
  var
    ListBox: PListBox;
    StringCollection: PStringCollection;
<br>
    constructor Init;
    destructor Done; virtual;  // Wegen Speicher Leak
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
</code></pre>
Komponenten für den Dialog generieren.<br>
<pre><code>constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  i: Sw_Integer;
const
  Tage: array [0..6] of shortstring = (
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag');</font>
<br>
begin
  R.Assign(10, 5, 64, 17);</font>
  inherited Init(R, 'ListBox Demo');</font>
<br>
  // StringCollection
  StringCollection := new(PStringCollection, Init(5, 5));</font>
  for i := 0 to Length(Tage) - 1 do begin
    StringCollection^.Insert(NewStr(Tage[i]));
  end;
<br>
  // ScrollBar für ListBox
  R.Assign(31, 2, 32, 7);</font>
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);
<br>
  // ListBox
  R.Assign(5, 2, 31, 7);</font>
  ListBox := new(PListBox, Init(R, 1, ScrollBar));</font>
  ListBox^.NewList(StringCollection);
  Insert(ListBox);
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
Manuell den Speicher frei geben.<br>
Man kann hier versuchsweise das Dispose ausklammern, dann sieht man,<br>
das man eine Speicherleak bekommt.<br>
<pre><code>destructor TMyDialog.Done;
begin
   Dispose(ListBox^.List, Done); // Dies Versuchsweise ausklammern
   inherited Done;
end;
</code></pre>
Der EventHandle<br>
<pre><code>procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  s: ShortString;
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // mache etwas
        end;
        cmTag: begin
          str(ListBox^.Focused + 1, s);</font>
          MessageBox('Wochentag: ' + s + ' gew' + #132 + 'hlt', nil, mfOKButton);
          ClearEvent(Event);  // Event beenden.
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;
</code></pre>
<br>
