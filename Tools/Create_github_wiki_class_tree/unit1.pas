unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, FileUtil,Clipbrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  fsl, sl: TStringList;
  i, j: integer;
  s: string;
  sa: TStringArray;
begin
  Memo1.Clear;
  Memo1.Lines.Add('```mermaid');
  Memo1.Lines.Add('classDiagram');
  Memo1.Lines.Add('direction RL');
  fsl := FindAllFiles('/home/tux/fpcupdeluxe_avr5/fpcsrc/packages/fv/src', '*.pas;*.inc');
  for i := 0 to fsl.Count - 1 do begin
    sl := TStringList.Create;
    sl.LoadFromFile(fsl[i]);
    for j := 0 to sl.Count - 1 do begin
      s := sl[j];
      s := StringReplace(s, ' ', '', [rfIgnoreCase, rfReplaceAll]);
      if Pos('OBJECT(T', UpCase(s)) > 0 then begin
        sa := s.Split(['=', '(', ')']);
        if Length(sa) >= 3 then begin
          Memo1.Lines.Add(sa[0] + '<..' + sa[2]);
        end;
      end;
    end;
    sl.Free;
  end;
  fsl.Free;
  Memo1.Lines.Add('```');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Lines.SaveToFile('/n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/FreeVision/Class_Tree.md');
end;

end.
