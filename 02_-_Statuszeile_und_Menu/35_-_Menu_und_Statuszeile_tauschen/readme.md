# 02 - Statuszeile und Menu
## 35 - Menu und Statuszeile tauschen
<img src="image.png" alt="Selfhtml"><br><br>
Man kann zur Laufzeit das komplette Menü und Statuszeile austauschen.<br>
ZB. um die Anwendung mehrsprachig zu machen.<br>
Dazu wird die aktuelle Komponente entfernt und die neue eingefügt.<br>
In dem Beispiel gibt es je eine deutsche und englische Komponente.<br>
---
Deklaration der Komponenten<br>
```pascal>  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  private
    menuGer, menuEng: PMenuView;          // Die beiden Menüs
    StatusGer, StatusEng: PStatusLine;    // Die beiden Stauszeilen
  end;```
Inizialisieren der beiden Statuszeilen.<br>
```pascal>  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;</font>
<br>
    // Statuszeile deutsch
    StatusGer := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,</font>
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menue', kbF10, cmMenu,</font>
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));</font>
<br>
    // Statuszeile englisch
    StatusEng := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,</font>
      NewStatusKey('~Alt+X~ Exit', kbAltX, cmQuit,</font>
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,</font>
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));</font>
<br>
    StatusLine := StatusGer; // Deutsch per Default
  end;```
Inizialisieren der beiden Menüs.<br>
```pascal>  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;</font>
<br>
    // Menü deutsch
    menuGer := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(</font>
        NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),</font>
      NewSubMenu('~O~ptionen', hcNoContext, NewMenu(</font>
        NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext,</font>
        NewLine(
        NewItem('~D~eutsch', 'Alt-D', kbAltD, cmMenuGerman, hcNoContext,</font>
        NewItem('~E~nglisch', 'Alt-E', kbAltE, cmMenuEnlish, hcNoContext, nil))))),</font>
      NewSubMenu('~H~ilfe', hcNoContext, NewMenu(</font>
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));</font>
<br>
    // Menü englisch
    menuEng := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(</font>
        NewItem('~C~lose', 'Alt-F3', kbAltF3, cmClose, hcNoContext,</font>
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),</font>
      NewSubMenu('~O~ptions', hcNoContext, NewMenu(</font>
        NewItem('~P~arameters...', '', kbF2, cmPara, hcNoContext,</font>
        NewLine(
        NewItem('German', 'Alt-D', kbAltD, cmMenuGerman, hcNoContext,</font>
        NewItem('English', 'Alt-E', kbAltE, cmMenuEnlish, hcNoContext, nil))))),</font>
      NewSubMenu('~H~elp', hcNoContext, NewMenu(</font>
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));</font>
<br>
    MenuBar := menuGer; // Deutsch per Default
  end;```
Austauschen der Komponenten<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.
<br>
  begin
    GetExtent(Rect);
<br>
    Rect.A.Y := Rect.B.Y - 1;</font>
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          // Ein About Dialog
        end;
<br>
        // Menü auf englisch
        cmMenuEnlish: begin
<br>
          // Menü tauschen
          Delete(MenuBar);          // Altes Menü entfernen
          MenuBar := menuEng;       // Neues Menü zuordnen
          Insert(MenuBar);          // Neues Menü einfügen
<br>
          // Statuszeile tauschen
          Delete(StatusLine);       // Alte Statuszeile entfernen
          StatusLine := StatusEng;  // Neue Statuszeile zuordnen
          Insert(StatusLine);       // Neue Statuszeile einfügen
        end;
<br>
        // Menü auf deutsch
        cmMenuGerman: begin
          Delete(MenuBar);
          MenuBar := menuGer;
          Insert(MenuBar);
<br>
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
  end;```
<br>
