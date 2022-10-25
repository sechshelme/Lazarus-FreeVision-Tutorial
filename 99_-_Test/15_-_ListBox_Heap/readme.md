# 99 - Test
## 15 - ListBox Heap
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

<br>

```pascal
  procedure TMyApp.NewWindows(Titel: ShortString);
  var
    Win: PWindow;
    R: TRect;
  begin
    R.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(R, Titel, wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;
```
<br>
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
const
  cmTag = 1000;  // Lokale Event Konstante
<br>
```
<br>

<br>

<br>
```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          MessageBox('Wochentag: ' + PString(ListBox^.GetFocusedItem)^ + ' gew' + #132 + 'hlt', nil, mfOKButton);
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
<br>
```
<br>

