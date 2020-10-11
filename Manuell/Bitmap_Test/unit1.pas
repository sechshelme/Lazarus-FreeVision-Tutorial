unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, GraphType;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;


procedure RawRectangle(x1, y1, x2, y2: integer; r: TRawImage);
var
  x, y: integer;
begin
  for x := x1 to x2-1 do begin
    for y := y1 to y2-1 do begin
      r.Data[(x * 4 + 3) + r.Description.Width * y * 4] := $FF;
    end;
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  bitmap: TBitmap;
  x, y: integer;

var
  r: TRawImage;

begin
  Canvas.Pen.Color := clRed;
  for x := 1 to 100 do begin
    Canvas.Line(x * 10, 0, x * 10, ClientHeight);
  end;
  bitmap := TBitmap.Create;


  r.Init;
  //  r.Description.Init_BPP32_R8G8B8A8_BIO_TTB(100,100);
  r.Description.Init_BPP32_B8G8R8A8_BIO_TTB(100, 100);
  r.CreateData(True);
//  bitmap.LoadFromRawImage(r, True);
  bitmap.Width := 100;
  bitmap.Height := 100;
  bitmap.LoadFromFile('project1.bmp');

  bitmap.Canvas.Pen.Color := clYellow;
  bitmap.Canvas.Brush.Color := clGreen;

//  RawRectangle(6, 6, 86, 86, bitmap.RawImage);
//  RawRectangle(6, 6, 46, 46, bitmap.RawImage);
  bitmap.Canvas.Rectangle(6, 6, 86, 86);
  Canvas.Draw(10, 10, bitmap);
  bitmap.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
end;

end.
