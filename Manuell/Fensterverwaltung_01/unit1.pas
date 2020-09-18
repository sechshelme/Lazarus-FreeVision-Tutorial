unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView, WMButton, WMWindow, WMDialog;

type

  { TDesktop }

  TDesktop = class(TView)
    constructor Create; override;
  end;

  { TMyDialog }

  TMyDialog = class(TDialog)
  private
    btn0, btn1, btn2: TButton;
  public
    constructor Create; override;
    procedure EventHandle(Event: TEvent); override;
  end;



  { TForm1 }

  TForm1 = class(TForm)
    Buttonup: StdCtrls.TButton;
    Buttonminus: StdCtrls.TButton;
    Buttonleft: StdCtrls.TButton;
    Buttonright: StdCtrls.TButton;
    Buttonplus: StdCtrls.TButton;
    Buttondown: StdCtrls.TButton;
    Panel1: TPanel;
    procedure ButtonminusClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; WMButton: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
  private
    //    Views: array of TView;
    Desktop: TView;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  cmBtn0 = 1000;
  cmBtn1 = 1001;
  cmBtn2 = 1002;

{ TMyDialog }

constructor TMyDialog.Create;
begin
  inherited Create;

  btn0 := TButton.Create;
  btn0.Assign(10, 40, 50, 60);
  btn0.Caption := 'btn0';
  btn0.Command := cmBtn0;
  Self.Insert(btn0);

  btn1 := TButton.Create;
  btn1.Assign(60, 40, 100, 60);
  btn1.Caption := 'btn1';
  btn1.Command := cmBtn1;
  Self.Insert(btn1);

  btn2 := TButton.Create;
  btn2.Assign(110, 40, 150, 60);
  btn2.Caption := 'btn2';
  btn2.Command := cmBtn2;
  Self.Insert(btn2);
end;

procedure TMyDialog.EventHandle(Event: TEvent);
begin
  inherited EventHandle(Event);

  if Event.State = Mouse then begin
    case Event.Command of
      cmBtn0: begin
        WriteLn('Button 0 gedrückt');
      end;
      cmBtn1: begin
        WriteLn('Button 1 gedrückt');
      end;
      cmBtn2: begin
        WriteLn('Button 2 gedrückt');
      end;
    end;
  end;
end;

{ TDesktop }

constructor TDesktop.Create;
begin
  inherited Create;
end;

{ TForm1 }

procedure TForm1.ButtonminusClick(Sender: TObject);
var
  v: TView;
begin
  //if TButton(Sender).Name = 'Buttonplus' then begin
  //  v := TView.Create;
  //  v.Assign(Random(Width), Random(Height), Random(Width), Random(Height));
  //  v.Color := Random($FFFFFF);
  //  v.Caption := IntToStr(Length(Views));
  //  Insert(v, Views, 0);
  //end;
  //
  //if Length(Views) > 0 then begin
  //  case TButton(Sender).Name of
  //    'Buttonminus': begin
  //      Views[0].Free;
  //      Delete(Views, 0, 1);
  //    end;
  //    'Buttonleft': begin
  //      Views[0].Move(-8, 0);
  //    end;
  //    'Buttonright': begin
  //      Views[0].Move(8, 0);
  //    end;
  //    'Buttonup': begin
  //      Views[0].Move(0, -8);
  //    end;
  //    'Buttondown': begin
  //      Views[0].Move(0, 8);
  //    end;
  //  end;
  //  Repaint;
  //end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
  win: TWindow;
  Dialog: TMyDialog;
  l, r: integer;
const
  rand = 40;
begin
  Panel1.DoubleBuffered := True;
  Panel := Panel1;
  Randomize;

  Desktop := TDesktop.Create;
  Desktop.Assign(rand, rand, Panel1.Width - rand, Panel1.Height - rand);
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';

  for i := 0 to 19 do begin
    win := TWindow.Create;
    with Panel do begin
      l := Random(Width);
      r := Random(Height);

      win.Assign(l, r, l + Random(500) + 200, r + Random(500) + 200);
    end;
    //    win.Color := Random($FFFFFF);
    win.Caption := 'Fenster: ' + IntToStr(i);
    Desktop.Insert(win);
  end;

  Dialog := TMyDialog.Create;
  Dialog.Assign(100, 100, 400, 300);
  //  Dialog.Color := clGreen;
  Dialog.Caption := 'Mein Dialog';
  Desktop.Insert(Dialog);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Desktop.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i: integer;
begin

  //  for i := 1 to 10 do begin
//    Panel1.Canvas.Line(i * 100, 0, i * 100, Panel1.Height);
//  end;
  Desktop.Draw;
  Desktop.DrawBitmap(Panel1.Canvas);
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; WMButton: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  Desktop.MouseDown(X, Y);
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  Desktop.MouseMove(Shift, X, Y);
end;

end.
