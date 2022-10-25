# 11 - Fenster
## 05 - Fenster neu und schliessen
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>
---
<br>

<br>
```pascal
const
  cmNewWin = 1001;
type
  TMyApp = object(TApplication)
    constructor Init;
<br>
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
<br>
    procedure HandleEvent(var Event: TEvent); virtual; // Abarbeitung Kommandos
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
<br>
    procedure NewWindows;
  end;
```
<br>

<br>
```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
      NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
      NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
      NewLine(
      NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil))))), nil))));
  end;
```
<br>

<br>

```pascal
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    R: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PWindow, Init(R, 'Fenster', WinCounter));
    // Wen zu wenig Speicher für Fenster, dann Counter wieder -1.
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
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
        cmNewWin: begin
          NewWindows;    // Fenster erzeugen.
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

