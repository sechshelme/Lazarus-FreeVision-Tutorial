unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type
  TEvent=record
    State:(Mouse,KeyPress,cm);
    Command:Integer;
  end;


  { TView }

  TView = class(TObject)
  private
  protected
    Bitmap: TBitmap;
    ViewRect: TRect;
    FCaption: string;
    FColor: TColor;
    MousePos: TPoint;
    isDown: boolean;
    Parent: TView;
    View: array of TView;
    procedure SetCaption(AValue: string);
    procedure SetColor(AValue: TColor);
    function calcOfs: TPoint;
  public
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Insert(AView: TView);

    function MouseDown(x, y: integer): boolean; virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); virtual;

    procedure Assign(AX, AY, BX, BY: integer);
    procedure Move(x, y: integer); virtual;
    procedure Resize(x, y: integer); virtual;
    procedure Draw; virtual;
    procedure DrawBitmap(c: TCanvas); virtual;
    procedure EventHandle(Event:TEvent);virtual;
  end;

  { TWindow }

  TWindow = class(TView)
  protected
    isMoveable, isResize: boolean;
  public
    constructor Create; override;
    function MouseDown(x, y: integer): boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure Draw; override;
  end;

  { TButton2 }

  TButton2 = class(TView)
  private
    FCommand: Integer;
  public
    property Command:Integer read FCommand write FCommand;
    constructor Create; override;
    function MouseDown(x, y: integer): boolean; override;
    procedure Draw; override;
    procedure EventHandle(Event:TEvent);virtual;
  end;

  { TDialog }

  TDialog = class(TWindow)
  private
    btn0, btn1, btn2: TButton2;
  public
    constructor Create;  override;
    destructor Destroy; override;
  end;


  { TDesktop }

  TDesktop = class(TView)
    constructor Create;  override;
  end;



  { TForm1 }

  TForm1 = class(TForm)
    Buttonup: TButton;
    Buttonminus: TButton;
    Buttonleft: TButton;
    Buttonright: TButton;
    Buttonplus: TButton;
    Buttondown: TButton;
    Panel1: TPanel;
    procedure ButtonminusClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
  private
    //    Views: array of TView;
    Desktop: TView;
  public
  end;

var
  Form1: TForm1;
  Panel: TPanel;

implementation

{$R *.lfm}

const
  TitelBarSize = 20;
  minWinSize = 50;

  cmBtn0=1000;
  cmBtn1=1001;
  cmBtn2=1002;

{ TDialog }

constructor TDialog.Create;
begin
  inherited Create;

  btn0 := TButton2.Create;
  btn0.Assign(10, 40, 50, 60);
  btn0.Caption := 'btn0';
  btn0.Command:=cmBtn0;
  Self.Insert(btn0);

  btn1 := TButton2.Create;
  btn1.Assign(60, 40, 100, 60);
  btn1.Caption := 'btn1';
  btn1.Command:=cmBtn1;
  Self.Insert(btn1);

  btn2 := TButton2.Create;
  btn2.Assign(110, 40, 150, 60);
  btn2.Caption := 'btn2';
  btn2.Command:=cmBtn2;
  Self.Insert(btn2);
end;

destructor TDialog.Destroy;
begin
  inherited Destroy;
end;

{ TDesktop }

constructor TDesktop.Create;
begin
  inherited Create;
end;

{ TView }

procedure TView.SetCaption(AValue: string);
begin
  if FCaption = AValue then begin
    Exit;
  end;
  FCaption := AValue;
end;

procedure TView.SetColor(AValue: TColor);
begin
  if FColor = AValue then begin
    Exit;
  end;
  FColor := AValue;
end;

constructor TView.Create;
begin
  inherited Create;
  Parent := nil;
  isDown := False;
  Bitmap := TBitmap.Create;
end;

destructor TView.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(View) - 1 do begin
    View[i].Free;
  end;
  Bitmap.Free;
  inherited Destroy;
end;

procedure TView.Insert(AView: TView);
begin
  AView.Parent := Self;
  System.Insert(AView, View, 0);
end;

function TView.calcOfs: TPoint;
var
  v: TView;
begin
  Result := ViewRect.TopLeft;
  v := Parent;
  while v <> nil do begin
    Inc(Result.X, v.ViewRect.Left);
    Inc(Result.Y, v.ViewRect.Top);
    v := v.Parent;
  end;
end;

function TView.MouseDown(x, y: integer): boolean;
var
  i: integer;
  v: TView;
  p: TPoint;
begin
  p := calcOfs;

  with ViewRect do begin
    Result := (x >= p.X) and (y >= p.Y) and (x <= p.X + Width) and (y <= p.Y + Height);
  end;
  isDown := Result;
  MousePos.X := x;
  MousePos.Y := y;

  i := 0;
  while i < Length(View) do begin
    if View[i].MouseDown(X, Y) then begin
      if i <> 0 then begin
        v := View[i];
        Delete(View, i, 1);
        system.Insert(v, View, 0);
        Panel.Repaint;
      end;
      Exit;
    end else begin
      Inc(i);
    end;
  end;
end;

procedure TView.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  if Length(View) > 0 then begin
    View[0].MouseMove(Shift, X, Y);
  end;
end;

procedure TView.Assign(AX, AY, BX, BY: integer);
begin
  ViewRect.Left := AX;
  ViewRect.Right := BX;
  ViewRect.Top := AY;
  ViewRect.Bottom := BY;
  ViewRect.NormalizeRect;
  Bitmap.Width := ViewRect.Width;
  Bitmap.Height := ViewRect.Height;
end;

procedure TView.Move(x, y: integer);
begin
  Inc(ViewRect.Left, x);
  Inc(ViewRect.Right, x);
  Inc(ViewRect.Top, y);
  Inc(ViewRect.Bottom, y);
end;

procedure TView.Resize(x, y: integer);
begin
  Inc(ViewRect.Right, x);
  if ViewRect.Right - ViewRect.Left < minWinSize then begin
    ViewRect.Right := ViewRect.Left + minWinSize;
  end;
  Inc(ViewRect.Bottom, y);
  if ViewRect.Bottom - ViewRect.Top < minWinSize then begin
    ViewRect.Bottom := ViewRect.Top + minWinSize;
  end;
  Bitmap.Width := ViewRect.Width;
  Bitmap.Height := ViewRect.Height;
end;

procedure TView.Draw;
var
  i: integer;
begin
  Bitmap.Canvas.Brush.Color := FColor;
  Bitmap.Canvas.Rectangle(0, 0, ViewRect.Width, ViewRect.Height);
  for i := Length(View) - 1 downto 0 do begin
    View[i].Draw;
    View[i].DrawBitmap(Bitmap.Canvas);
  end;
end;

procedure TView.DrawBitmap(c: TCanvas);
begin
  c.Draw(ViewRect.Left, ViewRect.Top, Bitmap);
end;

procedure TView.EventHandle(Event: TEvent);
begin

end;

{ TWindow }

constructor TWindow.Create;
begin
  inherited Create;
  isMoveable := False;
  isResize := False;
end;

function TWindow.MouseDown(x, y: integer): boolean;
var
  p: TPoint;
begin
  Result := inherited MouseDown(x, y);
  p := calcOfs;
  if Result then begin
    isMoveable := y < p.Y + TitelBarSize;
    isResize := (x > p.X + ViewRect.Width - TitelBarSize) and (y > p.Y + ViewRect.Height - TitelBarSize);
  end;
end;

procedure TWindow.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  if ssLeft in Shift then begin
    if isDown then begin
      if isMoveable then begin
        Self.Move(X - MousePos.X, Y - MousePos.Y);
      end;
      if isResize then begin
        Self.Resize(X - MousePos.X, Y - MousePos.Y);
      end;
      Panel.Refresh;
      MousePos.X := x;
      MousePos.Y := y;
    end;
  end else begin
    isDown := False;
    isMoveable := False;
    isResize := False;
  end;

  if Length(View) > 0 then begin
    //    View[0].MouseMove(Shift, X, Y);
  end;
end;

procedure TWindow.Draw;
var
  w, h: integer;
begin
  FColor := clBlue;
  inherited Draw;

  Bitmap.Canvas.Brush.Color := clGray;
  Bitmap.Canvas.Rectangle(0, 0, ViewRect.Width, TitelBarSize);
  Bitmap.Canvas.GetTextSize(Caption, w, h);

  with ViewRect do begin
    Bitmap.Canvas.TextOut(Width div 2 - w div 2, 2, Caption);
  end;

  Bitmap.Canvas.Rectangle(ViewRect.Width - TitelBarSize, ViewRect.Height - TitelBarSize,
    ViewRect.Width, ViewRect.Height);

  Bitmap.Canvas.TextOut(ViewRect.Width - TitelBarSize + 4,
    ViewRect.Height - TitelBarSize + 1, '⤡');
end;

{ TButton }

constructor TButton2.Create;
begin
  inherited Create;
  Color := clYellow;
end;

function TButton2.MouseDown(x, y: integer): boolean;
var
  ev:TEvent;
begin
  Result := inherited MouseDown(x, y);
  if Result then begin
    Color := Random($FFFFFF);
    Panel.Repaint;
  end;

  ev.State:=Mouse;
  ev.Command:=FCommand;
  EventHandle(ev);
end;

procedure TButton2.Draw;
begin
  inherited Draw;
  Bitmap.Canvas.TextOut(3, 1, Caption);
end;

procedure TButton2.EventHandle(Event: TEvent);
begin
  inherited EventHandle(Event);
  if Parent<>nil then begin
//    Parent.EventHandle(e);
  end;

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
  win: TDialog;
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
    win := TDialog.Create;
    with Panel do begin
      l := Random(Width);
      r := Random(Height);

      //      l:=200;r:=200;

      win.Assign(l, r, l + Random(500) + 200, r + Random(500) + 200);
    end;
    win.Color := Random($FFFFFF);
    win.Caption := 'Fenster: ' + IntToStr(i);
    Desktop.Insert(win);
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Desktop.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to 10 do begin
    Panel1.Canvas.Line(i * 100, 0, i * 100, Panel1.Height);
  end;
  Desktop.Draw;
  Desktop.DrawBitmap(Panel1.Canvas);
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  Desktop.MouseDown(X, Y);
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  Desktop.MouseMove(Shift, X, Y);
end;

end.
