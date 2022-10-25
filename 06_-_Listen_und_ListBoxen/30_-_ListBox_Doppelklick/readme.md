# 06 - Listen und ListBoxen
## 30 - ListBox Doppelklick
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Will man bei einer <b>ListBox</b> den Doppelklick auswerten, muss man die ListBox vererben und einen neuen Handleevent einfügen.<br>
<hr><br>
<hr><br>
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der ListBox<br>
```pascalunit MyDialog;
```
Das Vererben der ListBox.<br>
Wen man schon vererbt, habe ich auch gleich den <b>Destructor</b> eingefügt, welcher am Schluss die Liste aufräumt.<br>
```pascaltype
<br>
  PNewListBox = ^TNewListBox;
<br>
  { TNewListBox }
<br>
  TNewListBox = object(TListBox)
    destructor Done; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
<br>
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    ListBox: PNewListBox;
    StringCollection: PUnSortedStrCollection;
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
```
Der neue <b>HandleEvent</b> der beuen ListBox, welcher den Doppelklick abfängt und ihn als [Ok] interprediert.<br>
```pascalprocedure TNewListBox.HandleEvent(var Event: TEvent);
begin
  if (Event.What = evMouseDown) and (Event.double) then begin
    Event.What := evCommand;
    Event.Command := cmOK;
    PutEvent(Event);
    ClearEvent(Event);
  end;
  inherited HandleEvent(Event);
end;
```
Manuell den Speicher der Liste frei geben.<br>
```pascaldestructor TNewListBox.Done;
begin
  Dispose(List, Done); // Die Liste freigeben
  inherited Done;
end;
```
Der EventHandle des Dialogs.<br>
Hier wird einfach ein [Ok] bei dem Doppelklick abgearbeitet.<br>
```pascalprocedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        // Bei Doppelklick auf die ListBox oder beim [Ok] klicken.
        cmOK: begin
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' gew' + #132 + 'hlt', nil, mfOKButton);
        end;
        cmTag: begin
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' gew' + #132 + 'hlt', nil, mfOKButton);
          // Event beenden.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;
```
<br>
