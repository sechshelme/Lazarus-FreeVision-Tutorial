# 02 - Statuszeile und Menu
## 15 - Menu erweitert
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Hinzufügen mehrere Menüpunkte.<br>
Hier wird dies auch der Übersicht zu liebe gesplittet gemacht.<br>
<hr><br>
Für eigene Kommandos, muss man noch Kommdocode definieren.<br>
Es empfiehlt sich Werte &gt; 1000 zu verwenden, so das es keine Überschneidungen mit den Standard-Codes gibt.<br>
```pascal>const
  cmList = 1002;      // Datei Liste
  cmAbout = 1001;     // About anzeigen```
Für ein Menu muss man <b>InitMenuBar</b> vererben.<br>
```pascal>type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Statuszeile
    procedure InitMenuBar; virtual;      // Menü
  end;```
Mam kann die Menüeinträge auch gesplittet über Pointer machen.<br>
Ob man es verschachtelt oder splittet, ist Geschmacksache.<br>
Mit <b>NewLine</b> kann man eine Leerzeile einfügen.<br>
Es empfiehlt sich wen bei einem Menüpunkt ein Dialog aufgeht, Hinter der Bezeichnung <b>...</b> zu schreiben.<br>
```pascal>  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rechteck für die Menüzeilen-Position.
<br>
    M: PMenu;                          // Ganzes Menü
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M1_0: PMenuItem; // Einfache Menüpunkte
<br>
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;
<br>
    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~ilfe', hcNoContext, NewMenu(M1_0), nil);
<br>
    M0_2 := NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_1 := NewLine(M0_2);
    M0_0 := NewItem('~L~iste', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~D~atei', hcNoContext, NewMenu(M0_0), SM1);
<br>
    M := NewMenu(SM0);
<br>
    MenuBar := New(PMenuBar, Init(R, M));
  end;```
<br>
