unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, FileUtil, Clipbrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Borland: TCheckBox;
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
  i, j, p: integer;
  uname, s, st: string;
  sa: TStringArray;
begin
  Memo1.Clear;
  Memo1.Lines.Add('```mermaid');
  Memo1.Lines.Add('classDiagram');
  Memo1.Lines.Add('direction RL');
  if Borland.Checked then begin
    fsl := FindAllFiles('/n4800/dos/bp70/DISK12/RTLTV', '*.PAS');
  end else begin
    fsl := FindAllFiles('/home/tux/fpcupdeluxe_avr5/fpcsrc/packages/fv/src', '*.pas;*.inc');
  end;
  for i := 0 to fsl.Count - 1 do begin
    uname := '';
    sl := TStringList.Create;
    sl.LoadFromFile(fsl[i]);
    for j := 0 to sl.Count - 1 do begin
      s := sl[j];
      sa := s.Split([' ', ';']);
      if Length(sa) >= 2 then begin
        if UpCase(sa[0]) = 'UNIT' then  begin
          uname := sa[1];
        end;
      end;
      s := StringReplace(s, ' ', '', [rfIgnoreCase, rfReplaceAll]);
      if Pos('OBJECT(T', UpCase(s)) > 0 then begin
        sa := s.Split(['=', '(', ')']);
        if Length(sa) >= 3 then begin
          Memo1.Lines.Add(sa[0] + '<..' + sa[2]);
          if uname <> ' ' then  begin
            Memo1.Lines.Add(sa[0] + ':unit ' + uname);
          end;
          st := sa[0];
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
  if Borland.Checked then begin
    Memo1.Lines.SaveToFile('/n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/FreeVision/Turbo_Vision_Class_Tree.md');
  end else begin
    Memo1.Lines.SaveToFile('/n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/FreeVision/Class_Tree.md');
  end;
end;

end.
