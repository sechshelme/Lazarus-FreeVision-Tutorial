//image image.png
(*
Bis jetzt gingen die Werte im Dialog immer wieder verloren, wen man diesen schliesste und wieder öffnete.
Aus diesem Grund werden jetzt die Werte in einen Record gespeichert.
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

  (*
  In diesem Record werden die Werte des Dialoges gespeichert.
  Die Reihenfolge der Daten im Record <b>muss</b> genau gleich sein, wie bei der Erstellung der Komponenten, ansonten gibt es einen Kräsch.
  Bei Turbo-Pascal musste ein <b>Word</b> anstelle von <b>LongWord</b> genommen werden, dies ist wichtig beim Portieren alter Anwendungen.
  *)
  //code+
type
  TParameterData = record
    Druck,
    Schrift: longword;
    Hinweis: string[50];
  end;
  //code-

(*
Hier wird noch der Constructor vererbt, diesen Nachkomme wird gebraucht um die Dialogdaten mit Standard Werte zu laden.
*)
  //code+
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Daten für Parameter-Dialog
    constructor Init;                                  // Neuer Constructor

    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyParameter;                             // neue Funktion für einen Dialog.
  end;
  //code-

(*
Der Constructoer welcher die Werte für den Dialog ladet.
Die Datenstruktur für die RadioButtons ist einfach. 0 ist der erste Button, 1 der Zweite, 2 der Dritte, usw.
Bei den Checkboxen macht man es am besten Binär. Im Beispiel werden der erste und dritte CheckBox gesetzt.
*)
  //code+
  constructor TMyApp.Init;
  begin
    inherited Init;     // Vorfahre aufrufen
    with ParameterData do begin
      Druck := %0101;
      Schrift := 2;
      Hinweis := 'Hello world';
    end;
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
    SM0, SM1, SM2,                     // Submenu
    M0_0, M0_2, M0_3, M0_4, M0_5,
    M1_0, M2_0: PMenuItem;             // Einfache Menüpunkte

  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    M2_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM2 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M2_0), nil);

    M1_0 := NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext, nil);
    SM1 := NewSubMenu('~O~ption', hcNoContext, NewMenu(M1_0), SM2);

    M0_5 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_2);
    SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(Rect, M));
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
Der Dialog wird jetzt mit Werten geladen.
Dies macht man, sobald man fertig ist mit Komponenten ertstellen.
*)
  //code+
  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    Rect: TRect;
    dummy: word;
    Ptr: PView;
  begin
    Rect.Assign(0, 0, 35, 15);
    Rect.Move(23, 3);
    Dia := New(PDialog, Init(Rect, 'Parameter'));
    with Dia^ do begin

      // CheckBoxen
      Rect.Assign(2, 3, 18, 7);
      Ptr := New(PCheckBoxes, Init(Rect,
        NewSItem('~D~atei',
        NewSItem('~Z~eile',
        NewSItem('D~a~tum',
        NewSItem('~Z~eit',
        nil))))));
      Insert(Ptr);
      // Label für CheckGroup.
      Rect.Assign(2, 2, 10, 3);
      Insert(New(PLabel, Init(Rect, 'Dr~u~cken', Ptr)));

      // RadioButton
      Rect.Assign(21, 3, 33, 6);
      Ptr := New(PRadioButtons, Init(Rect,
        NewSItem('~G~ross',
        NewSItem('~M~ittel',
        NewSItem('~K~lein',
        nil)))));
      Insert(Ptr);
      // Label für RadioGroup.
      Rect.Assign(20, 2, 31, 3);
      Insert(New(PLabel, Init(Rect, '~S~chrift', Ptr)));

      // Edit Zeile
      Rect.Assign(3, 10, 32, 11);
      Ptr := New(PInputLine, Init(Rect, 50));
      Insert(Ptr);
      // Label für Edit Zeile
      Rect.Assign(2, 9, 10, 10);
      Insert(New(PLabel, Init(Rect, '~H~inweis', Ptr)));

      // Ok-Button
      Rect.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));

      // Schliessen-Button
      Rect.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(Rect, '~A~bbruch', cmCancel, bfNormal)));
    end;
    Dia^.SetData(ParameterData);      // Dialog mit den Werten laden.
    dummy := Desktop^.ExecView(Dia);  // Dialog ausführen.
    if dummy = cmOK then begin        // Wen Dialog mit Ok beenden, dann Daten vom Dialog in Record laden.
      Dia^.GetData(ParameterData);
    end;

    Dispose(Dia, Done);               // Dialog und Speicher frei geben.
  end;
  //code-
var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
