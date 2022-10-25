# 04 - Dialoge als Komponente
## 15 - Verschiedene Dialog Farben
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

<br>
```pascal
Editor-Fenster : Blau
Dialog         : Grau
Hilfe-Fenster  : Cyan
```
<br>

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
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    CounterButton: PButton; // Button mit Zähler.
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
<br>
```
<br>

<br>
```pascal
const
  cmBlue = 1006;
  cmCyan = 1007;
  cmGray = 1008;
<br>
constructor TMyDialog.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);
  inherited Init(R, 'Mein Dialog');
<br>
  // StaticText
  R.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(R, 'W' + #132 + 'hle eine Farbe')));
<br>
  // Farbe
  R.Assign(7, 5, 15, 7);
  Insert(new(PButton, Init(R, 'blue', cmBlue, bfNormal)));
  R.Assign(17, 5, 25, 7);
  Insert(new(PButton, Init(R, 'cyan', cmCyan, bfNormal)));
  R.Assign(27, 5, 35, 7);
  Insert(new(PButton, Init(R, 'gray', cmGray, bfNormal)));
<br>
  // Ok-Button
  R.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
<br>
```
<br>

<br>

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);    // Vorfahre aufrufen.
<br>
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmBlue: begin
          Palette := dpBlueDialog; // Palette zuordnen, hier blau.
          Draw;                    // Dialog neu zeichnen.
          ClearEvent(Event);       // Das Event ist abgeschlossen.
        end;
        cmCyan: begin
          Palette := dpCyanDialog;
          Draw;
          ClearEvent(Event);
        end;
        cmGray: begin
          Palette := dpGrayDialog;
          Draw;
          ClearEvent(Event);
        end;
      end;
    end;
  end;
<br>
end;
<br>
```
<br>

