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
    procedure Insert(V: TView);

    function MouseDown(x, y: integer): boolean;
    function MouseMove(Shift: TShiftState; X, Y: integer): boolean;

    procedure Assign(AX, AY, BX, BY: integer);
    procedure Move(x, y: integer);
    procedure Draw;
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
    Views: array of TView;
    Desktop: TView;
  public
  end;

var
  Form1: TForm1;
  Panel: TPanel;

implementation

{$R *.lfm}

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

procedure TView.Insert(V: TView);
begin
  System.Insert(V, View, 0);
  View[0] := TView.Create();
end;

function TView.MouseDown(x, y: integer): boolean;
begin
  Result := (x >= A.X) and (y >= A.Y) and (x <= B.X) and (y <= B.Y);
  isDown := Result;
  MousePos.X := x;
  MousePos.Y := y;
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
begin
  Panel.Canvas.Brush.Color := FColor;
  Panel.Canvas.Rectangle(A.X, A.Y, B.X, B.Y);
  Panel.Canvas.TextOut(A.X, A.Y, Caption);
end;

{ TForm1 }

procedure TForm1.ButtonminusClick(Sender: TObject);
var
  v: TView;
begin
  if TButton(Sender).Name = 'Buttonplus' then begin
    v := TView.Create;
    v.Assign(Random(Width), Random(Height), Random(Width), Random(Height));
    v.Color := Random($FFFFFF);
    v.Caption := IntToStr(Length(Views));
    Insert(v, Views, 0);
  end;

  if Length(Views) > 0 then begin
    case TButton(Sender).Name of
      'Buttonminus': begin
        Views[0].Free;
        Delete(Views, 0, 1);
      end;
      'Buttonleft': begin
        Views[0].Move(-8, 0);
      end;
      'Buttonright': begin
        Views[0].Move(8, 0);
      end;
      'Buttonup': begin
        Views[0].Move(0, -8);
      end;
      'Buttondown': begin
        Views[0].Move(0, 8);
      end;
    end;
    Repaint;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Panel1.DoubleBuffered := True;
  Panel := Panel1;
  Randomize;
  SetLength(Views, 10);
  for i := 0 to Length(Views) - 1 do begin
    Views[i] := TView.Create;
    with Panel1 do begin
      Views[i].Assign(Random(Width), Random(Height), Random(Width), Random(Height));
    end;
    Views[i].Color := Random($FFFFFF);
    Views[i].Caption := IntToStr(i);
  end;

  Desktop := TDesktop.Create;
  Desktop.Assign(10, 10, Width - 20, Height - 20);
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Length(Views) - 1 do begin
    Views[i].Free;
  end;
  Desktop.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i: integer;
begin
  Desktop.Draw;
  for i := Length(Views) - 1 downto 0 do begin
    Views[i].Draw;
  end;
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i: integer;
  v: TView;
begin
  i := 0;
  while i < Length(Views) do begin
    if Views[i].MouseDown(X, Y) then begin
      if i <> 0 then begin
        v := Views[i];
        Delete(Views, i, 1);
        Insert(v, Views, 0);
        Panel1.Repaint;
      end;
      Exit;
    end else begin
    end;
    Inc(i);
  end;
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  if Length(Views) > 0 then begin
    Views[0].MouseMove(Shift, X, Y);
  end;
end;

end.
