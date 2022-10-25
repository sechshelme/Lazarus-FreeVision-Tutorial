# 11 - Fenster
## 00 - Erstes Fenster
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Erstes Memo-Fenster.<br>
<hr><br>
Der Constructor wird vererbt, so das von Anfang an ein neues Fenster erstellt wird.<br>
```pascal
type
  TMyApp = object(TApplication)
    constructor Init;
<br>
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
<br>
    procedure NewWindows;
  end;
```
```pascal
  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewWindows;       // Fenster erzeugen.
  end;
```
Neues Fenster erzeugen. Fenster werden in der Regel nicht modal geöffnet, da man meistens mehrere davon öffnen will.<br>
```pascal
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    R: TRect;
  begin
    R.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(R, 'Fenster', wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;
```
<br>
