//image image.png
(*
Man kann zur Laufzeit das komplette Menü und Statuszeile austauschen.
ZB. um die Anwendung mehrsprachig zu machen.
Dazu wird die aktuelle Komponente entfernt und die neue eingefügt.
In dem Beispiel gibt es je eine deutsche und englische Komponente.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Statuszeile
  Dialogs;  // Dialoge

const
  cmAbout = 1001;        // About anzeigen
  cmPara = 1003;         // Parameter
  cmMenuEnlish = 1005;   // Englisch
  cmMenuGerman = 1006;   // Deutsch

type
(*
Deklaration der Komponenten
*)
  //code+
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  private
    menuGer, menuEng: PMenuView;          // Die beiden Menüs
    StatusGer, StatusEng: PStatusLine;    // Die beiden Stauszeilen
  end;
  //code-

(*
Inizialisieren der beiden Statuszeilen.
*)
  //code+
  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    // Statuszeile deutsch
    StatusGer := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menue', kbF10, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));

    // Statuszeile englisch
    StatusEng := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));

    StatusLine := StatusGer; // Deutsch per Default
  end;
  //code-

(*
Inizialisieren der beiden Menüs.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    // Menü deutsch
    menuGer := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
      NewSubMenu('~O~ptionen', hcNoContext, NewMenu(
        NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext,
        NewLine(
        NewItem('~D~eutsch', 'Alt-D', kbAltD, cmMenuGerman, hcNoContext,
        NewItem('~E~nglisch', 'Alt-E', kbAltE, cmMenuEnlish, hcNoContext, nil))))),
      NewSubMenu('~H~ilfe', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));

    // Menü englisch
    menuEng := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~C~lose', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
      NewSubMenu('~O~ptions', hcNoContext, NewMenu(
        NewItem('~P~arameters...', '', kbF2, cmPara, hcNoContext,
        NewLine(
        NewItem('German', 'Alt-D', kbAltD, cmMenuGerman, hcNoContext,
        NewItem('English', 'Alt-E', kbAltE, cmMenuEnlish, hcNoContext, nil))))),
      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));

    MenuBar := menuGer; // Deutsch per Default
  end;
//code-

(*
Austauschen der Komponenten
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.

  begin
    GetExtent(Rect);

    Rect.A.Y := Rect.B.Y - 1;
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          // Ein About Dialog
        end;

        // Menü auf englisch
        cmMenuEnlish: begin

          // Menü tauschen
          Delete(MenuBar);          // Altes Menü entfernen
          MenuBar := menuEng;       // Neues Menü zuordnen
          Insert(MenuBar);          // Neues Menü einfügen

          // Statuszeile tauschen
          Delete(StatusLine);       // Alte Statuszeile entfernen
          StatusLine := StatusEng;  // Neue Statuszeile zuordnen
          Insert(StatusLine);       // Neue Statuszeile einfügen
        end;

        // Menü auf deutsch
        cmMenuGerman: begin
          Delete(MenuBar);
          MenuBar := menuGer;
          Insert(MenuBar);

          Delete(StatusLine);
          StatusLine := StatusGer;
          Insert(StatusLine);
        end;
        cmPara: begin
          // Ein Parameter Dialog
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
