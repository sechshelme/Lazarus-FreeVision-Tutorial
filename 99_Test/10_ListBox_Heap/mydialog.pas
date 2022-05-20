//head+
unit MyDialog;
//head-

interface

{$H-}



uses
  App, Objects, Drivers, Views, Dialogs, MsgBox, StdDlg,
  SysUtils; // Für IntToStr und StrToInt.

//type+
type
  PMyDialog = ^TMyDialog;

  TMyDialog = object(TDialog)
  const
    cmTag = 1000;
  var
    ListBox: PListBox;

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
  StringCollection: PCollection;
  I: Sw_Integer;

begin
  Rect.Assign(10, 5, 67, 17);
  inherited Init(Rect, 'ListBox Demo');

  if Title <> nil then begin
    Dispose(Title);
  end;
  Title := NewStr('dfsfdsa');

  // ListBox
  Rect.Assign(31, 2, 32, 7);
  ScrollBar := new(PScrollBar, Init(Rect));
  Insert(ScrollBar);

  //  StringCollection := new(PCollection, Init(2, 1));
  StringCollection := new(PCollection, Init(4, 1));
  StringCollection^.Insert(NewStr('Montag'));
  StringCollection^.Insert(NewStr('Dienstag'));
  StringCollection^.Insert(NewStr('Mittwoch'));
  StringCollection^.Insert(NewStr('Donnerstag'));
  StringCollection^.Insert(NewStr('Freitag'));
  StringCollection^.Insert(NewStr('Samstag'));
  StringCollection^.Insert(NewStr('Sonntag'));

  Rect.Assign(5, 2, 31, 7);
  ListBox := new(PListBox, Init(Rect, 1, ScrollBar));
  ListBox^.NewList(StringCollection);

  Insert(ListBox);

  //  ListBox^.FreeAll;

  //if (ListBox^.List <> nil) then begin
  //  for I := ListBox^.List^.Count - 1 downto 0 do begin
  //    MessageBox(i.ToString, nil, mfOKButton);
  //    MessageBox(Pstring(ListBox^.List^.At(I))^, nil, mfOKButton);
  ////    ListBox^.List^.FreeItem(ListBox^.List^.At(I));
  //  end;
  //  ListBox^.List^.Count := 0;                                        { Clear item count }
  //
  //
  //
  //  MessageBox('Wochentag', nil, mfOKButton);
  //  ListBox^.List^.FreeAll;
  //  MessageBox('Wochentag', nil, mfOKButton);
  //  ListBox^.SetRange(ListBox^.List^.Count);
  //  MessageBox('Wochentag', nil, mfOKButton);
  //end;
  //
  //
  //
  //MessageBox('Wochentag', nil, mfOKButton);


  //ListBox^.Insert(NewStr('aaaaaaaaa'));
  //
  //ListBox^.List^.Insert(NewStr('bbbbbbb'));
  //ListBox^.SetRange(ListBox^.List^.Count);



  // Cancel-Button
  Rect.Assign(19, 9, 32, 10);
  Insert(new(PButton, Init(Rect, '~T~ag', cmTag, bfNormal)));

  // Ok-Button
  Rect.Assign(7, 9, 17, 10);
  Insert(new(PButton, Init(Rect, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  s: string;

begin

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
//          ListBox^.FreeAll;
          //          MessageBox('Wochentag', nil, mfOKButton);
        end;

        cmTag: begin
          str(ListBox^.Focused + 1, s);
          MessageBox('Wochentag: ' + s + ' gew' + #132 + 'hlt', nil, mfOKButton);
          ClearEvent(Event);   // Event beenden.
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);

end;
//handleevent-

end.
