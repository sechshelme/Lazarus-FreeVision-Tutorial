unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TView }

  TView = class(TObject)
    procedure Draw; virtual;
  end;

  { TWindow }

  TWindow = class(TView)
    procedure Draw; override;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    view: TView;
    win: TWindow;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure Ausgabe(v: TView);
begin
  v.Draw;
end;

{ TWindow }

procedure TWindow.Draw;
begin
  WriteLn('Window');
end;

{ TView }

procedure TView.Draw;
begin
  WriteLn('View');
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  view := TView.Create;
  win := TWindow.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  view.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Ausgabe(view);
  Ausgabe(win);

  view.Draw;
  win.Draw;
end;

end.
