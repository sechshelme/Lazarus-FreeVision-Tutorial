program project1;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  WMButton,
  WMView,
  WMWindow,
  WMDialog,
  WMDesktop,
  WMApplication,
  WMMenu,
  WMMemo,
  WMToolbar,
  WMSystem;

{$R *.res}

type
  { TMyDialog }

  TMyDialog = class(TDialog)
  private
    btnClose, btnQuit, btn0, btn1, btn2: TButton;
  public
    constructor Create; override;
    procedure EventHandle(var Event: TEvent); override;
  end;

  { TMyEditor }

  TMyEditor = class(TWindow)
  private
    Memo: TMemo;
  public
    constructor Create; override;
  end;

  { TMyApp }

  TMyApp = class(TApplication)
  public
    constructor Create; override;
    procedure NewWindow;
    procedure NewDialog;
    procedure NewEditor;
    procedure EventHandle(var Event: TEvent); override;
  end;

const
  cmBtn0 = 1000;
  cmBtn1 = 1001;
  cmBtn2 = 1002;
  cmNewWindow = 1003;
  cmNewDialog = 1004;
  cmNewMemo = 1005;

  { TMyEditor }

  constructor TMyEditor.Create;
  begin
    inherited Create;
    Memo := TMemo.Create;
    Memo.Width := Client.Width - 10;
    Memo.Height := Client.Height - 10;
    Memo.Anchors := [akLeft, akTop, akRight, akBottom];
    Memo.Top := 5;
    Memo.Left := 5;
    Client.InsertView(Memo);
  end;

  { TMyDialog }

  constructor TMyDialog.Create;
  begin
    inherited Create;

    Left := 100;
    Top := 100;
    Width := 500;
    Height := 200;
    Caption := 'Mein Dialog';

    btn0 := TButton.Create;
    btn0.Anchors := [akRight, akBottom];
    btn0.Top := Client.Height - btn0.Height - 10;
    btn0.Left := Client.Width - (btn0.Width + 10) * 5;
    btn0.Caption := 'btn0';
    btn0.Command := cmBtn0;
    Client.InsertView(btn0);

    btn1 := TButton.Create;
    btn1.Anchors := [akRight, akBottom];
    btn1.Top := Client.Height - btn1.Height - 10;
    btn1.Left := Client.Width - (btn0.Width + 10) * 4;
    btn1.Caption := 'btn1';
    btn1.Command := cmBtn1;
    Client.InsertView(btn1);

    btn2 := TButton.Create;
    btn2.Anchors := [akRight, akBottom];
    btn2.Top := Client.Height - btn2.Height - 10;
    btn2.Left := Client.Width - (btn0.Width + 10) * 3;
    btn2.Caption := 'btn2';
    btn2.Command := cmBtn2;
    Client.InsertView(btn2);

    btnClose := TButton.Create;
    btnClose.Anchors := [akRight, akBottom];
    btnClose.Top := Client.Height - btnClose.Height - 10;
    btnClose.Left := Client.Width - (btn0.Width + 10) * 2;
    btnClose.Caption := 'Close';
    btnClose.Command := cmClose;
    Client.InsertView(btnClose);

    btnQuit := TButton.Create;
    btnQuit.Anchors := [akRight, akBottom];
    btnQuit.Top := Client.Height - btnQuit.Height - 10;
    btnQuit.Left := Client.Width - btn0.Width - 10;
    btnQuit.Caption := 'Quit';
    btnQuit.Command := cmQuit;
    Client.InsertView(btnQuit);
  end;

  procedure TMyDialog.EventHandle(var Event: TEvent);
  begin
    if Event.What = whcmCommand then begin
      case Event.Command of
        cmBtn0: begin
          WriteLn('Button 0 gedrückt');
        end;
        cmBtn1: begin
          WriteLn('Button 1 gedrückt');
        end;
        cmBtn2: begin
          WriteLn('Button 2 gedrückt');
        end else begin
          //         if Parent<>nil;
        end;
      end;
    end;
    inherited EventHandle(Event);
  end;

  { TMyApp }

  constructor TMyApp.Create;
  var
    i: integer;
  begin
    inherited Create;
    Width := 800;
    Height := 600;
    ToolBar.AddButton('NewWin', cmNewWindow);
    ToolBar.AddButton('NewDia', cmNewDialog);
    ToolBar.AddButton('NewMemo', cmNewMemo);
    ToolBar.AddButton('Close', cmClose);
    ToolBar.AddButton('Quit', cmQuit);

    SetLength(MenuItems.Items, 6);

    MenuItems.Items[0].Caption := '&Datei';
    SetLength(MenuItems.Items[0].Items, 8);
    MenuItems.Items[0].Items[0].Caption := '&Neu';
    MenuItems.Items[0].Items[0].Command := cmNewWindow;
    MenuItems.Items[0].Items[1].Caption := '&Oeffnen...';
    MenuItems.Items[0].Items[2].Caption := '-';
    MenuItems.Items[0].Items[3].Caption := '&Speichern';
    MenuItems.Items[0].Items[4].Caption := 'Speichern &unter...';
    MenuItems.Items[0].Items[5].Caption := '&Schliessen';
    MenuItems.Items[0].Items[5].Command := cmClose;
    MenuItems.Items[0].Items[6].Caption := '-';
    MenuItems.Items[0].Items[7].Caption := '&Beenden';
    MenuItems.Items[0].Items[7].Command := cmQuit;

    MenuItems.Items[1].Caption := '&Bearbeiten';
    SetLength(MenuItems.Items[1].Items, 3);
    MenuItems.Items[1].Items[0].Caption := '&Ausschneiden';
    MenuItems.Items[1].Items[1].Caption := '&Kopieren';
    MenuItems.Items[1].Items[2].Caption := '&Einfügen';

    MenuItems.Items[2].Caption := '&Optionen';
    SetLength(MenuItems.Items[2].Items, 5);
    MenuItems.Items[2].Items[0].Caption := 'Opt&0';
    MenuItems.Items[2].Items[0].Command := cmopti0;
    MenuItems.Items[2].Items[1].Caption := 'Opt&1';
    MenuItems.Items[2].Items[1].Command := cmopti1;
    MenuItems.Items[2].Items[2].Caption := 'Opt&2';
    MenuItems.Items[2].Items[2].Command := cmopti2;
    MenuItems.Items[2].Items[3].Caption := '&Mehr0';
    MenuItems.Items[2].Items[4].Caption := '&Mehr1';

    SetLength(MenuItems.Items[2].Items[3].Items, 4);
    MenuItems.Items[2].Items[3].Items[0].Caption := 'Test&0';
    MenuItems.Items[2].Items[3].Items[0].Command := cmTest0;
    MenuItems.Items[2].Items[3].Items[1].Caption := 'Test&1';
    MenuItems.Items[2].Items[3].Items[1].Command := cmTest1;
    MenuItems.Items[2].Items[3].Items[2].Caption := 'Test&2';
    MenuItems.Items[2].Items[3].Items[2].Command := cmTest2;
    MenuItems.Items[2].Items[3].Items[3].Caption := '&Close';
    MenuItems.Items[2].Items[3].Items[3].Command := cmClose;

    SetLength(MenuItems.Items[2].Items[4].Items, 5);
    MenuItems.Items[2].Items[4].Items[0].Caption := 'Test&0';
    MenuItems.Items[2].Items[4].Items[0].Command := cmTest0;
    MenuItems.Items[2].Items[4].Items[1].Caption := 'Test&1';
    MenuItems.Items[2].Items[4].Items[1].Command := cmTest1;
    MenuItems.Items[2].Items[4].Items[2].Caption := 'Test&2';
    MenuItems.Items[2].Items[4].Items[2].Command := cmTest2;
    MenuItems.Items[2].Items[4].Items[3].Caption := '&Close';
    MenuItems.Items[2].Items[4].Items[3].Command := cmClose;
    MenuItems.Items[2].Items[4].Items[4].Caption := '&Sub';


    SetLength(MenuItems.Items[2].Items[4].Items[4].Items, 4);
    MenuItems.Items[2].Items[4].Items[4].Items[0].Caption := '&s0';
    MenuItems.Items[2].Items[4].Items[4].Items[0].Command := cmNewDialog;
    MenuItems.Items[2].Items[4].Items[4].Items[1].Caption := '&s1';
    MenuItems.Items[2].Items[4].Items[4].Items[1].Command := cmNewDialog;
    MenuItems.Items[2].Items[4].Items[4].Items[2].Caption := '&s2';
    MenuItems.Items[2].Items[4].Items[4].Items[2].Command := cmNewDialog;
    MenuItems.Items[2].Items[4].Items[4].Items[3].Caption := '&s3';
    MenuItems.Items[2].Items[4].Items[4].Items[3].Command := cmNewDialog;


    MenuItems.Items[3].Caption := '&Hilfe';
    SetLength(MenuItems.Items[3].Items, 2);
    MenuItems.Items[3].Items[0].Caption := '&Hilfe';
    MenuItems.Items[3].Items[1].Caption := '&About...';

    MenuItems.Items[4].Caption := '&New';
    MenuItems.Items[4].Command := cmNewWindow;
    MenuItems.Items[5].Caption := '&Close';
    MenuItems.Items[5].Command := cmClose;
    Menu.MenuBar.MenuItem := MenuItems;

    for i := 0 to 19 do begin
      NewWindow;
    end;

    NewDialog;
  end;

  procedure TMyApp.NewWindow;
  var
    win: TWindow;
  const
    ctr: integer = 1;
  begin
    win := TWindow.Create;
    win.Left := Random(Width * 2 div 3);
    win.Top := Random(Height * 2 div 3);
    win.Width := Random(Width div 3) + 100;
    win.Height := Random(Height div 3) + 100;
    win.Caption := 'Fenster: ' + IntToStr(ctr);
    Inc(ctr);
    Desktop.InsertView(win);
  end;

  procedure TMyApp.NewDialog;
  var
    Dialog: TMyDialog;
  begin
    Dialog := TMyDialog.Create;
    Desktop.InsertView(Dialog);
  end;

  procedure TMyApp.NewEditor;
  var
    Edit: TMyEditor;
  begin
    Edit := TMyEditor.Create;
    Edit.Left := Random(Width * 2 div 3);
    Edit.Top := Random(Height * 2 div 3);
    Edit.Width := Random(Width div 3) + 100;
    Edit.Height := Random(Height div 3) + 100;
    Edit.Caption := 'Memo';
    Desktop.InsertView(Edit);
  end;

  procedure TMyApp.EventHandle(var Event: TEvent);
  var
    ev: TEvent;
  begin
    if Event.What = whcmCommand then begin
      case Event.Command of
        cmNewWindow: begin
          NewWindow;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
        cmNewDialog: begin
          NewDialog;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
        cmNewMemo: begin
          NewEditor;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
        cmTest0: begin
          WriteLn('test0');
        end;
        cmTest1: begin
          WriteLn('test1');
        end;
        cmTest2: begin
          WriteLn('test2');
        end;
        cmopti0: begin
          WriteLn('opti0');
        end;
        cmopti1: begin
          WriteLn('opti1');
        end;
        cmopti2: begin
          WriteLn('opti2');
        end;
        else begin
        end;
      end;
    end;

    inherited EventHandle(Event);
  end;

var
  App: TMyApp;

begin
  App := TMyApp.Create;
  App.Run;
  App.Free;
end.
