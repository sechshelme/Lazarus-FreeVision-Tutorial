//image image.png
(*
Über das Menü Fenster erzeigen und schliessen.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit), Window
  MsgBox,
  Editors,  // Messageboxen
  Menus;    // Statuszeile

(*
Neue Konstanten für Kommados.
Auch ist der HandleEvent dazugekommen.
*)
//code+
const
  cmNewWin = 1001;
type
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual; // Abarbeitung Kommandos
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.

    procedure NewWindows;
  end;
  //code-
  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewWindows;       // Fenster erzeugen.
  end;

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

(*
Das Menü wurde um <b>Neu</b> und <b>Schliessen</b> ergänzt.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
      NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
      NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
      NewLine(
      NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil))))), nil))));
  end;
  //code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

(*
Beim Fenster erzeugen, ist noch ein Counter hinzugekommen.
Dieser wird benutzt um die Fenster zu nummerieren.
*)
  //code+
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    Rect: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster
  begin
    Rect.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PWindow, Init(Rect, 'Fenster', WinCounter));
    // Wen zu wenig Speicher für Fenster, dann Counter wieder -1.
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;
  //code-

(*
<b>cmNewWin</b> muss man selbst abarbeiten. <b>cmClose</b> für das Schliessen des Fenster läuft es im Hintergrund automatisch.
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
end.
