# 03 - Dialoge
## 05 - Erster Dialog
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Abarbeiten der Events, der Statuszeile und des Menu.<br>
<hr><br>
Für Dialoge muss man noch die Unit <b>Dialogs</b> einfügen.<br>
<pre><code=pascal>uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Statuszeile
  Dialogs;  // Dialoge</code></pre>
Ein weiteres Kommando für den Aufruf des Dialoges.<br>
<pre><code=pascal>const
  cmAbout = 1001;     // About anzeigen</font>
  cmList = 1002;      // Datei Liste</font>
  cmPara = 1003;      // Parameter</font></code></pre>
Neue Funktionen kommen auch in die Klasse.<br>
Hier ein Dialog für Paramtereingabe.<br>
<pre><code=pascal>type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
<br>
    procedure MyParameter;                             // neue Funktion für einen Dialog.
  end;</code></pre>
Das Menü wird um Parameter und Schliessen erweitert.<br>
<pre><code=pascal>  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rechteck für die Menüzeilen-Position.
<br>
    M: PMenu;                          // Ganzes Menü
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M0_3, M0_4, M0_5,
    M1_0: PMenuItem;                   // Einfache Menüpunkte
<br>
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;</font>
<br>
    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);</font>
    SM1 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M1_0), nil);</font>
<br>
    M0_5 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);</font>
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem('S~c~hliessen', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_1 := NewItem('~P~arameter...', '', kbF2, cmPara, hcNoContext, M0_2);</font>
    M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1);</font>
    SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);</font>
<br>
    M := NewMenu(SM0);
<br>
    MenuBar := New(PMenuBar, Init(R, M));
  end;</code></pre>
Hier wird mit dem Kommando <b>cmPara</b> ein Dialog geöffnet.<br>
<pre><code=pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
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
  end;</code></pre>
Bauen eines leeren Dialoges.<br>
Auch da wird <b>TRect</b> gebraucht für die Grösse.<br>
Dies wird bei allen Komponenten gebraucht, egal ob Button, etc.<br>
<pre><code=pascal>  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    R.Move(23, 3);                             // Position des Dialogs.
    Dlg := New(PDialog, Init(R, 'Parameter')); // Dialog erzeugen.</font>
    Desktop^.Insert(Dlg);                      // Dialog der App zuweisen.
  end;</code></pre>
<br>
