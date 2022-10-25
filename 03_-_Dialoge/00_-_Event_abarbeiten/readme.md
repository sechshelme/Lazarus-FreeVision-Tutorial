# 03 - Dialoge
## 00 - Event abarbeiten
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>
---
<br>

```pascal
const
  cmAbout = 1001;     // About anzeigen
  cmList = 1002;      // Datei Liste
```
<br>

<br>
```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  end;
```
<br>

<br>
```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin    // Mache was mit cmAbout.
        end;
        cmList: begin     // Mache was mit cmList.
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```
<br>

