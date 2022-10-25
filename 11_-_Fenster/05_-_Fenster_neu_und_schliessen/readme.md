# 11 - Fenster
## 05 - Fenster neu und schliessen
<img src="image.png" alt="Selfhtml"><br><br>
Über das Menü Fenster erzeigen und schliessen.<br>
---
Neue Konstanten für Kommados.<br>
Auch ist der HandleEvent dazugekommen.<br>
```pascal>const
  cmNewWin = 1001;</font>
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
  end;```
Das Menü wurde um <b>Neu</b> und <b>Schliessen</b> ergänzt.<br>
```pascal>  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;</font>
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(</font>
      NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,</font>
      NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
      NewLine(
      NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil))))), nil))));</font>
  end;```
Beim Fenster erzeugen, ist noch ein Counter hinzugekommen.<br>
Dieser wird benutzt um die Fenster zu nummerieren.<br>
```pascal>  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    R: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster</font>
  begin
    R.Assign(0, 0, 60, 20);</font>
    Inc(WinCounter);
    Win := New(PWindow, Init(R, 'Fenster', WinCounter));</font>
    // Wen zu wenig Speicher für Fenster, dann Counter wieder -1.
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;```
<b>cmNewWin</b> muss man selbst abarbeiten. <b>cmClose</b> für das Schliessen des Fenster läuft es im Hintergrund automatisch.<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
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
  end;```
<br>
