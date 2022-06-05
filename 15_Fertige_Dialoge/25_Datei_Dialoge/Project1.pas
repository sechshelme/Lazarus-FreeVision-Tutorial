//image image.png
(*
Ein Dialog zum öffnen und speichern von Dateien.
Der <b>PFileDialog</b>.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  MsgBox,   // MessageBox
  Menus,    // Statuszeile
  StdDlg;   // Standard-Dialoge

const
  cmFileOpen = 1001;
  cmFileSave = 1002;
  cmFileHelp = 1003;
  cmAbout = 1010;

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;     // Rechteck für die Statuszeilen Position.

  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));

  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;     // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~O~effnen...', 'F3', kbF3, cmFileOpen, hcNoContext,
        NewItem('Speichern ~u~nter...', '', kbNoKey,cmFileSave, hcNoContext,
        NewItem('Mit zusatz ~B~uttons...', '', kbNoKey,cmFileHelp, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))),
      NewSubMenu('~H~ilfe', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));

  end;

(*
Verschiedene Datei-Dialoge
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    FileDialog: PFileDialog;
    FileName: shortstring;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmFileOpen: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOpenButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        cmFileSave: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOkButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        cmFileHelp: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOkButton + fdOpenButton + fdReplaceButton + fdClearButton + fdHelpButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        else begin
          Exit;
        end;
          //code-
      end;
    end;
    ClearEvent(Event);
  end;


var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
