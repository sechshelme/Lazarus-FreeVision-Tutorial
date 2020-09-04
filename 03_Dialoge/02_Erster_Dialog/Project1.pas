//image image.png
(*
Abarbeiten der Events, der Statuszeile und des Menu.
*)
//lineal
program Project1;

(*
Für Dialoge muss man noch die Unit <b>Dialogs</b> einfügen.
*)
//code+
uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Statuszeile
  Dialogs;  // Dialoge
//code-

(*
Ein weiteres Kommando für den Aufruf des Dialoges.
*)
//code+
const
  cmAbout = 1001;     // About anzeigen
  cmList = 1002;      // Datei Liste
  cmPara = 1003;      // Parameter
  //code-

(*
Neue Funktionen kommen auch in die Klasse.
Hier ein Dialog für Paramtereingabe.
*)
  //code+
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyParameter;                             // neue Funktion für einen Dialog.
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

(*
Das Menü wird um Parameter und Schliessen erweitert.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;                       // Rechteck für die Menüzeilen-Position.

    M: PMenu;                          // Ganzes Menü
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M0_3, M0_4, M0_5,
    M1_0: PMenuItem;                   // Einfache Menüpunkte

  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M1_0), nil);

    M0_5 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_1 := NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext, M0_2);
    M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(Rect, M));
  end;
  //code-

(*
Hier wird mit dem Kommando <b>cmPara</b> ein Dialog geöffnet.
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
        end;
        cmList: begin
        end;
        cmPara: begin     // Parameter Dialog öffnen.
          MyParameter;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
  //code-

(*
Bauen eines leeren Dialoges.
Auch da wird <b>TRect</b> gebraucht für die Grösse.
Dies wird bei allen Komponenten gebraucht, egal ob Button, etc.
*)
  //code+
  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    Rect: TRect;
  begin
    Rect.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    Rect.Move(23, 3);                             // Position des Dialogs.
    Dia := New(PDialog, Init(Rect, 'Parameter')); // Dialog erzeugen.
    Desktop^.Insert(Dia);                         // Dialog der App zuweisen.
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
