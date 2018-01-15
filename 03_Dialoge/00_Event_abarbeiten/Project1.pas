//image image.png
(*
Abarbeiten der Events, der Statuszeile und des Menu.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus;    // Statuszeile

(*
Kommmandos die abgearbeitet werden.
*)
//code+
const
  cmAbout = 1001;     // About anzeigen
  cmList = 1002;      // Datei Liste
  //code-

(*
Der EventHandler ist auch ein Nachkommen.
*)
  //code+
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  end;
  //code-

  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.

    P0: PStatusDef;           // Pointer ganzer Eintrag.
    P1, P2, P3: PStatusItem;  // Poniter auf die einzelnen Hot-Key.
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    P3 := NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil);
    P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3);
    P1 := NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit, P2);
    P0 := NewStatusDef(0, $FFFF, P1, nil);

    StatusLine := New(PStatusLine, Init(Rect, P0));
  end;

  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;                       // Rechteck für die Menüzeilen-Position.

    M: PMenu;                          // Ganzes Menü
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M1_0: PMenuItem; // Einfache Menüpunkte

  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M1_0), nil);

    M0_2 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_1 := NewLine(M0_2);
    M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(Rect, M));
  end;

(*
Abarbeiten der eigenen cmxxx Kommandos.
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

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
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
