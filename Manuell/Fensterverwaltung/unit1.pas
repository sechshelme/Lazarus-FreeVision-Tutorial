unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TView }

  TView = class(TObject)
  private
    Canvas: TCanvas;
    A, B: TPoint;
  public
    constructor Create(c: TCanvas);
    procedure Assign(AX, AY, BX, BY: integer);
    procedure Draw;
    function iSClick(x, y: integer): boolean;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    Views: array of TView;
  public


  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TView }

constructor TView.Create(c: TCanvas);
begin
  Canvas := c;
end;

procedure TView.Assign(AX, AY, BX, BY: integer);
begin
  A.X := AX;
  A.Y := AY;
  B.X := BX;
  B.Y := BY;
end;

procedure TView.Draw;
begin
  Canvas.Rectangle(A.X, A.Y, B.X, B.Y);
end;

function TView.iSClick(x, y: integer): boolean;
begin
  Result := (x >= A.X) and (y >= A.Y) and (x <= B.X) and (y <= B.Y);
end;

{ TForm1 }

procedure TForm1.FormClick(Sender: TObject);
var
  i, x, y: integer;
  m:TPoint;
begin

  m:=ScreenToClient(Mouse.CursorPos);
  x := m.X;
  y := m.Y;

  i := 0;
  while i < Length(Views) do begin
    if Views[i].iSClick(x, y) then begin
      Caption := x.ToString + '  ' + y.ToString +'  '+i.ToString+ ' True';
      Exit;
    end else begin
      Caption := x.ToString + '  ' + y.ToString +'  '+i.ToString+ ' False';
    end;
    Inc(i);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  SetLength(Views, 10);
  for i := 0 to Length(Views) - 1 do begin
    Views[i] := TView.Create(Canvas);
    Views[i].Assign(Random(Width), Random(Height), Random(Width), Random(Height));
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Length(Views) - 1 do begin
    Views[i].Free;
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Length(Views) - 1 do begin
    Views[i].Draw;
  end;
end;

end.
