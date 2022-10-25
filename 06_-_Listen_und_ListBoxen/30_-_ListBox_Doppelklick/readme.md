# 06 - Listen und ListBoxen
## 30 - ListBox Doppelklick
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>
---
---
<br>

<br>

```pascal
unit MyDialog;
<br>
```
<br>

<br>

```pascal
type
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
<br>
```
<br>

<br>
```pascal
procedure TNewListBox.HandleEvent(var Event: TEvent);
begin
  if (Event.What = evMouseDown) and (Event.double) then begin
    Event.What := evCommand;
    Event.Command := cmOK;
    PutEvent(Event);
    ClearEvent(Event);
  end;
  inherited HandleEvent(Event);
end;
<br>
```
<br>

<br>
```pascal
destructor TNewListBox.Done;
begin
  Dispose(List, Done); // Die Liste freigeben
  inherited Done;
end;
<br>
```
<br>

<br>

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
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
<br>
```
<br>

