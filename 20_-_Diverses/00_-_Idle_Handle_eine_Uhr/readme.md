# 20 - Diverses
## 00 - Idle Handle eine Uhr
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Hier wird gezeigt, wie man <b>Idle</b> verwenden kann.<br>
Diese Leerlaufzeit wird verwendet um eine Uhr in Dialogen zu aktualiesieren.<br>
Das Object mit dem UhrenDialog befindet sich in der Unit <b>UhrDialog</b>.<br>
<hr><br>
Neue Konstante für das Kommado neuer UhrenDialog.<br>
<br>
```pascal
const
  cmNewWin = 1001;
  cmNewUhr = 1002;
```
<br>
Hier befindet sich die wichtigste Methode <b>Idle</b>.<br>
Diese Methode wird aufgerufen, wen die CPU sonst nichts zu tun hat.<br>
Hier wird sie verwendet um die Uhr-Zeit in den Dialogen zu aktualiesieren.<br>
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
Am Anfang wird ein Fenster und ein Uhrendialog erzeugt.<br>
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
Neuer Uhrendialog in den Desktop einfügen.<br>
<br>
```pascal
procedure TMyApp.NewUhr;
begin
  Desktop^.Insert(ValidView(New(PUhrView, Init)));
end;
```
<br>
Der Leeerlaufprozess <b>Idle</b>.<br>
Mit <b>Message(...</b> werden allen Fenster und Dialgen das <b>cmUhrRefresh</b> Kommado übergeben.<br>
Auch wird dazu das Event <b>evBroadcast</b> verwendet, das es um eine Übertragung handelt.<br>
Reagieren tut nur der UhrenDialog auf dieses Kommando, weil es dort abgefangen wird.<br>
Beim Fenster läuft dieses einfach durch.<br>
Auch sieht man gut, das das Message nur aufgerufen wird, wen ein Sekunde verstrichen ist.<br>
Als letzter Parameter wird ein Pointer auf einen String übergeben, welcher dir aktuelle Zeit enthält.<br>
Würde man es bei jedem Idle machen, würde die Uhr nur flimmern.<br>
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
Dieses HandleEvent interessiert das Kommando <b>cmUhrRefresh</b> nicht.<br>
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
<hr><br>
<b>Unit mit dem Uhren-Dialog.</b><br>
<br><br>
Die Komponenten auf dem Dialog sind nichts besonderes, es hat nur ein OK-Button.<br>
Die Zeit wird direkt mit <b>WriteLine(...</b> reingeschrieben.<br>
Aus diesem Grund wurde die Methode <b>Draw</b> ergänzt.<br>
<br>
```pascal
unit UhrDialog;
<br>
```
<br>
Die Deklaration des Dialoges.<br>
Hier wird in <b>ZeitStr</b> die Zeit gespeichert, so das sie mit <b>Draw</b> ausgegeben werden kann.<br>
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
Im Dioalog wird nur ein OK-Button erzeugt.<br>
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
In <b>Draw</b> sieht man gut, das die Zeit direkt in den Dialog geschrieben wird.<br>
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
Das <b>HandleEvent</b> ist schon interessanter, dort wird das Event <b>evBroadcast</b> und<br>
das Kommando <b>cmUhrRefresh</b> abgefangen, welches im Hauptprogramm mit Message übergeben wurde.<br>
Aus <b>Event.InfoPtr</b> wird noch der String übernommen welcher die Zeit enthält.<br>
Das Kommando <b>cmOk</b> ist nicht besonderes, es schliesst nur den Dialog.<br>
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

