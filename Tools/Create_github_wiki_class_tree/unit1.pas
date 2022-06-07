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
    CheckBox1: TCheckBox;
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
  s, st: string;
  sa: TStringArray;
begin
  Memo1.Clear;
  Memo1.Lines.Add('```mermaid');
  Memo1.Lines.Add('classDiagram');
  Memo1.Lines.Add('direction RL');
  //  fsl := FindAllFiles('/home/tux/fpcupdeluxe_avr5/fpcsrc/packages/fv/src', '*.pas;*.inc');
  fsl := FindAllFiles('/home/tux/fpcupdeluxe_avr5/fpcsrc/packages/fv/src', 'views.inc');
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
          st := sa[0];
        end;
        if CheckBox1.Checked then begin
          p := j;
          repeat
            Inc(p);
            s := sl[p];
            s := StringReplace(s, ' ', '', [rfIgnoreCase, rfReplaceAll]);
            sa := s.Split([':', ';']);
            if Length(sa) >= 2 then begin
              if (Pos('CONSTRUCTOR', UpCase(sl[p])) > 0) or (Pos('DESTRUCTOR', UpCase(sl[p])) > 0) or (Pos('FUNCTION', UpCase(sl[p])) > 0) or
                (Pos('PROCEDURE', UpCase(sl[p])) > 0) then begin
//                Memo1.Lines.Add(st + ':' + sa[1] + '()');
              end else begin
                Memo1.Lines.Add(st + ':' + sa[0] + ' ' + sa[1]);
              end;
            end;


          until Pos(' END;', UpCase(sl[p])) > 0;

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
  if CheckBox1.Checked then begin
    Memo1.Lines.SaveToFile('/n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/FreeVision/Class_Tree_with_identifier.md');
  end else begin
    Memo1.Lines.SaveToFile('/n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/FreeVision/Class_Tree.md');
  end;
end;

end.
