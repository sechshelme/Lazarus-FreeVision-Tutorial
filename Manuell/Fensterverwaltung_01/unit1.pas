unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TView }

  TView = class(TObject)
  private
    A, B: TPoint;
    FCaption: string;
    FColor: TColor;
    MousePos: TPoint;
    isDown: boolean;
    View: array of TView;

    procedure SetCaption(AValue: string);
    procedure SetColor(AValue: TColor);
  public
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor;
    constructor Create;
    destructor Destroy; override;
    procedure Insert(V: TView);

    function MouseDown(x, y: integer): boolean; virtual;  override;
    function MouseMove(Shift: TShiftState; X, Y: integer): boolean; virtual; override;

    procedure Assign(AX, AY, BX, BY: integer);
    procedure Move(x, y: integer); virtual;
    procedure Draw; virtual;
  end;

  { TWindow }

  TWindow = class(TView)
    function MouseDown(x, y: integer): boolean; virtual;
    function MouseMove(Shift: TShiftState; X, Y: integer): boolean; virtual;
  end;

  TDesktop = class(TView)

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
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
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

{ TWindow }

function TWindow.MouseDown(x, y: integer): boolean;
begin
       Panel.Color:=Random($ffffff);
end;

function TWindow.MouseMove(Shift: TShiftState; X, Y: integer): boolean;
begin

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
end;

destructor TView.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(View) - 1 do begin
    View[i].Free;
  end;
  inherited Destroy;
end;

procedure TView.Insert(V: TView);
begin
  System.Insert(V, View, 0);
end;

function TView.MouseDown(x, y: integer): boolean;
var
  i: integer;
  v: TView;
begin
  Result := (x >= A.X) and (y >= A.Y) and (x <= B.X) and (y <= B.Y);
  isDown := Result;
  MousePos.X := x;
  MousePos.Y := y;

  i := 0;
  while i < Length(View) do begin
    if View[i].MouseDown(X, Y) then begin
      WriteLn(i);
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

function TView.MouseMove(Shift: TShiftState; X, Y: integer): boolean;
begin
  if ssLeft in Shift then begin
    if isDown then begin
      if (x <> MousePos.X) or (y <> MousePos.Y) then begin
        Result := True;
        Self.Move(X - MousePos.X, Y - MousePos.Y);
        Panel.Refresh;

        MousePos.X := x;
        MousePos.Y := y;
      end else begin
        Result := False;
      end;
    end;
  end else begin
    isDown := False;
  end;

  if Length(View) > 0 then begin
    View[0].MouseMove(Shift, X, Y);
  end;

end;

procedure TView.Assign(AX, AY, BX, BY: integer);

  procedure swap(var a: integer; var b: integer);
  var
    c: integer;
  begin
    if a > b then begin
      c := a;
      a := b;
      b := c;
    end;
  end;

begin
  swap(AX, BX);
  swap(AY, BY);
  A.X := AX;
  A.Y := AY;
  B.X := BX;
  B.Y := BY;
end;

procedure TView.Move(x, y: integer);
begin
  Inc(A.X, x);
  Inc(A.Y, y);
  Inc(B.X, x);
  Inc(B.Y, y);
end;

procedure TView.Draw;
var
  i: integer;
begin
  Panel.Canvas.Brush.Color := FColor;
  Panel.Canvas.Rectangle(A.X, A.Y, B.X, B.Y);
  Panel.Canvas.TextOut(A.X, A.Y, Caption);
  for i := Length(View) - 1 downto 0 do begin
    View[i].Draw;
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
  win: TWindow;
begin
  Panel1.DoubleBuffered := True;
  Panel := Panel1;
  Randomize;

  Desktop := TDesktop.Create;
  Desktop.Assign(10, 10, Panel1.Width - 20, Panel1.Height - 20);
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';

  for i := 0 to 10 do begin
    win := TWindow.Create;
    with Panel do begin
      win.Assign(Random(Width), Random(Height), Random(Width), Random(Height));
    end;
    win.Color := Random($FFFFFF);
    win.Caption := IntToStr(i);
    Desktop.Insert(win);
  end;
  //  Desktop.Draw;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Desktop.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  Desktop.Draw;
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  Desktop.MouseDown(X, Y);
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  Desktop.MouseMove(Shift, X, Y);
end;

end.
