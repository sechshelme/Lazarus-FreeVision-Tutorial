//image image.png
(*
Erstes Memo-Fenster.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit), Window
  Menus;    // Statuszeile

(*
Der Constructor wird vererbt, so das von Anfang an ein neues Fenster erstellt wird.
*)
//code+
type
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure NewWindows;
  end;
  //code-
  //code+
  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewWindows;       // Fenster erzeugen.
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

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
      NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)), nil))));
  end;

(*
Neues Fenster erzeugen. Fenster werden in der Regel nicht modal geöffnet, da man meistens mehrere davon öffnen will.
*)
  //code+
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    Rect: TRect;
  begin
    Rect.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(Rect, 'Fenster', wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
