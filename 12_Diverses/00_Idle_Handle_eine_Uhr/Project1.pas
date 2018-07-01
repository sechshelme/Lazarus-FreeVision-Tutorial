//image image.png
(*
Hier wird gezeigt, wie man <b>Idle</b> verwenden kann.
Diese Leerlaufzeit wird verwendet um eine Uhr in Dialogen zu aktualiesieren.
Das Object mit dem UhrenDialog befindet sich in der Unit <b>UhrDialog</b>.
*)
//lineal
program Project1;

uses
  sysutils,
  App,
  Objects,
  Drivers,
  Views,
  MsgBox,
  Dialogs,
  Menus,
  UhrDialog;

(*
Neue Konstante für das Kommado neuer UhrenDialog.
*)
//code+
const
  cmNewWin = 1001;
  cmNewUhr = 1002;
//code-

(*
Hier befindet sich die wichtigste Methode <b>Idle</b>.
Diese Methode wird aufgerufen, wen die CPU sonst nichts zu tun hat.
Hier wird sie verwendet um die Uhr-Zeit in den Dialogen zu aktualiesieren.
*)
//code+
type
  TMyApp = object(TApplication)
    zeitalt: Integer;
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual;

    procedure NewWindows;
    procedure NewUhr;

    procedure Idle; Virtual;  // Das wichtigste.
  end;
//code-

(*
Am Anfang wird ein Fenster und ein Uhrendialog erzeugt.
*)
//code+
constructor TMyApp.Init;
begin
  inherited Init;   // Der Vorfahre aufrufen.
  NewWindows;       // Fenster erzeugen.
  NewUhr;           // Uhrendialog erzeugen.
end;
//code-

procedure TMyApp.InitStatusLine;
var
  Rect: TRect;
begin
  GetExtent(Rect);
  Rect.A.Y := Rect.B.Y - 1;

  StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
    NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
    NewStatusKey('~F10~ Menu', kbF10, cmMenu,
    NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));
end;

procedure TMyApp.InitMenuBar;
var
  Rect: TRect;
begin
  GetExtent(Rect);
  Rect.B.Y := Rect.A.Y + 1;

  MenuBar := New(PMenuBar, Init(Rect, NewMenu(NewSubMenu('~D~atei', hcNoContext, NewMenu(
    NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
    NewItem('Neu ~U~hr', 'F5', kbF5, cmNewUhr, hcNoContext,
    NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
    NewLine(
    NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))), nil))));
  end;

procedure TMyApp.NewWindows;
var
  Win: PWindow;
  Rect: TRect;
const
  WinCounter: integer = 0;      // Zählt Fenster
begin
  Rect.Assign(0, 0, 40, 10);
  Inc(WinCounter);
  Win := New(PWindow, Init(Rect, 'Fenster', WinCounter));
  if ValidView(Win) <> nil then begin
    Desktop^.Insert(Win);
  end else begin
    Dec(WinCounter);
  end;
end;

(*
Neuer Uhrendialog in den Desktop einfügen.
*)
//code+
procedure TMyApp.NewUhr;
begin
  Desktop^.Insert(ValidView(New(PUhrView, Init)));
end;
//code-

(*
Der Leeerlaufprozess <b>Idle</b>.
Mit <b>Message(...</b> werden allen Fenster und Dialgen das <b>cmUhrRefresh</b> Kommado übergeben.
Auch wird dazu das Event <b>evBroadcast</b> verwendet, das es um eine Übertragung handelt.
Reagieren tut nur der UhrenDialog auf dieses Kommando, weil es dort abgefangen wird.
Beim Fenster läuft dieses einfach durch.
Auch sieht man gut, das das Message nur aufgerufen wird, wen ein Sekunde verstrichen ist.
Als letzter Parameter wird ein Pointer auf einen String übergeben, welcher dir aktuelle Zeit enthält.
Würde man es bei jedem Idle machen, würde die Uhr nur flimmern.
*)
//code+
procedure TMyApp.Idle;
var
  zeitNeu: Integer;
  s: String;        // Speichert die aktuelle Zeit als String.
begin
  zeitNeu := round(time * 60 * 60 * 24);                   // Sekunden berechnen.
  if zeitNeu <> zeitalt then begin                         // Nur aktualliesieren wen ein Sek. vorbei.
    zeitalt := zeitNeu;
    s:= TimeToStr(Now);                                    // Aktuelle Zeit als String.
    Message(@Self, evBroadcast, cmUhrRefresh, Pointer(s)); // Ruft eigener HandleEvent auf.
  end;
end;
//code-


(*
Dieses HandleEvent interessiert das Kommando <b>cmUhrRefresh</b> nicht.
*)
  //code+
procedure TMyApp.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);

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
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben

//lineal
(*
<b>Unit mit dem Uhren-Dialog.</b>
<br>
Die Komponenten auf dem Dialog sind nichts besonderes, es hat nur ein OK-Button.
Die Zeit wird direkt mit <b>WriteLine(...</b> reingeschrieben.
Aus diesem Grund wurde die Methode <b>Draw</b> ergänzt.
*)
//includepascal uhrdialog.pas head

(*
Die Deklaration des Dialoges.
Hier wird in <b>ZeitStr</b> die Zeit gespeichert, so das sie mit <b>Draw</b> ausgegeben werden kann.
*)
//includepascal uhrdialog.pas type

(*
Im Dioalog wird nur ein OK-Button erzeugt.
*)
//includepascal uhrdialog.pas init

(*
In <b>Draw</b> sieht man gut, das die Zeit direkt in den Dialog geschrieben wird.
*)
//includepascal uhrdialog.pas draw

(*
Das <b>HandleEvent</b> ist schon interessanter, dort wird das Event <b>evBroadcast</b> und
das Kommando <b>cmUhrRefresh</b> abgefangen, welches im Hauptprogramm mit Message übergeben wurde.
Aus <b>Event.InfoPtr</b> wird noch der String übernommen welcher die Zeit enthält.
Das Kommando <b>cmOk</b> ist nicht besonderes, es schliesst nur den Dialog.
*)
//includepascal uhrdialog.pas handleevent

end.
