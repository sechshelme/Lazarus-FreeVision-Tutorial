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
  cmPara = 1003;      // Parameter
  cmMenuEnlish = 1005;
  cmMenuGerman = 1006;

type

  { TMyApp }

  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyParameter;
    // neue Funktion für einen Dialog.
  private
    menuGer, menuEng: PMenu;
  end;

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

  begin

    menuGer := NewMenu(NewSubMenu('~D~atei', hcNoContext,
      NewMenu(NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext,
      NewLine(NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose,
      hcNoContext, NewLine(NewItem('~B~eenden', 'Alt-X', kbAltX,
      cmQuit, hcNoContext, nil)))))), NewSubMenu('~O~ptionen', hcNoContext,
      NewMenu(NewItem('Deutsch', 'Alt-D', kbAltD, cmMenuGerman,
      hcNoContext, NewItem('Englisch', 'Alt-E', kbAltE, cmMenuEnlish,
      hcNoContext, nil))), NewSubMenu('~H~ilfe', hcNoContext,
      NewMenu(NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))));


    menuEng := NewMenu(NewSubMenu('~F~ile', hcNoContext,
      NewMenu(NewItem('~P~arameters...', '', kbF2, cmPara, hcNoContext,
      NewLine(NewItem('~C~lose', 'Alt-F3', kbAltF3, cmClose,
      hcNoContext, NewLine(NewItem('E~x~it', 'Alt-X', kbAltX,
      cmQuit, hcNoContext, nil)))))), NewSubMenu('~O~ptions', hcNoContext,
      NewMenu(NewItem('German', 'Alt-D', kbAltD, cmMenuGerman, hcNoContext,
      NewItem('English', 'Alt-E', kbAltE, cmMenuEnlish, hcNoContext, nil))),
      NewSubMenu('~H~elp', hcNoContext,
      NewMenu(NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))));

    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;
    MenuBar := New(PMenuBar, Init(Rect, menuGer));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
        end;
        cmMenuEnlish: begin
          MenuBar^.Menu := menuEng;
          ReDraw;
        end;
        cmMenuGerman: begin
          MenuBar^.Menu := menuGer;
          ReDraw;
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
    Rect: TRect;
    dummy: word;
  begin
    Rect.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    Rect.Move(23, 3);                             // Position des Dialogs.
    Dia := New(PDialog, Init(Rect, 'Parameter')); // Dialog erzeugen.
    with Dia^ do begin

      // Ok-Button
      Rect.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));

      // Schliessen-Button
      Rect.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(Rect, '~A~bbruch', cmCancel, bfNormal)));
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
