# 20 - Diverses
## 00 - Idle Handle eine Uhr
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<br>

<br>
---
<br>

```pascal
const
  cmNewWin = 1001;
  cmNewUhr = 1002;
```
<br>

<br>

<br>
```pascal
type
  TMyApp = object(TApplication)
    zeitalt: Integer;
    constructor Init;
<br>
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
<br>
    procedure HandleEvent(var Event: TEvent); virtual;
<br>
    procedure NewWindows;
    procedure NewUhr;
<br>
    procedure Idle; Virtual;  // Das wichtigste.
  end;
```
<br>

<br>
```pascal
constructor TMyApp.Init;
begin
  inherited Init;   // Der Vorfahre aufrufen.
  NewWindows;       // Fenster erzeugen.
  NewUhr;           // Uhrendialog erzeugen.
end;
```
<br>

<br>
```pascal
procedure TMyApp.NewUhr;
begin
  Desktop^.Insert(ValidView(New(PUhrView, Init)));
end;
```
<br>

<br>

<br>

<br>

<br>

```pascal
procedure TMyApp.Idle;
var
  zeitNeu: Integer;
  s: ShortString;      // Speichert die aktuelle Zeit als String.
begin
  zeitNeu := round(time * 60 * 60 * 24);           // Sekunden berechnen.
  if zeitNeu <> zeitalt then begin                 // Nur aktualliesieren wen ein Sek. vorbei.
    zeitalt := zeitNeu;
    s:= TimeToStr(Now);                            // Aktuelle Zeit als String.
    Message(@Self, evBroadcast, cmUhrRefresh, @s); // Ruft eigener HandleEvent auf.
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
      cmNewUhr: begin
        NewUhr;        // Uhrendialog erzeugen.
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
---
<br>

<br>

<br>

```pascal
unit UhrDialog;
<br>
```
<br>

<br>

```pascal
const
  cmUhrRefresh = 1003;
<br>
type
  PUhrView = ^TUhrView;
  TUhrView = object(TDialog)
  private
    ZeitStr: ShortString;
  public
    constructor Init;
    procedure Draw; Virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
<br>
```
<br>

<br>
```pascal
constructor TUhrView.Init;
var
  R: TRect;
begin
  R.Assign(51, 1, 70, 8);
  inherited Init(R, 'Uhr');
<br>
  R.Assign(7, 4, 13, 6);
  Insert(new(PButton, Init(R, '~O~k', cmOK, bfDefault)));
end;
<br>
```
<br>

<br>
```pascal
procedure TUhrView.Draw;
var
  b: TDrawBuffer;
  c: Byte;
begin
  inherited Draw;
  c := GetColor(7);
  MoveChar(b, ' ', c, Size.X + 4);
  MoveStr(b, ZeitStr, c);
  WriteLine(5, 2, Size.X + 2, 1, b);
end;
<br>
```
<br>

<br>

<br>

```pascal
procedure TUhrView.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
<br>
  case Event.What of
    evBroadcast: begin
      case Event.Command of
        cmUhrRefresh: begin
          ZeitStr := PString(Event.InfoPtr)^;
          Draw;
        end;
      end;
    end;
    evCommand: begin
      case Event.Command of
        cmOK: begin
          Close;
        end;
      end;
    end;
  end;
end;
<br>
```
<br>

