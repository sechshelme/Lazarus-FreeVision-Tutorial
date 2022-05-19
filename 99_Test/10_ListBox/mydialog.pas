//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs,
  SysUtils; // Für IntToStr und StrToInt.

//type+
type
  PMyDialog = ^TMyDialog;

  TMyDialog = object(TDialog)
  const
    cmCounter = 1003;       // Wird lokal für den Zähler-Butoon gebraucht.
  var
    CounterButton: PButton; // Button mit Zähler.

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyDialog.Init;
var
  Rect: TRect;
  ScrollBar: PScrollBar;
  ListBox: PListBox;
  pc: PCollection;
  ps: PString;
  StringCollection: PStringCollection;

begin
  Rect.Assign(0, 0, 42, 21);
  Rect.Move(23, 3);
  inherited Init(Rect, 'ListBox Demo');

  // ListBox
  Rect.Assign(5, 5, 7, 15);
  ScrollBar := new(PScrollBar, Init(Rect));

  StringCollection := new(PStringCollection, Init(0, 1));
  StringCollection^.Insert(NewStr('Montag'));
  StringCollection^.Insert(NewStr('Dienstag'));
  StringCollection^.Insert(NewStr('Mittwoch'));
  StringCollection^.Insert(NewStr('Donnerstag'));
  StringCollection^.Insert(NewStr('Freitag'));
  StringCollection^.Insert(NewStr('Samstag'));
  StringCollection^.Insert(NewStr('Sonntag'));



  //pc := new(PCollection, Init(4, 4));
  //pc^.Insert(NewStr('abc'));
  //pc^.Insert(NewStr('abc'));
  //pc^.Insert(NewStr('abc'));
  //pc^.Insert(NewStr('abc'));
  //
  Rect.Assign(5, 2, 31, 15);
  ListBox := new(PListBox, Init(Rect, 1, ScrollBar));
  ListBox^.NewList(StringCollection);
  //  ps:=new(PString);
  //  ps^:='abcd';

  //  ListBox^.Insert(ps);
  //  ListBox^.Insert(ps);
  //  ps := newstr('dsfdsfdsf');
  //  ListBox^.List^.Insert(ps);
  //ListBox^.Insert(pc);
  //ListBox^.Insert(PString, Init('hallo'));
  //ListBox^.Insert(PString, Init('hallo'));

  Insert(ListBox);

  // Button, bei den der Titel geändert wird.
  Rect.Assign(19, 18, 32, 20);
  CounterButton := new(PButton, Init(Rect, '    ', cmCounter, bfNormal));
  CounterButton^.Title^ := '1';

  Insert(CounterButton);

  // Ok-Button
  Rect.Assign(7, 18, 17, 20);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  Counter: integer;
begin
  inherited HandleEvent(Event);

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmCounter: begin
          Counter := StrToInt(CounterButton^.Title^); // Titel des Button auslesen.
          Inc(Counter);                               // Counter erhöhen.
          if Counter > 9999 then begin                // Auf Überlauf prüfen, weil nur 4 Zeichen zur Verfügung.
            Counter := 9999;
          end;
          CounterButton^.Title^ := IntToStr(Counter); // Neuer Titel an Button übergeben.

          CounterButton^.Draw;                        // Button neu zeichnen.
          ClearEvent(Event);                          // Event beenden.
        end;
      end;
    end;
  end;

end;
//handleevent-

end.
