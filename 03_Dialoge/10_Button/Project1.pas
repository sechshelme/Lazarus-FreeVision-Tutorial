//image image.png
(*
Dialog um Buttons ergänzen.
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
  cmAbout = 1001;     // About anzeigen
  cmList = 1002;      // Datei Liste
  cmPara = 1003;      // Parameter

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyParameter;                             // neue Funktion für einen Dialog.
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;                 // Rechteck für die Statuszeilen Position.

    P0: PStatusDef;           // Pointer ganzer Eintrag.
    P1, P2, P3: PStatusItem;  // Poniter auf die einzelnen Hot-Key.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    P3 := NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil);
    P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3);
    P1 := NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit, P2);
    P0 := NewStatusDef(0, $FFFF, P1, nil);

    StatusLine := New(PStatusLine, Init(R, P0));
  end;

    procedure TMyApp.InitMenuBar;
    var
      R: TRect;                          // Rechteck für die Menüzeilen-Position.

      M: PMenu;                          // Ganzes Menü
      SM0, SM1,                          // Submenu
      M0_0, M0_1, M0_2, M0_3,M0_4, M0_5,
      M1_0: PMenuItem;                   // Einfache Menüpunkte

    begin
      GetExtent(R);
      R.B.Y := R.A.Y + 1;

      M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
      SM1 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M1_0), nil);

      M0_5 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
      M0_4 := NewLine(M0_5);
      M0_3 := NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4);
      M0_2 := NewLine(M0_3);
      M0_1:=NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext, M0_2);
      M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1);
      SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);

      M := NewMenu(SM0);

      MenuBar := New(PMenuBar, Init(R, M));
    end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
        end;
        cmList: begin
        end;
        cmPara: begin
          MyParameter;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

(*
Den Dialog mit Buttons ergänzen.
Mit <b>Insert</b> fügt man die Komponenten hinzug, in diesem Fall sind es die Buttons.
Mit bfDefault legt man den Default-Button fest, dieser wird mit <b>[Enter]</b> aktiviert.
bfNormal ist ein gewöhnlicher Button.
Der Dialog wird nun Modal geöffnet, somit können <b>keine</b> weiteren Dialoge geöffnet werden.
dummy hat den Wert, des Button der gedrückt wurde, dies entspricht dem <b>cmxxx</b> Wert.
Die Höhe der Buttons muss immer <b>2</b> sein, ansonsten gibt es eine fehlerhafte Darstellung.
*)
  //code+
  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    R: TRect;
    dummy: word;
  begin
    R.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    R.Move(23, 3);                             // Position des Dialogs.
    Dia := New(PDialog, Init(R, 'Parameter')); // Dialog erzeugen.
    with Dia^ do begin

      // Ok-Button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Schliessen-Button
      R.Move(12, 0);
      Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));
    end;
    dummy := Desktop^.ExecView(Dia);   // Dialog Modal öffnen.
    Dispose(Dia, Done);                // Dialog und Speicher frei geben.
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
