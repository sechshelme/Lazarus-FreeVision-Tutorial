# 90 - Experimente
## 05 - Menu graue Eintraege
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Menupunkt kann man auch ineinander verschachteln.<br>
<hr><br>
Bei der Statuszeile habe ich die Einträge verschachtelt, somit braucht man keine Zeiger.<br>
Ich finde dies auch übersichtlicher, als ein Variablen-Urwald.<br>
<pre><code=pascal>  procedure TMyApp.InitStatusLine;
  var
    R: TRect;              // Rechteck für die Statuszeilen Position.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;</font>
<br>
    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,</font>
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,</font>
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));</font>
  end;</code></pre>
Folgendes Beispiel demonstriert ein verschachteltes Menü.<br>
Die Erzeugung ist auch verschachtelt.<br>
<pre><code>Datei
  Beenden
Demo
  Einfach 1
  Verschachtelt
    Menu 0
    Menu 1
    Menu 2
  Einfach 2
Hilfe
  About</code></pre>
<pre><code=pascal>  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;</font>
<br>
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(</font>
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),</font>
<br>
      NewSubMenu('Dem~o~', hcNoContext, NewMenu(</font>
        NewItem('Einfach ~1~', '', kbNoKey, cmAbout, hcNoContext,</font>
        NewSubMenu('~V~erschachtelt', hcNoContext, NewMenu(</font>
          NewItem('Menu ~0~', '', kbNoKey, cmAbout, hcNoContext,</font>
          NewItem('Menu ~1~', '', kbNoKey, cmAbout, hcNoContext,</font>
          NewItem('Menu ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),</font>
        NewItem('Einfach ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),</font>
<br>
      NewSubMenu('~H~ilfe', hcNoContext, NewMenu(</font>
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));</font>
<br>
    MenuBar^.Menu^.Items^.Next^.SubMenu^.Items^.Next^.Disabled:=True;
  end;</code></pre>
<br>
