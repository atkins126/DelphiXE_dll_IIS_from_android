unit WebModuleUnit1;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, Soap.InvokeRegistry, EncdDecd,
  Soap.WSDLIntf, System.TypInfo, Soap.WebServExp, Soap.WSDLBind, Xml.XMLSchema, synacode,
  Soap.WSDLPub, Soap.SOAPPasInv, Soap.SOAPHTTPPasInv, Soap.SOAPHTTPDisp, System.Variants,
  Soap.WebBrokerSOAP, Soap.SOAPHTTPTrans, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls;

type
  TWebModule1 = class(TWebModule)
    HTTPSoapDispatcher1: THTTPSoapDispatcher;
    c: THTTPSoapPascalInvoker;
    WSDLHTMLPublish1: TWSDLHTMLPublish;
    qFast: TADOQuery;
    DB: TADOConnection;
    qFast2: TADOQuery;
    qFast3: TADOQuery;
    qFast4: TADOQuery;
    qFast5: TADOQuery;
    qFast6: TADOQuery;
    qFast7: TADOQuery;
    qFast8: TADOQuery;
    qFast9: TADOQuery;
    qFast10: TADOQuery;
    qFast11: TADOQuery;
    qFast12: TADOQuery;
    qFast13: TADOQuery;
    qFast14: TADOQuery;
    qFast15: TADOQuery;
    qFast16: TADOQuery;
    qFast17: TADOQuery;
    qFast18: TADOQuery;
    qFast19: TADOQuery;
    qFast20: TADOQuery;
    qFast21: TADOQuery;
    qFast22: TADOQuery;
    qFast23: TADOQuery;
    qFast24: TADOQuery;
    qFast25: TADOQuery;
    qFast26: TADOQuery;
    qFast27: TADOQuery;
    qFast28: TADOQuery;
    qFast29: TADOQuery;
    qFast30: TADOQuery;
    qFast31: TADOQuery;
    qFast32: TADOQuery;
    qFast33: TADOQuery;
    qFast34: TADOQuery;
    qFast35: TADOQuery;
    qFast36: TADOQuery;
    qFast37: TADOQuery;
    qFast38: TADOQuery;
    qFast39: TADOQuery;
    qFast40: TADOQuery;
    qFast41: TADOQuery;
    qFast42: TADOQuery;
    qFast43: TADOQuery;
    qFast45: TADOQuery;
    qFast46: TADOQuery;
    qFast47: TADOQuery;
    qFast48: TADOQuery;
    qFast49: TADOQuery;
    TimerAdoTest: TTimer;
    ADOtest: TADOQuery;
    procedure StartTimer;
    procedure StopTimer;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleBeforeDispatch(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    function GetToken(aString, SepChar: string; TokenNum: Byte): string;
    function NumToken(aString, SepChar: string): Byte;
    procedure TimerAdoTestTimer(Sender: TObject);
    procedure Reconnect;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{$R *.dfm}


var
  query:integer=0;

function cuts(s: string): string;
var
  i: integer;
  r: string;
begin
  result := '';
  r := '';
  for i := 1 to Length(s) do
  begin
    if not (s[i] in ['"', ':']) then
      r := r + s[i];
  end;
  result := r;

end;


function TWebModule1.GetToken(aString, SepChar: string; TokenNum: Byte): string;
{
параметры: aString : полная строка

SepChar : единственный символ, служащий
разделителем между словами (подстроками)
TokenNum: номер требуемого слова (подстроки))
result    : искомое слово или пустая строка, если количество слов

меньше значения 'TokenNum'
}
var

  Token: string;
  StrLen: Byte;
  TNum: Byte;
  TEnd: Byte;

begin

  StrLen := Length(aString);
  TNum := 1;
  TEnd := StrLen;
  while ((TNum <= TokenNum) and (TEnd <> 0)) do
  begin
    TEnd := Pos(SepChar, aString);
    if TEnd <> 0 then
    begin
      Token := Copy(aString, 1, TEnd - 1);
      Delete(aString, 1, TEnd);
      Inc(TNum);
    end
    else
    begin
      Token := aString;
    end;
  end;
  if TNum >= TokenNum then
  begin
    result := Token;
  end
  else
  begin
    result := '';
  end;
end;

function TWebModule1.NumToken(aString, SepChar: string): Byte;
{
parameters: aString : полная строка
SepChar : единственный символ, служащий
разделителем между словами (подстроками)
result    : количество найденных слов (подстрок)
}

var

  RChar: Char;
  StrLen: Byte;
  TNum: Byte;
  TEnd: Byte;

begin

  if SepChar = '#' then
  begin
    RChar := '*'
  end
  else
  begin
    RChar := '#'
  end;
  StrLen := Length(aString);
  TNum := 0;
  TEnd := StrLen;
  while TEnd <> 0 do
  begin
    Inc(TNum);
    TEnd := Pos(SepChar, aString);
    if TEnd <> 0 then
    begin
      aString[TEnd] := RChar;
    end;
  end;
  Result := TNum;
end;




procedure TWebModule1.TimerAdoTestTimer(Sender: TObject);
begin
  try
    ADOtest.Close;
    ADOtest.Open;
  except
    Reconnect;
  end;
end;

procedure TWebModule1.Reconnect;
var Counter: Integer;
  List: TList;
begin
  if not DB.Connected then Exit;
  StopTimer;
  ADOtest.Connection := nil;

  List := TList.Create;
  try
    for Counter := 0 to DB.DataSetCount - 1 do
    begin
      TADOQuery(DB.DataSets[Counter]).Tag := 0;
      List.Add(DB.DataSets[Counter]);
    end;
    while DB.DataSetCount > 0 do DB.DataSets[0].Connection := nil;
    DB.Close;
    for Counter := 0 to List.Count - 1 do TADOQuery(List[Counter]).Connection := DB;

    ADOtest.Connection := DB;
    List.Clear;
  finally
    List.Free;
  end;
  StartTimer;
end;

procedure TWebModule1.StartTimer;
begin
  TimerAdoTest.Enabled := True;
end;

procedure TWebModule1.StopTimer;
begin
  TimerAdoTest.Enabled := False;
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  i, j: integer;
  s: string;
  F: TextFile;
  FileName: string;
  nt: integer;
  gt, gt2: string;
  idmerch: integer;
  idclient: integer;
  rw_number: integer;


  sel_us_t:string;
  qn:string;
  dev_id:string;
begin


 {FileName := 'Log.txt';
  AssignFile(F, FileName);
  if FileExists(FileName) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, 'Завершение работы: ' + FormatDateTime('hh:nn:ss', Now));
  CloseFile(F);
                 }


//WSDLHTMLPublish1.ServiceInfo(Sender, Request, Response, Handled)
//  Response.Content :=
//  String(Request.ContentFields.Values['text']);
  s := '';

  //Тестна очень долгий запрос
   if (length(Request.ContentFields.Values['testz']) <> 0) then
   begin

   query:=0;

   try
      qFast22.Close;
      qFast22.SQL.Text:='exec test_bool_z ';
      qFast22.Open;

       s := '{' + #13 +
        '"data":[' + #13;
      qFast22.First;
      for I := 0 to qFast22.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"r1":"' + cuts(qFast22.FieldByName('r1').AsString) + '",' + #13;
        s := s + '"r2":"' + cuts(qFast22.FieldByName('r2').AsString) + '",' + #13;
        s := s + '"r3":"' + cuts(qFast22.FieldByName('r3').AsString) + '",' + #13;
        s := s + '"r4":"' + cuts(qFast22.FieldByName('r4').AsString) + '",' + #13;
        s := s + '"r5":"' + cuts(qFast22.FieldByName('r5').AsString) + '"' + #13;

        if i = qFast22.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast22.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
     on E:Exception do

      s := 'Ошибка выполнения запроса на шаге test'+E.message;
    end;
   end;

   //0. Получаем логин и пароль (для сервиса)
       //1. Получаем список заданий (1-я вкладка)
  if (length(Request.ContentFields.Values['s_login']) <> 0) and
    (length(Request.ContentFields.Values['s_pass']) <> 0) then
  begin

    dev_id:='';
    if (length(Request.ContentFields.Values['dev_id']) <> 0) then
     dev_id:=Request.ContentFields.Values['dev_id'];


    query:=1;

         try
      qFast26.Close;
      qFast26.SQL.Text := 'exec merchandiser_android_s_login :s_login, :s_pass, :dev_id';
      qFast26.Parameters.ParamByName('s_login').Value := Request.ContentFields.Values['s_login'];
      qFast26.Parameters.ParamByName('s_pass').Value := Request.ContentFields.Values['s_pass'];
      qFast26.Parameters.ParamByName('dev_id').Value := dev_id;
      qFast26.Open;

       s := '{' + #13 +
        '"data":[' + #13;
      qFast26.First;
      for I := 0 to qFast26.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"login":"' + cuts(qFast26.FieldByName('login').AsString) + '",' + #13;
        s := s + '"pass":"' + cuts(qFast26.FieldByName('pass').AsString) + '",' + #13;
        s := s + '"id":"' + cuts(qFast26.FieldByName('id').AsString) + '"' + #13;

        if i = qFast26.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast26.Next;
      end;

      s := s + ']' + #13 +
        '}';

    except
     on E:Exception do

      s := 'Ошибка выполнения запроса на шаге 0-1'+E.message;
    end;
  end;




         //1. Получаем список заданий (1-я вкладка)
  if (length(Request.ContentFields.Values['us_id_list']) <> 0) and
    (length(Request.ContentFields.Values['in_date']) <> 0) then
  begin

     query:=1;

      try
      qFast16.Close;
      qFast16.SQL.Text := 'exec merchandiser_android_s_job2 :id_merch, :in_date';
      qFast16.Parameters.ParamByName('id_merch').Value := strtoint(Request.ContentFields.Values['us_id_list']);
      qFast16.Parameters.ParamByName('in_date').Value := strtoint(Request.ContentFields.Values['in_date']);
      qFast16.Open;


      s := '{' + #13 +
        '"data":[' + #13;
      qFast16.First;
      for I := 0 to qFast16.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"sm_id_merchandiser":"' + cuts(qFast16.FieldByName('sm_id_merchandiser').AsString) + '",' + #13;
        s := s + '"sm_id_client":"' + cuts(qFast16.FieldByName('sm_id_client').AsString) + '",' + #13;
        s := s + '"id_schedulle_merch":"' + cuts(qFast16.FieldByName('id_schedulle_merch').AsString) + '",' + #13;
        s := s + '"clName":"' + cuts(qFast16.FieldByName('clName').AsString) + '",' + #13;
        s := s + '"urAdr":"' + cuts(qFast16.FieldByName('urAdr').AsString) + '",' + #13;
        s := s + '"stz":"' + cuts(qFast16.FieldByName('stz').AsString) + '",' + #13;
        s := s + '"m_startdate":"' + (qFast16.FieldByName('m_startdate').AsString) + '",' + #13;
        s := s + '"m_stopdate":"' + (qFast16.FieldByName('m_stopdate').AsString) + '",' + #13;
                s := s + '"vers":"33",' + #13;
                 s := s + '"sm_date":"' + cuts(qFast16.FieldByName('sm_date').AsString) + '",' + #13;
        s := s + '"ltask":"' + cuts(qFast16.FieldByName('ltask').AsString) + '",' + #13;
        s := s + '"login":"' + cuts(qFast16.FieldByName('login').AsString) + '",' + #13;
        s := s + '"pass":"' + cuts(qFast16.FieldByName('pass').AsString) + '",' + #13;
        s := s + '"priority":"' + cuts(qFast16.FieldByName('priority').AsString) + '",' + #13;
        s := s + '"sm_dopvozvr":"' + cuts(qFast16.FieldByName('sm_dopvozvr').AsString) + '",' + #13;
        s := s + '"sm_dopFun":"' + cuts(qFast16.FieldByName('sm_dopFun').AsString) + '",' + #13;
        s := s + '"fk_requirement_writeoff":"' + cuts(qFast16.FieldByName('fk_requirement_writeoff').AsString) + '"' + #13;

        if i = qFast16.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast16.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
     on E:Exception do

      s := 'Ошибка выполнения запроса на шаге 1-2'+E.message;
    end;
  end;



    //1. Получаем список заданий (1-я вкладка)
  if (length(Request.ContentFields.Values['login']) <> 0) and
    (length(Request.ContentFields.Values['pass']) <> 0) and
    (length(Request.ContentFields.Values['in_date']) <> 0) then
  begin

    query:=3;

    try
      qFast.Close;
      qFast.SQL.Text := 'exec merchandiser_android_s_job :login, :pass, :in_date, :in_to, :ver2 ';
      qFast.Parameters.ParamByName('login').Value := Request.ContentFields.Values['login'];
      qFast.Parameters.ParamByName('pass').Value := Request.ContentFields.Values['pass'];
      qFast.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date'];
      if length(Request.ContentFields.Values['in_to'])<>0 then
       qFast.Parameters.ParamByName('in_to').Value := Request.ContentFields.Values['in_to'] else
       qFast.Parameters.ParamByName('in_to').Value := 0;
      if length(Request.ContentFields.Values['ver2'])<>0 then
      qFast.Parameters.ParamByName('ver2').Value := Request.ContentFields.Values['ver2'] else
      qFast.Parameters.ParamByName('ver2').Value := '-';
      qFast.Open;


      s := '{' + #13 +
        '"data":[' + #13;
      qFast.First;
      for I := 0 to qFast.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"sm_id_merchandiser":"' + cuts(qFast.FieldByName('sm_id_merchandiser').AsString) + '",' + #13;
        s := s + '"sm_id_client":"' + cuts(qFast.FieldByName('sm_id_client').AsString) + '",' + #13;
        s := s + '"id_schedulle_merch":"' + cuts(qFast.FieldByName('id_schedulle_merch').AsString) + '",' + #13;
        s := s + '"clName":"' + cuts(qFast.FieldByName('clName').AsString) + '",' + #13;
        s := s + '"urAdr":"' + cuts(qFast.FieldByName('urAdr').AsString) + '",' + #13;
        s := s + '"stz":"' + cuts(qFast.FieldByName('stz').AsString) + '",' + #13;
        s := s + '"m_startdate":"' + (qFast.FieldByName('m_startdate').AsString) + '",' + #13;
        s := s + '"m_stopdate":"' + (qFast.FieldByName('m_stopdate').AsString) + '",' + #13;
        s := s + '"vers":"33",' + #13;
        s := s + '"sm_date":"' + cuts(qFast.FieldByName('sm_date').AsString) + '",' + #13;
        s := s + '"ltask":"' + cuts(qFast.FieldByName('ltask').AsString) + '",' + #13;
        s := s + '"login":"' + cuts(qFast.FieldByName('login').AsString) + '",' + #13;
        s := s + '"pass":"' + cuts(qFast.FieldByName('pass').AsString) + '",' + #13;
        s := s + '"priority":"' + cuts(qFast.FieldByName('priority').AsString) + '",' + #13;
        s := s + '"sm_dopvozvr":"' + cuts(qFast.FieldByName('sm_dopvozvr').AsString) + '",' + #13;
        s := s + '"sm_dopFun":"' + cuts(qFast.FieldByName('sm_dopFun').AsString) + '",' + #13;
        s := s + '"fk_requirement_writeoff":"' + cuts(qFast.FieldByName('fk_requirement_writeoff').AsString) + '"' + #13;
        if i = qFast.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast.Next;
      end;
      s := s + ']' + #13 +
        '}';

    Except
    on E : Exception do
      s := 'Ошибка выполнения запроса на шаге 1'+e.Message;
    end;
  end;

  if (length(Request.ContentFields.Values['info']) <> 0) then
  begin

    query:=4;
    s := 'Версия программы на сервере <b>64.0</b><br>от ***** Скачать обновление <br>можно на <b>*********</b>';

  end;





  //7. Документы для мерчендайзера
    if (length(Request.ContentFields.Values['client_id_zdoc']) <> 0) and
    (length(Request.ContentFields.Values['merch_id_zdoc']) <> 0) and
    (length(Request.ContentFields.Values['in_date_zdoc']) <> 0) then
  begin

    query:=5;

    if (length(Request.ContentFields.Values['Docidz']) <> 0) then
   begin
    if Request.ContentFields.Values['Docidz']<>'0' then
      begin
         qFast13.Close;
         qFast13.SQL.Text := 'exec merch_docs_u1 :Docidz';
         qFast13.Parameters.ParamByName('Docidz').Value := Request.ContentFields.Values['Docidz'];
         qFast13.ExecSQL;
      end;
    end;



      try
      qFast12.Close;
      qFast12.SQL.Text := 'exec merch_docs_s1 :client_id_zdoc, :merch_id_zdoc, :in_date_zdoc';
      qFast12.Parameters.ParamByName('client_id_zdoc').Value := Request.ContentFields.Values['client_id_zdoc'];
      qFast12.Parameters.ParamByName('merch_id_zdoc').Value := Request.ContentFields.Values['merch_id_zdoc'];
      qFast12.Parameters.ParamByName('in_date_zdoc').Value := Request.ContentFields.Values['in_date_zdoc'];
      qFast12.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast12.First;
      for I := 0 to qFast12.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"Id_Schedule_merch":"' + cuts(qFast12.FieldByName('Id_Schedule_merch').AsString) + '",' + #13;
        s := s + '"mark_text":"' + cuts(qFast12.FieldByName('mark_text').AsString) + '",' + #13;
        s := s + '"document":"' + cuts(qFast12.FieldByName('document').AsString) + '",' + #13;
        s := s + '"mark_on_exec":"' + cuts(qFast12.FieldByName('mark_on_exec').AsString) + '"' + #13;

        if i = qFast12.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;
        qFast12.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 7' + E.Message;
      end;
    end;


  end;


  //7-1 Документы для мерчендайзера (СЕРВИС) +7 дней  (не добавлен)
  if (length(Request.ContentFields.Values['zdoc_det_merch_idz']) <> 0) and
  (length(Request.ContentFields.Values['zdoc_to_datez']) <> 0)  then
  begin

      query:=6;

         try
      qFast27.Close;
      qFast27.SQL.Text := 'exec merch_docs_s2 :zdoc_det_merch_idz, :zdoc_to_datez';
      qFast27.Parameters.ParamByName('zdoc_det_merch_idz').Value := Request.ContentFields.Values['zdoc_det_merch_idz'];
      qFast27.Parameters.ParamByName('zdoc_to_datez').Value := Request.ContentFields.Values['zdoc_to_datez'];
      qFast27.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast27.First;
      for I := 0 to qFast27.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_Schedule_merch":"' + cuts(qFast27.FieldByName('id_Schedule_merch').AsString) + '",' + #13;
        s := s + '"mark_text":"' + cuts(qFast27.FieldByName('mark_text').AsString) + '",' + #13;
        s := s + '"document":"' + cuts(qFast27.FieldByName('document').AsString) + '",' + #13;
        s := s + '"merch_id":"' + cuts(qFast27.FieldByName('merch_id').AsString) + '",' + #13;
        s := s + '"sm_id_client":"' + cuts(qFast27.FieldByName('sm_id_client').AsString) + '",' + #13;
        s := s + '"mark_on_exec":"' + cuts(qFast27.FieldByName('mark_on_exec').AsString) + '"' + #13;

        if i = qFast27.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;
        qFast27.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 7-1' + E.Message;
      end;
    end;

  end;



    //8. Завершение задание для мерчендайзера
    if (length(Request.ContentFields.Values['client_id_rep']) <> 0) and
    (length(Request.ContentFields.Values['merch_id_rep']) <> 0) and
    (length(Request.ContentFields.Values['in_date_rep']) <> 0) then
  begin


       query:=7;

       if (length(Request.ContentFields.Values['CommentMerchRep']) <> 0) then
    begin
        qFast14.Close;
        qFast14.SQL.Text := 'exec merchandiser_android_s_post_comment_i :client_id, :merch_id, :in_date, :commentt';
        qFast14.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_rep'];
        qFast14.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_rep'];
        qFast14.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_rep'];
        qFast14.Parameters.ParamByName('commentt').Value := Utf8ToAnsi(DecodeString((Request.ContentFields.Values['CommentMerchRep'])));
        qFast14.ExecSQL;
    end;


        if (length(Request.ContentFields.Values['last_lat']) <> 0) and
    (length(Request.ContentFields.Values['last_lng']) <> 0) then
  begin
     qFast17.Close;
     qFast17.SQL.Text:='exec merch_gps_i :id_merch, :id_client, :last_lat, :last_lng';
     qFast17.Parameters.ParamByName('id_merch').Value:=Request.ContentFields.Values['merch_id_rep'];
     qFast17.Parameters.ParamByName('id_client').Value:=Request.ContentFields.Values['client_id_rep'];
     qFast17.Parameters.ParamByName('last_lat').Value:=Request.ContentFields.Values['last_lat'];
     qFast17.Parameters.ParamByName('last_lng').Value:=Request.ContentFields.Values['last_lng'];
     qFast17.ExecSQL;
  end;

   if (length(Request.ContentFields.Values['stzr']) <> 0) then
   begin
    if Request.ContentFields.Values['stzr']='1' then
      begin
        qFast11.Close;
        qFast11.SQL.Text:='exec merch_sh_zadanie_det_i2 :client_id, :merch_id, :in_date';
        qFast11.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_rep'];
        qFast11.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_rep'];
        qFast11.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_rep'];
        qFast11.ExecSQL;
      end;
   end;


     try
      qFast10.Close;
      qFast10.SQL.Text := 'exec merch_sh_zadanie_det :client_id, :merch_id, :in_date';
      qFast10.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_rep'];
      qFast10.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_rep'];
      qFast10.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_rep'];
      qFast10.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast10.First;
      for I := 0 to qFast10.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedulle_merch":"' + cuts(qFast10.FieldByName('id_schedulle_merch').AsString) + '",' + #13;
        s := s + '"sm_task":"' + cuts(qFast10.FieldByName('sm_task').AsString) + '",' + #13;
        s := s + '"m_startdate":"' + (qFast10.FieldByName('m_startdate').AsString) + '",' + #13;
        s := s + '"m_stopdate":"' + (qFast10.FieldByName('m_stopdate').AsString) + '",' + #13;
        s := s + '"priority":"' + cuts(qFast10.FieldByName('priority').AsString) + '",' + #13;
        s := s + '"sm_who_create_job":"' + cuts(qFast10.FieldByName('sm_who_create_job').AsString) + '",' + #13;
        s := s + '"sm_date_send":"' + (qFast10.FieldByName('sm_date_send').AsString) + '",' + #13;
        s := s + '"drivd":"' + cuts(qFast10.FieldByName('drivd').AsString) + '",' + #13;
        s := s + '"cardriver":"' + cuts(qFast10.FieldByName('cardriver').AsString) + '",' + #13;
        s := s + '"sm_dopvozvr":"' + cuts(qFast10.FieldByName('sm_dopvozvr').AsString) + '",' + #13;
        s := s + '"sm_dopFun":"' + cuts(qFast10.FieldByName('sm_dopFun').AsString) + '",' + #13;
        s := s + '"fk_requirement_writeoff":"' + cuts(qFast10.FieldByName('fk_requirement_writeoff').AsString) + '"' + #13;

        if i = qFast10.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast10.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 8' + E.Message;
      end;
    end;

  end;

  //Детали заказа 2я вкладка (СЕРВИС!)
      if (length(Request.ContentFields.Values['merch_id_zadanie_det']) <> 0) and
    (length(Request.ContentFields.Values['in_date_zadanie_det']) <> 0) then
    begin

    query:=8;


       try
      qFast29.Close;
      qFast29.SQL.Text := 'exec merch_sh_zadanie_det_new :merch_id_zadanie_det, :in_date_zadanie_det';
      qFast29.Parameters.ParamByName('merch_id_zadanie_det').Value := Request.ContentFields.Values['merch_id_zadanie_det'];
      qFast29.Parameters.ParamByName('in_date_zadanie_det').Value := Request.ContentFields.Values['in_date_zadanie_det'];
      qFast29.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast29.First;
      for I := 0 to qFast29.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedulle_merch":"' + cuts(qFast29.FieldByName('id_schedulle_merch').AsString) + '",' + #13;
        s := s + '"sm_task":"' + cuts(qFast29.FieldByName('sm_task').AsString) + '",' + #13;
        s := s + '"m_startdate":"' + (qFast29.FieldByName('m_startdate').AsString) + '",' + #13;
        s := s + '"m_stopdate":"' + (qFast29.FieldByName('m_stopdate').AsString) + '",' + #13;
        s := s + '"priority":"' + cuts(qFast29.FieldByName('priority').AsString) + '",' + #13;
        s := s + '"sm_who_create_job":"' + cuts(qFast29.FieldByName('sm_who_create_job').AsString) + '",' + #13;
        s := s + '"sm_date_send":"' + (qFast29.FieldByName('sm_date_send').AsString) + '",' + #13;
        s := s + '"drivd":"' + cuts(qFast29.FieldByName('drivd').AsString) + '",' + #13;
        s := s + '"sm_date":"' + cuts(qFast29.FieldByName('sm_date').AsString) + '",' + #13;
        s := s + '"sm_id_merchandiser":"' + cuts(qFast29.FieldByName('sm_id_merchandiser').AsString) + '",' + #13;
        s := s + '"sm_id_client":"' + cuts(qFast29.FieldByName('sm_id_client').AsString) + '",' + #13;
        s := s + '"cardriver":"' + cuts(qFast29.FieldByName('cardriver').AsString) + '",' + #13;
        s := s + '"sm_dopvozvr":"' + cuts(qFast29.FieldByName('sm_dopvozvr').AsString) + '",' + #13;
        s := s + '"sm_dopFun":"' + cuts(qFast29.FieldByName('sm_dopFun').AsString) + '",' + #13;
        s := s + '"fk_requirement_writeoff":"' + cuts(qFast29.FieldByName('fk_requirement_writeoff').AsString) + '"' + #13;

        if i = qFast29.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast29.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 8-1' + E.Message;
      end;
    end;

    end;



  //1. Задание для мерчендайзера
    if (length(Request.ContentFields.Values['client_id_comm']) <> 0) and
    (length(Request.ContentFields.Values['merch_id_comm']) <> 0) and
    (length(Request.ContentFields.Values['in_date_comm']) <> 0) then
  begin

     query:=9;

      if (length(Request.ContentFields.Values['last_lat']) <> 0) and
    (length(Request.ContentFields.Values['last_lng']) <> 0) then
  begin
     qFast17.Close;
     qFast17.SQL.Text:='exec merch_gps_i :id_merch, :id_client, :last_lat, :last_lng';
     qFast17.Parameters.ParamByName('id_merch').Value:=Request.ContentFields.Values['merch_id_comm'];
     qFast17.Parameters.ParamByName('id_client').Value:=Request.ContentFields.Values['client_id_comm'];
     qFast17.Parameters.ParamByName('last_lat').Value:=Request.ContentFields.Values['last_lat'];
     qFast17.Parameters.ParamByName('last_lng').Value:=Request.ContentFields.Values['last_lng'];
     qFast17.ExecSQL;
  end;


   if (length(Request.ContentFields.Values['stz']) <> 0) then
   begin
    if Request.ContentFields.Values['stz']='1' then
      begin
        qFast11.Close;
        qFast11.SQL.Text:='exec merch_sh_zadanie_det_i :client_id, :merch_id, :in_date';
        qFast11.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_comm'];
        qFast11.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_comm'];
        qFast11.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_comm'];
        qFast11.ExecSQL;
      end;
   end;


     try
      qFast10.Close;
      qFast10.SQL.Text := 'exec merch_sh_zadanie_det :client_id, :merch_id, :in_date';
      qFast10.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_comm'];
      qFast10.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_comm'];
      qFast10.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_comm'];
      qFast10.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast10.First;
      for I := 0 to qFast10.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedulle_merch":"' + cuts(qFast10.FieldByName('id_schedulle_merch').AsString) + '",' + #13;
        s := s + '"sm_task":"' + cuts(qFast10.FieldByName('sm_task').AsString) + '",' + #13;
        s := s + '"m_startdate":"' + (qFast10.FieldByName('m_startdate').AsString) + '",' + #13;
        s := s + '"priority":"' + cuts(qFast10.FieldByName('priority').AsString) + '",' + #13;
        s := s + '"sm_who_create_job":"' + cuts(qFast10.FieldByName('sm_who_create_job').AsString) + '",' + #13;
        s := s + '"sm_date_send":"' + (qFast10.FieldByName('sm_date_send').AsString) + '",' + #13;
        s := s + '"drivd":"' + cuts(qFast10.FieldByName('drivd').AsString) + '",' + #13;
        s := s + '"cardriver":"' + cuts(qFast10.FieldByName('cardriver').AsString) + '"' + #13;

        if i = qFast10.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast10.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 3' + E.Message;
      end;
    end;

  end;



  //6-1. ДОКУМЕНТЫ (состав) 5 вкладка  (ДЛЯ СЕРВИСА)     !!!`
  if (length(Request.ContentFields.Values['vozv_det_merch_id']) <> 0)  then
  begin

     query:=10;

     try

      qFast24.Close;
      qFast24.SQL.Text := 'exec merch_sh_requirement_writeoff_3_s :vozv_det_merch_id';
      qFast24.Parameters.ParamByName('vozv_det_merch_id').Value := Request.ContentFields.Values['vozv_det_merch_id'];
      qFast24.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast24.First;
      for I := 0 to qFast24.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"number_name":"' + cuts(qFast24.FieldByName('number_name').AsString) + '",' + #13;
        s := s + '"id_requirement_writeoff_item":"' + cuts(qFast24.FieldByName('id_requirement_writeoff_item').AsString) + '",' + #13;
        s := s + '"id_rw":"' + cuts(qFast24.FieldByName('id_rw').AsString) + '",' + #13;

        s := s + '"id_number":"' + cuts(qFast24.FieldByName('id_number').AsString) + '",' + #13;
        s := s + '"term_date":"' + cuts(qFast24.FieldByName('term_date').AsString) + '",' + #13;
        s := s + '"fk_requirement_writeoff":"' + cuts(qFast24.FieldByName('fk_requirement_writeoff').AsString) + '",' + #13;
        s := s + '"id_posil":"' + cuts(qFast24.FieldByName('id_posil').AsString) + '",' + #13;
        s := s + '"na_date":"' + cuts(qFast24.FieldByName('na_date').AsString) + '",' + #13;
        s := s + '"na_number":"' + cuts(qFast24.FieldByName('na_number').AsString) + '",' + #13;
        s := s + '"nds_percent":"' + cuts(qFast24.FieldByName('nds_percent').AsString) + '",' + #13;
        s := s + '"diff":"' + cuts(qFast24.FieldByName('diff').AsString) + '",' + #13;
        s := s + '"pe_name":"' + cuts(qFast24.FieldByName('pe_name').AsString) + '",' + #13;
        s := s + '"id_client":"' + cuts(qFast24.FieldByName('id_client').AsString) + '",' + #13;
        s := s + '"pos_quantity":"' + cuts(qFast24.FieldByName('pos_quantity').AsString) + '",' + #13;
        s := s + '"nu_stripcode":"' + cuts(qFast24.FieldByName('nu_stripcode').AsString) + '",' + #13;
        s := s + '"nu_year":"' + cuts(qFast24.FieldByName('nu_year').AsString) + '",' + #13;
        s := s + '"id_subclient":"' + cuts(qFast24.FieldByName('id_subclient').AsString) + '",' + #13;
        s := s + '"cl_name":"' + cuts(qFast24.FieldByName('cl_name').AsString) + '",' + #13;
        s := s + '"fact":"' + cuts(qFast24.FieldByName('fact').AsString) + '",' + #13;
        s := s + '"price":"' + cuts(qFast24.FieldByName('price').AsString) + '",' + #13;
        s := s + '"merch_in":"' + cuts(qFast24.FieldByName('merch_in').AsString) + '"' + #13;

        if i = qFast24.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast24.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 6-1' + E.Message;
      end;
    end;

  end;


   //6. ДОКУМЕНТЫ (состав) 5 вкладка добавление штрихкода
  if (length(Request.ContentFields.Values['id_rw_in']) <> 0)  then
  begin
       try
   if (length(Request.ContentFields.Values['barcodeadd_in']) <> 0) then
    begin
        qFast36.Close;
        qFast36.SQL.Text := 'exec merch_sh_numbers_voz_barcode_i2 :id_rw, :id_client, :barcodeadd';
        qFast36.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['id_rw_in'];
        qFast36.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['client_id_rw_in'];
        qFast36.Parameters.ParamByName('barcodeadd').Value := Request.ContentFields.Values['barcodeadd_in'];
        qFast36.Open;

         s := '{' + #13 +
        '"data":[' + #13;
      qFast36.First;
      for I := 0 to qFast36.RecordCount do
      begin
        s := s + '{' + #13;

   s := s + '"number_name":"' + cuts(qFast36.FieldByName('number_name').AsString) + '",' + #13;
        s := s + '"id_requirement_writeoff_item":"' + cuts(qFast36.FieldByName('id_requirement_writeoff_item').AsString) + '",' + #13;
        s := s + '"id_rw":"' + cuts(qFast36.FieldByName('id_rw').AsString) + '",' + #13;

        s := s + '"id_number":"' + cuts(qFast36.FieldByName('id_number').AsString) + '",' + #13;
        s := s + '"term_date":"' + cuts(qFast36.FieldByName('term_date').AsString) + '",' + #13;
        s := s + '"fk_requirement_writeoff":"' + cuts(qFast36.FieldByName('fk_requirement_writeoff').AsString) + '",' + #13;
        s := s + '"id_posil":"' + cuts(qFast36.FieldByName('id_posil').AsString) + '",' + #13;
        s := s + '"na_date":"' + cuts(qFast36.FieldByName('na_date').AsString) + '",' + #13;
        s := s + '"diff":"' + cuts(qFast36.FieldByName('diff').AsString) + '",' + #13;
        s := s + '"pe_name":"' + cuts(qFast36.FieldByName('pe_name').AsString) + '",' + #13;
        s := s + '"id_client":"' + cuts(qFast36.FieldByName('id_client').AsString) + '",' + #13;
        s := s + '"pos_quantity":"' + cuts(qFast36.FieldByName('pos_quantity').AsString) + '",' + #13;
        s := s + '"nu_stripcode":"' + cuts(qFast36.FieldByName('nu_stripcode').AsString) + '",' + #13;
        s := s + '"nu_year":"' + cuts(qFast36.FieldByName('nu_year').AsString) + '",' + #13;
        s := s + '"id_subclient":"' + cuts(qFast36.FieldByName('id_subclient').AsString) + '",' + #13;
        s := s + '"cl_name":"' + cuts(qFast36.FieldByName('cl_name').AsString) + '",' + #13;
        s := s + '"fact":"' + cuts(qFast36.FieldByName('fact').AsString) + '",' + #13;
        s := s + '"price":"'+cuts(qFast36.FieldByName('price').AsString)+'",' + #13;
        s := s + '"nds_persent":"'+cuts(qFast36.FieldByName('nds_persent').AsString)+'",' + #13;                                  //' + cuts() + '
        s := s + '"merch_in":"' + cuts(qFast36.FieldByName('merch_in').AsString) + '"' + #13;

        if i = qFast36.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast36.Next;

      end;

      if qFast36.RecordCount=0 then
       begin
         s := '';
       end;


      s := s + ']' + #13 +
        '}';





    end;
      except
      on E: Exception do
      begin
        gt := gt+'Ошибка выполнения запроса на шаге 6/5-4' + E.Message;
      end;
    end;
  end;



    //6. ДВОИЧНЫЙ ДОКУМЕНТЫ (состав) 5 вкладка добавление штрихкода
  if (length(Request.ContentFields.Values['id_rw_in']) <> 0)  then
  begin
       try
   if (length(Request.ContentFields.Values['barcodeadd_in2']) <> 0) then
    begin
        qFast45.Close;
        qFast45.SQL.Text := 'exec merch_sh_numbers_voz_barcode_i2 :id_rw, :id_client, :barcodeadd';
        qFast45.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['id_rw_in'];
        qFast45.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['client_id_rw_in'];
        qFast45.Parameters.ParamByName('barcodeadd').Value := Request.ContentFields.Values['barcodeadd_in2'];
        qFast45.Open;

         s := '{' + #13 +
        '"data":[' + #13;
      qFast45.First;
      for I := 0 to qFast45.RecordCount do
      begin
        s := s + '{' + #13;

   s := s + '"number_name":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('number_name').AsString))) + '",' + #13;
        s := s + '"id_requirement_writeoff_item":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('id_requirement_writeoff_item').AsString))) + '",' + #13;
        s := s + '"id_rw":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('id_rw').AsString))) + '",' + #13;
        s := s + '"id_number":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('id_number').AsString))) + '",' + #13;
        s := s + '"term_date":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('term_date').AsString))) + '",' + #13;
        s := s + '"fk_requirement_writeoff":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('fk_requirement_writeoff').AsString))) + '",' + #13;
        s := s + '"id_posil":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('id_posil').AsString))) + '",' + #13;
        s := s + '"na_date":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('na_date').AsString))) + '",' + #13;
        s := s + '"diff":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('diff').AsString))) + '",' + #13;
        s := s + '"pe_name":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('pe_name').AsString))) + '",' + #13;
        s := s + '"id_client":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('id_client').AsString))) + '",' + #13;
        s := s + '"pos_quantity":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('pos_quantity').AsString))) + '",' + #13;
        s := s + '"nu_stripcode":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('nu_stripcode').AsString))) + '",' + #13;
        s := s + '"nu_year":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('nu_year').AsString))) + '",' + #13;
        s := s + '"id_subclient":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('id_subclient').AsString))) + '",' + #13;
        s := s + '"cl_name":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('cl_name').AsString))) + '",' + #13;
        s := s + '"fact":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('fact').AsString))) + '",' + #13;
        s := s + '"price":"'+EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('price').AsString)))+'",' + #13;
        s := s + '"nds_persent":"'+EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('nds_persent').AsString)))+'",' + #13;                                         //' + cuts() + '
        s := s + '"merch_in":"' + EncodeBase64(AnsiToUtf8(cuts(qFast45.FieldByName('merch_in').AsString))) + '"' + #13;

        if i = qFast45.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast45.Next;

      end;

      if qFast45.RecordCount=0 then
       begin
         s := '';
       end;


      s := s + ']' + #13 +
        '}';





    end;
      except
      on E: Exception do
      begin
        gt := gt+'Ошибка выполнения запроса на шаге 6/5-4-2' + E.Message;
      end;
    end;
  end;




   //6. ДОКУМЕНТЫ (состав) 5 вкладка
  if (length(Request.ContentFields.Values['id_rw']) <> 0)  then
  begin


  query:=11;

   try
   if (length(Request.ContentFields.Values['savetrw1']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savetrw1'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savetrw1'], '|', j);

        qFast15.Close;
        qFast15.SQL.Text := 'exec merch_sh_numbers_voz_i :id_rw, :id_client, :id_number, :count';
        qFast15.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['id_rw'];
        qFast15.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['client_id_rw'];
         qFast15.Parameters.ParamByName('id_number').Value := strtoint(GetToken(gt, '=', 1));
        qFast15.Parameters.ParamByName('count').Value := strtoint(GetToken(gt, '=', 2));
        qFast15.ExecSQL;
      end;
    end;
      except
      on E: Exception do
      begin
        gt := gt+'Ошибка выполнения запроса на шаге 6/1' + E.Message;
      end;
    end;


   try
   if (length(Request.ContentFields.Values['savetrw2']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savetrw2'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savetrw2'], '|', j);

        qFast15.Close;
        qFast15.SQL.Text := 'exec merch_sh_numbers_voz_i :id_rw, :id_client, :id_number, :count';
        qFast15.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['id_rw'];
        qFast15.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['client_id_rw'];
        qFast15.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast15.Parameters.ParamByName('count').Value := GetToken(gt, '=', 2);
        qFast15.ExecSQL;
      end;
    end;
      except
      on E: Exception do
      begin
        gt := gt+'Ошибка выполнения запроса на шаге 6/2' + E.Message;
      end;
    end;

       try
   if (length(Request.ContentFields.Values['savetrw3']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savetrw3'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savetrw3'], '|', j);

        qFast15.Close;
        qFast15.SQL.Text := 'exec merch_sh_numbers_voz_i :id_rw, :id_client, :id_number, :count';
        qFast15.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['id_rw'];
        qFast15.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['client_id_rw'];
        qFast15.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast15.Parameters.ParamByName('count').Value := GetToken(gt, '=', 2);
        qFast15.ExecSQL;
      end;
    end;
      except
      on E: Exception do
      begin
        gt := gt+'Ошибка выполнения запроса на шаге 6/3' + E.Message;
      end;
    end;


   try
   if (length(Request.ContentFields.Values['savetrw4']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savetrw4'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savetrw4'], '|', j);

        qFast15.Close;
        qFast15.SQL.Text := 'exec merch_sh_numbers_voz_i :id_rw, :id_client, :id_number, :count';
        qFast15.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['id_rw'];
        qFast15.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['client_id_rw'];
        qFast15.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast15.Parameters.ParamByName('count').Value := GetToken(gt, '=', 2);
        qFast15.ExecSQL;
      end;
    end;
      except
      on E: Exception do
      begin
        gt := gt+'Ошибка выполнения запроса на шаге 6/4' + E.Message;
      end;
    end;


    try
   if (length(Request.ContentFields.Values['barcodeadd']) <> 0) then
    begin
        qFast21.Close;
        qFast21.SQL.Text := 'exec merch_sh_numbers_voz_barcode_i :id_rw, :id_client, :barcodeadd';
        qFast21.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['id_rw'];
        qFast21.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['client_id_rw'];
        qFast21.Parameters.ParamByName('barcodeadd').Value := Request.ContentFields.Values['barcodeadd'];
        qFast21.ExecSQL;
    end;
      except
      on E: Exception do
      begin
        gt := gt+'Ошибка выполнения запроса на шаге 6/5' + E.Message;
      end;
    end;


     try

      qFast9.Close;
      qFast9.SQL.Text := 'exec merch_sh_requirement_writeoff_item_3_s :id_rw, :id_client';
      qFast9.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['id_rw'];
      qFast9.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['client_id_rw'];
      qFast9.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast9.First;
      for I := 0 to qFast9.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_requirement_writeoff_item":"' + cuts(qFast9.FieldByName('id_requirement_writeoff_item').AsString) + '",' + #13;
        s := s + '"id_rw":"' + cuts(qFast9.FieldByName('id_rw').AsString) + '",' + #13;
        s := s + '"id_number":"' + cuts(qFast9.FieldByName('id_number').AsString) + '",' + #13;

        s := s + '"number_name":"' + cuts(qFast9.FieldByName('number_name').AsString) + '",' + #13;
        s := s + '"term_date":"' + cuts(qFast9.FieldByName('term_date').AsString) + '",' + #13;
        s := s + '"fk_requirement_writeoff":"' + cuts(qFast9.FieldByName('fk_requirement_writeoff').AsString) + '",' + #13;
        s := s + '"cl_name":"' + cuts(qFast9.FieldByName('cl_name').AsString) + '",' + #13;
        s := s + '"id_client":"' + cuts(qFast9.FieldByName('id_client').AsString) + '",' + #13;
        s := s + '"na_date":"' + cuts(qFast9.FieldByName('na_date').AsString) + '",' + #13;
        s := s + '"na_number":"' + cuts(qFast9.FieldByName('na_number').AsString) + '",' + #13;
        s := s + '"nds_percent":"' + cuts(qFast9.FieldByName('nds_percent').AsString) + '",' + #13;
        s := s + '"diff":"' + cuts(qFast9.FieldByName('diff').AsString) + '",' + #13;
        s := s + '"pos_quantity":"' + cuts(qFast9.FieldByName('pos_quantity').AsString) + '",' + #13;
        s := s + '"fact":"' + cuts(qFast9.FieldByName('fact').AsString) + '",' + #13;
        s := s + '"nu_stripcode":"' + cuts(qFast9.FieldByName('nu_stripcode').AsString) + '",' + #13;
        s := s + '"price":"' + cuts(qFast9.FieldByName('price').AsString) + '",' + #13;
        s := s + '"pe_name":"' + cuts(qFast9.FieldByName('pe_name').AsString) + '"' + #13;

        if i = qFast9.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast9.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 5/1' + E.Message;
      end;
    end;

  end;




  //5. ДОКУМЕНТЫ 5 вкладка   (СПИСОК)
  if (length(Request.ContentFields.Values['client_id_doc']) <> 0) and
    (length(Request.ContentFields.Values['in_date_doc']) <> 0) then
  begin

     query:=12;

        try

      qFast8.Close;
      qFast8.SQL.Text := 'exec merch_sh_requirement_writeoff_1_s :client_id, :in_date, :merch_id';
      qFast8.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_doc'];
      qFast8.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_doc'];
      qFast8.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['in_date_merc'];
      qFast8.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast8.First;
      for I := 0 to qFast8.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_requirement_writeoff":"' + cuts(qFast8.FieldByName('id_requirement_writeoff').AsString) + '",' + #13;
        s := s + '"rw_date":"' + cuts(qFast8.FieldByName('rw_date').AsString) + '",' + #13;
        s := s + '"rw_number":"' + cuts(qFast8.FieldByName('rw_number').AsString) + '",' + #13;
        s := s + '"flenabled":"' + cuts(qFast8.FieldByName('flenabled').AsString) + '",' + #13;
        s := s + '"rw_status":"' + cuts(qFast8.FieldByName('rw_status').AsString) + '",' + #13;
        s := s + '"rw_return_date":"' + cuts(qFast8.FieldByName('rw_return_date').AsString) + '",' + #13;
        s := s + '"con_number":"' + cuts(qFast8.FieldByName('con_number').AsString) + '",' + #13;
        s := s + '"cl_name":"' + cuts(qFast8.FieldByName('cl_name').AsString) + '",' + #13;
        s := s + '"date_payment":"' + cuts(qFast8.FieldByName('date_payment').AsString) + '"' + #13;

        if i = qFast8.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast8.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 5' + E.Message;
      end;
    end;

  end;


 //5-1. ДОКУМЕНТЫ 5 вкладка   (СПИСОК)  для сервиса   FAST8
  if (length(Request.ContentFields.Values['vozv_merch_id']) <> 0) then
  begin

     query:=13;

     try

      qFast23.Close;
      qFast23.SQL.Text := 'exec merch_sh_requirement_writeoff_2_s :vozv_merch_id';
      qFast23.Parameters.ParamByName('vozv_merch_id').Value := Request.ContentFields.Values['vozv_merch_id'];
      qFast23.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast23.First;
      for I := 0 to qFast23.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_requirement_writeoff":"' + cuts(qFast23.FieldByName('id_requirement_writeoff').AsString) + '",' + #13;
        s := s + '"rw_date":"' + cuts(qFast23.FieldByName('rw_date').AsString) + '",' + #13;
        s := s + '"rw_number":"' + cuts(qFast23.FieldByName('rw_number').AsString) + '",' + #13;
        s := s + '"rw_status":"' + cuts(qFast23.FieldByName('rw_status').AsString) + '",' + #13;
        s := s + '"rw_return_date":"' + cuts(qFast23.FieldByName('rw_return_date').AsString) + '",' + #13;
        s := s + '"con_number":"' + cuts(qFast23.FieldByName('con_number').AsString) + '",' + #13;
        s := s + '"id_subclient":"' + cuts(qFast23.FieldByName('id_subclient').AsString) + '",' + #13;
        s := s + '"id_client":"' + cuts(qFast23.FieldByName('id_client').AsString) + '",' + #13;
        s := s + '"merch_in":"' + cuts(qFast23.FieldByName('merch_in').AsString) + '",' + #13;
        s := s + '"cl_name":"' + cuts(qFast23.FieldByName('cl_name').AsString) + '",' + #13;
        s := s + '"date_payment":"' + cuts(qFast23.FieldByName('date_payment').AsString) + '",' + #13;
        s := s + '"rem_email":"' + cuts(qFast23.FieldByName('rem_email').AsString) + '",' + #13;
        s := s + '"cnt_pos":"' + cuts(qFast23.FieldByName('cnt_pos').AsString) + '"' + #13;

        if i = qFast23.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast23.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 5-1' + E.Message;
      end;
    end;

  end;


  //Добавление фоток с вкладки поставки
 if (length(Request.ContentFields.Values['client_id_pp']) <> 0) and
    (length(Request.ContentFields.Values['merch_id_pp']) <> 0) and
    (length(Request.ContentFields.Values['in_date']) <> 0) and
    (length(Request.ContentFields.Values['path_pp']) <> 0) then
  begin

    try

          qFast49.Close;
          qFast49.SQL.Text := 'exec MERCH_SH_FOTO_POST_I :client_id, :merch_id, :in_date, :file_n, :post_res';
          qFast49.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_pp'];
          qFast49.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_pp'];
          qFast49.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date'];
          qFast49.Parameters.ParamByName('file_n').Value := Request.ContentFields.Values['path_pp'];
          qFast49.Parameters.ParamByName('post_res').Value := 1;
          qFast49.ExecSQL;

          s :='ok';

           except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 4-0' + E.Message;
      end;
    end;

  end;



         //4. Получаем список фоток после 4 вкладка
  if (length(Request.ContentFields.Values['client_id_ph_p']) <> 0) and
    (length(Request.ContentFields.Values['merch_id_ph_p']) <> 0) and
    (length(Request.ContentFields.Values['in_date_ph_p']) <> 0) then
  begin

  query:=14;

    try
          // gt2:= Request.ContentFields.Values['posttextph'];
      if (length(Request.ContentFields.Values['posttextph1_p']) <> 0) then
      begin
        nt := NumToken(Request.ContentFields.Values['posttextph1_p'], '|');
        for j := 1 to nt - 1 do
        begin
          gt2 := GetToken(Request.ContentFields.Values['posttextph1_p'], '|', j);

          qFast6.Close;
          qFast6.SQL.Text := 'exec MERCH_SH_FOTO_POSLE_I :client_id, :merch_id, :in_date, :file_n, :file_n2';
          qFast6.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph_p'];
          qFast6.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph_p'];
          qFast6.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph_p'];
          qFast6.Parameters.ParamByName('file_n').Value := trim(GetToken(gt2, '=', 1));
          qFast6.Parameters.ParamByName('file_n2').Value := trim(GetToken(gt2, '=', 2));
          qFast6.ExecSQL;
        end;
      end;

      if (length(Request.ContentFields.Values['posttextph2_p']) <> 0) then
      begin
        nt := NumToken(Request.ContentFields.Values['posttextph2_p'], '|');
        for j := 1 to nt - 1 do
        begin
          gt2 := GetToken(Request.ContentFields.Values['posttextph2_p'], '|', j);

          qFast6.Close;
          qFast6.SQL.Text := 'exec MERCH_SH_FOTO_POSLE_I :client_id, :merch_id, :in_date, :file_n, :file_n2';
          qFast6.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph_p'];
          qFast6.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph_p'];
          qFast6.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph_p'];
          qFast6.Parameters.ParamByName('file_n').Value := trim(GetToken(gt2, '=', 1));
          qFast6.Parameters.ParamByName('file_n2').Value := trim(GetToken(gt2, '=', 2));
          qFast6.ExecSQL;
        end;
      end;

       if (length(Request.ContentFields.Values['posttextph3_p']) <> 0) then
      begin
        nt := NumToken(Request.ContentFields.Values['posttextph3_p'], '|');
        for j := 1 to nt - 1 do
        begin
          gt2 := GetToken(Request.ContentFields.Values['posttextph3_p'], '|', j);

          qFast6.Close;
          qFast6.SQL.Text := 'exec MERCH_SH_FOTO_POSLE_I :client_id, :merch_id, :in_date, :file_n, :file_n2';
          qFast6.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph_p'];
          qFast6.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph_p'];
          qFast6.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph_p'];
          qFast6.Parameters.ParamByName('file_n').Value := trim(GetToken(gt2, '=', 1));
          qFast6.Parameters.ParamByName('file_n2').Value := trim(GetToken(gt2, '=', 2));
          qFast6.ExecSQL;
        end;
      end;

       if (length(Request.ContentFields.Values['posttextph4_p']) <> 0) then
      begin
        nt := NumToken(Request.ContentFields.Values['posttextph4_p'], '|');
        for j := 1 to nt - 1 do
        begin
          gt2 := GetToken(Request.ContentFields.Values['posttextph4_p'], '|', j);

          qFast6.Close;
          qFast6.SQL.Text := 'exec MERCH_SH_FOTO_POSLE_I :client_id, :merch_id, :in_date, :file_n, :file_n2';
          qFast6.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph_p'];
          qFast6.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph_p'];
          qFast6.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph_p'];
          qFast6.Parameters.ParamByName('file_n').Value := trim(GetToken(gt2, '=', 1));
          qFast6.Parameters.ParamByName('file_n2').Value := trim(GetToken(gt2, '=', 2));
          qFast6.ExecSQL;
        end;
      end;


      qFast4.Close;
      qFast4.SQL.Text := 'exec MERCH_SH_FOTO_DO_S :client_id, :merch_id, :in_date';
      qFast4.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph_p'];
      qFast4.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph_p'];
      qFast4.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph_p'];
      qFast4.Open;


      qFast7.Close;
      qFast7.SQL.Text := 'exec MERCH_SH_FOTO_POSLE_S :client_id, :merch_id, :in_date';
      qFast7.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph_p'];
      qFast7.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph_p'];
      qFast7.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph_p'];
      qFast7.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast7.First;
      for I := 0 to qFast7.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedule_merch":"' + cuts(qFast7.FieldByName('id_schedule_merch').AsString) + '",' + #13;
        s := s + '"adr_foto":"' + cuts(qFast7.FieldByName('adr_foto').AsString) + '",' + #13;
        s := s + '"rating":"' + cuts(qFast7.FieldByName('rating').AsString) + '",' + #13;
        s := s + '"flnotvisible":"' + cuts(qFast7.FieldByName('flnotvisible').AsString) + '",' + #13;
        s := s + '"andr_photo":"' + cuts(qFast7.FieldByName('andr_photo').AsString) + '"' + #13;

        if i = qFast7.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast7.Next;


      end;

      if qFast4.RecordCount>0 then
      s := s + '], "flnv": "1"' + #13 +
        '}' else
      s := s + '], "flnv": "0"' + #13 +
        '}';



    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 4' + E.Message;
      end;
    end;

  end;


         //3. Получаем список фоток до 3 вкладка
  if (length(Request.ContentFields.Values['client_id_ph']) <> 0) and
    (length(Request.ContentFields.Values['merch_id_ph']) <> 0) and
    (length(Request.ContentFields.Values['in_date_ph']) <> 0) then
  begin

  query:=15;

    try
          // gt2:= Request.ContentFields.Values['posttextph'];
      if (length(Request.ContentFields.Values['posttextph1']) <> 0) then
      begin
        nt := NumToken(Request.ContentFields.Values['posttextph1'], '|');
        for j := 1 to nt - 1 do
        begin
          gt2 := GetToken(Request.ContentFields.Values['posttextph1'], '|', j);

          qFast5.Close;
          qFast5.SQL.Text := 'exec MERCH_SH_FOTO_DO_I :client_id, :merch_id, :in_date, :file_n, :file_n2';
          qFast5.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph'];
          qFast5.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph'];
          qFast5.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph'];
          qFast5.Parameters.ParamByName('file_n').Value := trim(GetToken(gt2, '=', 1));
          qFast5.Parameters.ParamByName('file_n2').Value := trim(GetToken(gt2, '=', 2));
          qFast5.ExecSQL;
        end;
      end;

      if (length(Request.ContentFields.Values['posttextph2']) <> 0) then
      begin
        nt := NumToken(Request.ContentFields.Values['posttextph2'], '|');
        for j := 1 to nt - 1 do
        begin
          gt2 := GetToken(Request.ContentFields.Values['posttextph2'], '|', j);

          qFast5.Close;
          qFast5.SQL.Text := 'exec MERCH_SH_FOTO_DO_I :client_id, :merch_id, :in_date, :file_n, :file_n2';
          qFast5.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph'];
          qFast5.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph'];
          qFast5.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph'];
          qFast5.Parameters.ParamByName('file_n').Value := trim(GetToken(gt2, '=', 1));
          qFast5.Parameters.ParamByName('file_n2').Value := trim(GetToken(gt2, '=', 2));
          qFast5.ExecSQL;
        end;
      end;

       if (length(Request.ContentFields.Values['posttextph3']) <> 0) then
      begin
        nt := NumToken(Request.ContentFields.Values['posttextph3'], '|');
        for j := 1 to nt - 1 do
        begin
          gt2 := GetToken(Request.ContentFields.Values['posttextph3'], '|', j);

          qFast5.Close;
          qFast5.SQL.Text := 'exec MERCH_SH_FOTO_DO_I :client_id, :merch_id, :in_date, :file_n, :file_n2';
          qFast5.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph'];
          qFast5.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph'];
          qFast5.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph'];
          qFast5.Parameters.ParamByName('file_n').Value := trim(GetToken(gt2, '=', 1));
          qFast5.Parameters.ParamByName('file_n2').Value := trim(GetToken(gt2, '=', 2));
          qFast5.ExecSQL;
        end;
      end;

       if (length(Request.ContentFields.Values['posttextph4']) <> 0) then
      begin
        nt := NumToken(Request.ContentFields.Values['posttextph4'], '|');
        for j := 1 to nt - 1 do
        begin
          gt2 := GetToken(Request.ContentFields.Values['posttextph4'], '|', j);

          qFast5.Close;
          qFast5.SQL.Text := 'exec MERCH_SH_FOTO_DO_I :client_id, :merch_id, :in_date, :file_n, :file_n2';
          qFast5.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph'];
          qFast5.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph'];
          qFast5.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph'];
          qFast5.Parameters.ParamByName('file_n').Value := trim(GetToken(gt2, '=', 1));
          qFast5.Parameters.ParamByName('file_n2').Value := trim(GetToken(gt2, '=', 2));
          qFast5.ExecSQL;
        end;
      end;


      qFast4.Close;
      qFast4.SQL.Text := 'exec MERCH_SH_FOTO_DO_S :client_id, :merch_id, :in_date';
      qFast4.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_ph'];
      qFast4.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_ph'];
      qFast4.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_ph'];
      qFast4.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast4.First;
      for I := 0 to qFast4.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedule_merch":"' + cuts(qFast4.FieldByName('id_schedule_merch').AsString) + '",' + #13;
        s := s + '"adr_foto":"' + cuts(qFast4.FieldByName('adr_foto').AsString) + '",' + #13;
        s := s + '"rating":"' + cuts(qFast4.FieldByName('rating').AsString) + '",' + #13;
        s := s + '"andr_photo":"' + cuts(qFast4.FieldByName('andr_photo').AsString) + '"' + #13;

        if i = qFast4.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast4.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 3' + E.Message;
      end;
    end;

  end;



        //2. Получаем список товаров 2 вкладка
  if (length(Request.ContentFields.Values['client_id']) <> 0) and
    (length(Request.ContentFields.Values['merch_id']) <> 0) and
    (length(Request.ContentFields.Values['in_date']) <> 0) then
  begin

    query:=16;

    if (length(Request.ContentFields.Values['savet1']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savet1'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savet1'], '|', j);

        qFast3.Close;
        qFast3.SQL.Text := 'exec merchandiser_android_s_list_numb_i :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast3.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id'];
        qFast3.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id'];
        qFast3.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date'];
        qFast3.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast3.Parameters.ParamByName('fact').Value := GetToken(gt, '=', 2);
        qFast3.ExecSQL;

      end;
    end;
            //

    if (length(Request.ContentFields.Values['savet2']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savet2'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savet2'], '|', j);

        qFast3.Close;
        qFast3.SQL.Text := 'exec merchandiser_android_s_list_numb_i :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast3.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id'];
        qFast3.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id'];
        qFast3.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date'];
        qFast3.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast3.Parameters.ParamByName('fact').Value := GetToken(gt, '=', 2);
        qFast3.ExecSQL;

      end;
    end;
            //
    if (length(Request.ContentFields.Values['savet3']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savet3'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savet3'], '|', j);

        qFast3.Close;
        qFast3.SQL.Text := 'exec merchandiser_android_s_list_numb_i :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast3.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id'];
        qFast3.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id'];
        qFast3.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date'];
        qFast3.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast3.Parameters.ParamByName('fact').Value := GetToken(gt, '=', 2);
        qFast3.ExecSQL;

      end;
    end;
            //
    if (length(Request.ContentFields.Values['savet4']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savet4'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savet4'], '|', j);

        qFast3.Close;
        qFast3.SQL.Text := 'exec merchandiser_android_s_list_numb_i :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast3.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id'];
        qFast3.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id'];
        qFast3.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date'];
        qFast3.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast3.Parameters.ParamByName('fact').Value := GetToken(gt, '=', 2);
        qFast3.ExecSQL;

      end;
    end;

     if (length(Request.ContentFields.Values['CommentMerch']) <> 0) then
    begin
        qFast14.Close;
        qFast14.SQL.Text := 'exec merchandiser_android_s_post_comment_i :client_id, :merch_id, :in_date, :commentt';
        qFast14.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id'];
        qFast14.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id'];
        qFast14.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date'];
        qFast14.Parameters.ParamByName('commentt').Value := Utf8ToAnsi(DecodeString((Request.ContentFields.Values['CommentMerch'])));
        qFast14.ExecSQL;
    end;


    try

      qFast2.Close;
      qFast2.SQL.Text := 'exec MERCHANDISER_ANDROID_S_LIST_NUMB2 :client_id, :merch_id, :in_date';
      qFast2.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id'];
      qFast2.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id'];
      qFast2.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date'];
      qFast2.Open;



      s := '{' + #13 +
        '"data":[' + #13;
      qFast2.First;
      for I := 0 to qFast2.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedule_merch":"' + cuts(qFast2.FieldByName('id_schedule_merch').AsString) + '",' + #13;
        s := s + '"id_number":"' + cuts(qFast2.FieldByName('id_number').AsString) + '",' + #13;
        s := s + '"name":"' + cuts(qFast2.FieldByName('NAME').AsString) + '",' + #13;
        s := s + '"barcode":"' + cuts(qFast2.FieldByName('barcode').AsString) + '",' + #13;
        s := s + '"pos_quantity":"' + cuts(qFast2.FieldByName('pos_quantity').AsString) + '",' + #13;
        s := s + '"flenabled":"' + cuts(qFast2.FieldByName('flenabled').AsString) + '",' + #13;
        s := s + '"Fact":"' + cuts(qFast2.FieldByName('Fact').AsString) + '"' + #13;

        if i = qFast2.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast2.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      s := 'Ошибка выполнения запроса на шаге 2';
    end;

  end;


  //2 Список поставок 2 вкладка (СЕРВИС) (не добавлен)
   if (length(Request.ContentFields.Values['postr_det_merch_idz']) <> 0) and
  (length(Request.ContentFields.Values['postr_to_datez']) <> 0)  then
  begin

     query:=17;

     try
      qFast28.Close;
      qFast28.SQL.Text := 'exec MERCHANDISER_ANDROID_S_LIST_NUMB5 :postr_det_merch_idz, :postr_to_datez';
      qFast28.Parameters.ParamByName('postr_det_merch_idz').Value := Request.ContentFields.Values['postr_det_merch_idz'];
      qFast28.Parameters.ParamByName('postr_to_datez').Value := Request.ContentFields.Values['postr_to_datez'];
      qFast28.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast28.First;
      for I := 0 to qFast28.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedule_merch":"' + cuts(qFast28.FieldByName('id_schedule_merch').AsString) + '",' + #13;
        s := s + '"id_number":"' + cuts(qFast28.FieldByName('id_number').AsString) + '",' + #13;
        s := s + '"name":"' + cuts(qFast28.FieldByName('NAME').AsString) + '",' + #13;
        s := s + '"barcode":"' + cuts(qFast28.FieldByName('barcode').AsString) + '",' + #13;
        s := s + '"pos_quantity":"' + cuts(qFast28.FieldByName('pos_quantity').AsString) + '",' + #13;
        s := s + '"flenabled":"' + cuts(qFast28.FieldByName('flenabled').AsString) + '",' + #13;
        s := s + '"merch_id":"' + cuts(qFast28.FieldByName('merch_id').AsString) + '",' + #13;
        s := s + '"id_client":"' + cuts(qFast28.FieldByName('id_client').AsString) + '",' + #13;
        s := s + '"Fact":"' + cuts(qFast28.FieldByName('Fact').AsString) + '"' + #13;

        if i = qFast28.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;
        qFast28.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 2-1' + E.Message;
      end;
    end;

  end;


  //2 Список товаров в реализации 8 вкладка (СЕРВИС)   УСТАРЕЛ
   if (length(Request.ContentFields.Values['postr_det_merch_idz']) <> 0) and
  (length(Request.ContentFields.Values['realiz_to_datez']) <> 0)  then
  begin

     query:=26;

     try
      qFast47.Close;
      qFast47.SQL.Text := 'exec MERCHANDISER_ANDROID_S_LIST_NUMB6 :postr_det_merch_idz, :realiz_to_datez';
      qFast47.Parameters.ParamByName('postr_det_merch_idz').Value := Request.ContentFields.Values['postr_det_merch_idz'];
      qFast47.Parameters.ParamByName('realiz_to_datez').Value := Request.ContentFields.Values['realiz_to_datez'];
      qFast47.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast47.First;
      for I := 0 to qFast47.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedule_merch":"' + cuts(qFast47.FieldByName('id_schedule_merch').AsString) + '",' + #13;
        s := s + '"id_number":"' + cuts(qFast47.FieldByName('id_number').AsString) + '",' + #13;
        s := s + '"name":"' + cuts(qFast47.FieldByName('NAME').AsString) + '",' + #13;
        s := s + '"barcode":"' + cuts(qFast47.FieldByName('barcode').AsString) + '",' + #13;
        s := s + '"pos_quantity":"' + cuts(qFast47.FieldByName('pos_quantity').AsString) + '",' + #13;
        s := s + '"flenabled":"' + cuts(qFast47.FieldByName('flenabled').AsString) + '",' + #13;
        s := s + '"merch_id":"' + cuts(qFast47.FieldByName('merch_id').AsString) + '",' + #13;
        s := s + '"id_client":"' + cuts(qFast47.FieldByName('id_client').AsString) + '",' + #13;
        s := s + '"Fact":"' + cuts(qFast47.FieldByName('Fact').AsString) + '"' + #13;

        if i = qFast47.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;
        qFast47.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 26-1' + E.Message;
      end;
    end;

  end;


  //2 Список товаров в реализации 8 вкладка (СЕРВИС)   НОВЫЙ
   if (length(Request.ContentFields.Values['postr_det_merch_idz2']) <> 0) and
   (length(Request.ContentFields.Values['postr_det_merch_idz2']) <> 0) and
  (length(Request.ContentFields.Values['postr_det_client_idz2']) <> 0)  then
  begin

     query:=26;

     try
      qFast47.Close;
      qFast47.SQL.Text := 'exec merchandiser_android_realiz_s :merch_id, :id_client, :in_date';
      qFast47.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['postr_det_merch_idz2'];
      qFast47.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['postr_det_client_idz2'];
      qFast47.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['postr_det_client_idz2'];
      qFast47.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast47.First;
      for I := 0 to qFast47.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id_schedule_merch":"' + cuts(qFast47.FieldByName('id_schedule_merch').AsString) + '",' + #13;
        s := s + '"id_number":"' + cuts(qFast47.FieldByName('id_number').AsString) + '",' + #13;
        s := s + '"name":"' + EncodeBase64(AnsiToUtf8(cuts(qFast47.FieldByName('NAME').AsString))) + '",' + #13;
        s := s + '"barcode":"' + cuts(qFast47.FieldByName('barcode').AsString) + '",' + #13;
        s := s + '"pos_quantity":"' + cuts(qFast47.FieldByName('pos_quantity').AsString) + '",' + #13;
        s := s + '"flenabled":"' + cuts(qFast47.FieldByName('flenabled').AsString) + '",' + #13;
        s := s + '"merch_id":"' + cuts(qFast47.FieldByName('merch_id').AsString) + '",' + #13;
        s := s + '"id_client":"' + cuts(qFast47.FieldByName('id_client').AsString) + '",' + #13;
        s := s + '"Fact":"' + cuts(qFast47.FieldByName('Fact').AsString) + '"' + #13;

        if i = qFast47.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;
        qFast47.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 26-2' + E.Message;
      end;
    end;

  end;



 //Список планограмм
   if (length(Request.ContentFields.Values['pln_merch_id']) <> 0) and
  (length(Request.ContentFields.Values['planogramm']) <> 0)  then
  begin

     query:=25;

     try
      qFast43.Close;
      qFast43.SQL.Text := 'exec planogram_s1 :merch_id';
      qFast43.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['pln_merch_id'];
     // qFast43.Parameters.ParamByName('postr_to_datez').Value := Request.ContentFields.Values['postr_to_datez'];
      qFast43.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast43.First;
      for I := 0 to qFast43.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"id":"' + EncodeBase64(AnsiToUtf8(qFast43.FieldByName('id').AsString)) + '",' + #13;
        s := s + '"client_id":"' + EncodeBase64(AnsiToUtf8(qFast43.FieldByName('client_id').AsString)) + '",' + #13;
        s := s + '"active":"' + EncodeBase64(AnsiToUtf8(qFast43.FieldByName('active').AsString)) + '",' + #13;
        s := s + '"path":"' + EncodeBase64(AnsiToUtf8(qFast43.FieldByName('path').AsString)) + '",' + #13;
        s := s + '"city_name":"' + EncodeBase64(AnsiToUtf8(qFast43.FieldByName('city_name').AsString)) + '",' + #13;
        s := s + '"cl_name":"' + EncodeBase64(AnsiToUtf8(qFast43.FieldByName('cl_name').AsString)) + '"' + #13;

        if i = qFast43.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;
        qFast43.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 25-1' + E.Message;
      end;
    end;

  end;


  //Сохранение мониторинга сервис   30
   if (length(Request.ContentFields.Values['serv_client_id_mon']) <> 0) and
    (length(Request.ContentFields.Values['serv_merch_id_mon']) <> 0) and
    (length(Request.ContentFields.Values['serv_in_date_mon']) <> 0) then
    begin

      query:=18;

      try
        qFast30.Close;
        qFast30.SQL.Text := 'exec merchandiser_android_s_list_numb_mon_i2 :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast30.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['serv_client_id_mon'];
        qFast30.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['serv_merch_id_mon'];
        qFast30.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['serv_in_date_mon'];
        qFast30.Parameters.ParamByName('id_number').Value := Request.ContentFields.Values['serv_in_id_number'];
        qFast30.Parameters.ParamByName('fact').Value := Request.ContentFields.Values['serv_in_fact'];
        qFast30.Open;

        if qFast30.RecordCount>0 then
          begin

         s := '{' + #13 +
           '"data":[' + #13;
         qFast30.First;
         for I := 0 to qFast30.RecordCount do
         begin
           s := s + '{' + #13;
           s := s + '"client_id":"' + cuts(qFast30.FieldByName('client_id').AsString) + '",' + #13;
           s := s + '"merch_id":"' + cuts(qFast30.FieldByName('merch_id').AsString) + '",' + #13;
           s := s + '"in_date":"' + cuts(qFast30.FieldByName('in_date').AsString) + '",' + #13;
           s := s + '"id_number":"' + cuts(qFast30.FieldByName('id_number').AsString) + '"' + #13;
           if i = qFast30.RecordCount then
             s := s + '}' + #13 else
             s := s + '},' + #13;

           qFast30.Next;
        end;

         s := s + ']' + #13 +
           '}';
            end;

          except
     on E:Exception do
      s := 'Ошибка выполнения запроса на шаге 30'+E.message;
       end;
    end;



      //Сохранение поставок сервис   33-35
   if (length(Request.ContentFields.Values['id_schedulle_merch2']) <> 0) then
    begin

      query:=19;

      try
        //Комментарий к заданию
         if (length(Request.ContentFields.Values['merchcomment']) <> 0) then
          begin

            qn:='1';

           qFast33.Close;
           qFast33.SQL.Text := 'exec merchandiser_android_s_post_comment_i2 :id_schedulle_merch, :commentt';
           qFast33.Parameters.ParamByName('id_schedulle_merch').Value := Request.ContentFields.Values['id_schedulle_merch2'];
           qFast33.Parameters.ParamByName('commentt').Value := Utf8ToAnsi(DecodeString((Request.ContentFields.Values['merchcomment'])));
           qFast33.ExecSQL;
         end;


         //Версия
          if (length(Request.ContentFields.Values['ver2']) <> 0) then
          begin
             qFast48.Close;
             qFast48.SQL.Text:='exec merch_vers_i2 :id_schedulle_merch, :ver2';
             qFast48.Parameters.ParamByName('id_schedulle_merch').Value:=Request.ContentFields.Values['id_schedulle_merch2'];
             qFast48.Parameters.ParamByName('ver2').Value:=vartostr(Request.ContentFields.Values['ver2']);
             qFast48.ExecSQL;
          end;

         //Координаты
          if (length(Request.ContentFields.Values['x2']) <> 0) then
          begin

          qn:='2';

             qFast34.Close;
             qFast34.SQL.Text:='exec merch_gps_i2 :id_schedulle_merch, :last_lat, :last_lng';
             qFast34.Parameters.ParamByName('id_schedulle_merch').Value:=Request.ContentFields.Values['id_schedulle_merch2'];
             qFast34.Parameters.ParamByName('last_lat').Value:=vartostr(Request.ContentFields.Values['x2']);
             qFast34.Parameters.ParamByName('last_lng').Value:=vartostr(Request.ContentFields.Values['y2']);
             qFast34.ExecSQL;
          end else
          begin
             if (length(Request.ContentFields.Values['x1']) <> 0) then
              begin

              qn:='3';

               qFast34.Close;
               qFast34.SQL.Text:='exec merch_gps_i2 :id_schedulle_merch, :last_lat, :last_lng';
               qFast34.Parameters.ParamByName('id_schedulle_merch').Value:=Request.ContentFields.Values['id_schedulle_merch2'];
               qFast34.Parameters.ParamByName('last_lat').Value:=vartostr(Request.ContentFields.Values['x1']);
               qFast34.Parameters.ParamByName('last_lng').Value:=vartostr(Request.ContentFields.Values['y1']);
               qFast34.ExecSQL;
              end;
          end;

         //Начало задания
          if (length(Request.ContentFields.Values['m_startdate']) <> 0) then
          begin

               qn:='4';





               qFast35.Close;
               qFast35.SQL.Text:='exec merch_sh_zadanie_det_i_srv :id_schedulle_merch, :m_startdate, :m_stopdate';
               qFast35.Parameters.ParamByName('id_schedulle_merch').Value:=Request.ContentFields.Values['id_schedulle_merch2'];
               qFast35.Parameters.ParamByName('m_startdate').Value:=Request.ContentFields.Values['m_startdate'];
               qFast35.Parameters.ParamByName('m_stopdate').Value:=Request.ContentFields.Values['m_stopdate'];
               qFast35.Open;

            if qFast35.RecordCount>0 then
          begin

         s := '{' + #13 +
           '"data":[' + #13;
         qFast35.First;
         for I := 0 to qFast35.RecordCount do
         begin
           s := s + '{' + #13;
           s := s + '"id_schedule_merch":"' + cuts(qFast35.FieldByName('id_schedule_merch').AsString) + '"' + #13;
         //  s := s + '"m_startdate":"' + cuts(qFast35.FieldByName('m_startdate').AsString) + '",' + #13;
         //  s := s + '"m_stopdate":"' + cuts(qFast35.FieldByName('m_stopdate').AsString) + '"' + #13;
           if i = qFast35.RecordCount then
             s := s + '}' + #13 else
             s := s + '},' + #13;

           qFast35.Next;
        end;

         s := s + ']' + #13 +
           '}';
            end;
          end;


          except
     on E:Exception do
      s := 'Ошибка выполнения запроса на шаге 33_1'+E.message+'/qn='+qn;
       end;
    end;



      //Сохранение поставок сервис   32
   if (length(Request.ContentFields.Values['serv_id_schedule_merch2']) <> 0) and
    (length(Request.ContentFields.Values['serv_id_number2']) <> 0) then
    begin

      query:=20;


      try
        qFast32.Close;
        qFast32.SQL.Text := 'exec merchandiser_android_s_list_numb_i2 :id_schedule_merch, :id_number, :merch_id, :client_id, :fact';
        qFast32.Parameters.ParamByName('id_schedule_merch').Value := Request.ContentFields.Values['serv_id_schedule_merch2'];
        qFast32.Parameters.ParamByName('id_number').Value := Request.ContentFields.Values['serv_id_number2'];
        qFast32.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['serv_merch_id2'];
        qFast32.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['serv_id_client2'];
        qFast32.Parameters.ParamByName('fact').Value := Request.ContentFields.Values['serv_Fact2'];
        qFast32.Open;

        if qFast32.RecordCount>0 then
          begin

         s := '{' + #13 +
           '"data":[' + #13;
         qFast32.First;
         for I := 0 to qFast32.RecordCount do
         begin
           s := s + '{' + #13;
           s := s + '"id_schedule_merch":"' + cuts(qFast32.FieldByName('id_schedule_merch').AsString) + '",' + #13;
           s := s + '"id_number":"' + cuts(qFast32.FieldByName('id_number').AsString) + '",' + #13;
           s := s + '"merch_id":"' + cuts(qFast32.FieldByName('merch_id').AsString) + '",' + #13;
           s := s + '"id_client":"' + cuts(qFast32.FieldByName('id_client').AsString) + '"' + #13;
           if i = qFast32.RecordCount then
             s := s + '}' + #13 else
             s := s + '},' + #13;

           qFast32.Next;
        end;

         s := s + ']' + #13 +
           '}';
            end;

          except
     on E:Exception do
      s := 'Ошибка выполнения запроса на шаге 32'+E.message;
       end;
    end;


     //Сохранение возвратов сервис   31         exec merch_sh_numbers_voz_i :id_rw, :id_client, :id_number, :count
   if (length(Request.ContentFields.Values['serv_id_rw']) <> 0) and
    (length(Request.ContentFields.Values['serv_id_number']) <> 0) then
    begin

      query:=21;

      try
        qFast31.Close;
        qFast31.SQL.Text := 'exec merch_sh_numbers_voz_i2 :id_rw, :id_client, :id_number, :count';
        qFast31.Parameters.ParamByName('id_rw').Value := Request.ContentFields.Values['serv_id_rw'];
        qFast31.Parameters.ParamByName('id_client').Value := Request.ContentFields.Values['serv_id_client'];
        qFast31.Parameters.ParamByName('id_number').Value := Request.ContentFields.Values['serv_id_number'];
        qFast31.Parameters.ParamByName('count').Value := Request.ContentFields.Values['serv_fact'];
        qFast31.Open;

        if qFast31.RecordCount>0 then
          begin

         s := '{' + #13 +
           '"data":[' + #13;
         qFast31.First;
         for I := 0 to qFast31.RecordCount do
         begin
           s := s + '{' + #13;
           s := s + '"id_rw":"' + cuts(qFast31.FieldByName('id_rw').AsString) + '",' + #13;
           s := s + '"rw_date":"' + cuts(qFast31.FieldByName('rw_date').AsString) + '",' + #13;
           s := s + '"id_number":"' + cuts(qFast31.FieldByName('id_number').AsString) + '",' + #13;
           s := s + '"id_client":"' + cuts(qFast31.FieldByName('id_client').AsString) + '"' + #13;
           if i = qFast31.RecordCount then
             s := s + '}' + #13 else
             s := s + '},' + #13;

           qFast31.Next;
        end;

         s := s + ']' + #13 +
           '}';
            end;

          except
     on E:Exception do
      s := 'Ошибка выполнения запроса на шаге 31'+E.message;
       end;
    end;


  //Мониторинг
   if (length(Request.ContentFields.Values['client_id_mon']) <> 0) and
    (length(Request.ContentFields.Values['merch_id_mon']) <> 0) and
    (length(Request.ContentFields.Values['in_date_mon']) <> 0) then
  begin

     query:=22;

    if (length(Request.ContentFields.Values['savet1_mon']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savet1_mon'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savet1_mon'], '|', j);

        qFast18.Close;
        qFast18.SQL.Text := 'exec merchandiser_android_s_list_numb_mon_i :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast18.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_mon'];
        qFast18.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_mon'];
        qFast18.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_mon'];
        qFast18.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast18.Parameters.ParamByName('fact').Value := GetToken(gt, '=', 2);
        qFast18.ExecSQL;

      end;
    end;
            //

    if (length(Request.ContentFields.Values['savet2_mon']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savet2_mon'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savet2_mon'], '|', j);

        qFast18.Close;
        qFast18.SQL.Text := 'exec merchandiser_android_s_list_numb_mon_i :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast18.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_mon'];
        qFast18.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_mon'];
        qFast18.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_mon'];
        qFast18.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast18.Parameters.ParamByName('fact').Value := GetToken(gt, '=', 2);
        qFast18.ExecSQL;

      end;
    end;
            //
    if (length(Request.ContentFields.Values['savet3_mon']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savet3_mon'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savet3_mon'], '|', j);

        qFast18.Close;
        qFast18.SQL.Text := 'exec merchandiser_android_s_list_numb_mon_i :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast18.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_mon'];
        qFast18.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_mon'];
        qFast18.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_mon'];
        qFast18.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast18.Parameters.ParamByName('fact').Value := GetToken(gt, '=', 2);
        qFast18.ExecSQL;

      end;
    end;
            //
    if (length(Request.ContentFields.Values['savet4_mon']) <> 0) then
    begin
      nt := NumToken(Request.ContentFields.Values['savet4_mon'], '|');
      for j := 1 to nt - 1 do
      begin
        gt := GetToken(Request.ContentFields.Values['savet4_mon'], '|', j);

        qFast18.Close;
        qFast18.SQL.Text := 'exec merchandiser_android_s_list_numb_mon_i :client_id, :merch_id, :in_date, :id_number, :fact';
        qFast18.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_mon'];
        qFast18.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_mon'];
        qFast18.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_mon'];
        qFast18.Parameters.ParamByName('id_number').Value := GetToken(gt, '=', 1);
        qFast18.Parameters.ParamByName('fact').Value := GetToken(gt, '=', 2);
        qFast18.ExecSQL;

      end;
    end;

    try

      qFast19.Close;
      qFast19.SQL.Text := 'exec merchandiser_android_s_list_numb3 :client_id, :merch_id, :in_date';
      qFast19.Parameters.ParamByName('client_id').Value := Request.ContentFields.Values['client_id_mon'];
      qFast19.Parameters.ParamByName('merch_id').Value := Request.ContentFields.Values['merch_id_mon'];
      qFast19.Parameters.ParamByName('in_date').Value := Request.ContentFields.Values['in_date_mon'];
      qFast19.Open;



      s := '{' + #13 +
        '"data":[' + #13;
      qFast19.First;
      for I := 0 to qFast19.RecordCount do
      begin
        s := s + '{' + #13;
        s := s + '"id_number":"' + cuts(qFast19.FieldByName('id_number').AsString) + '",' + #13;
        s := s + '"NAME":"' + cuts(qFast19.FieldByName('NAME').AsString) + '",' + #13;
        s := s + '"barcode":"' + cuts(qFast19.FieldByName('barcode').AsString) + '",' + #13;
        s := s + '"Fact":"' + cuts(qFast19.FieldByName('Fact').AsString) + '"' + #13;
        if i = qFast19.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast19.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      s := 'Ошибка выполнения запроса на шаге 9';
    end;

  end;


   //Мониторинг   (Для сервиса)
   if (length(Request.ContentFields.Values['monit_serv_merch_id']) <> 0) then
  begin

    query:=23;

    try

      qFast25.Close;
      qFast25.SQL.Text := 'exec merchandiser_android_s_list_numb4 :monit_serv_merch_id';
      qFast25.Parameters.ParamByName('monit_serv_merch_id').Value := Request.ContentFields.Values['monit_serv_merch_id'];
      qFast25.Open;



      s := '{' + #13 +
        '"data":[' + #13;
      qFast25.First;
      for I := 0 to qFast25.RecordCount do
      begin
        s := s + '{' + #13;
        s := s + '"id_number":"' + cuts(qFast25.FieldByName('id_number').AsString) + '",' + #13;
        s := s + '"NAME":"' + cuts(qFast25.FieldByName('NAME').AsString) + '",' + #13;
        s := s + '"barcode":"' + cuts(qFast25.FieldByName('barcode').AsString) + '",' + #13;
        s := s + '"merch_id":"' + cuts(qFast25.FieldByName('merch_id').AsString) + '",' + #13;
         s := s + '"id_client":"' + cuts(qFast25.FieldByName('id_client').AsString) + '",' + #13;
         s := s + '"sm_date":"' + cuts(qFast25.FieldByName('sm_date').AsString) + '",' + #13;

        s := s + '"Fact":"' + cuts(qFast25.FieldByName('Fact').AsString) + '"' + #13;
        if i = qFast25.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast25.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      s := 'Ошибка выполнения запроса на шаге 9-1';
    end;

  end;


     //Старшие мерчендайзеры
  if (length(Request.ContentFields.Values['login_sm']) <> 0)  then
  begin
     if (length(Request.ContentFields.Values['password_sm']) <> 0)  then
     begin

     try
          s := '<!DOCTYPE html>'+#13+
           '<html>'+#13+
           '<head>'+#13+
           '<title>Закладка старшего мерчендайзера:</title>'+#13+
           '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+#13+
           '<meta http-equiv="Content-Language" content="ru" />'+#13+
           '<meta http-equiv="Pragma" content="no-cache" />'+#13+
           '<meta http-equiv="Cache-Control" content="no-cache" />'+#13+
           '<style>'+#13+
             'table, th, td {'+#13+
                          'border: 1px solid black;'+#13+
                          'border-collapse: collapse;'+#13+
                          '}'+#13+
                          'th, td {'+#13+
                          'padding: 5px;'+#13+
                          '}'+#13+
          '</style>'+#13+
          '</head>'+#13+
          '<body>'+#13;

            qFast37.Close;
            qFast37.SQL.Text:='exec merch_parent_s1 :login, :pass, :us_par';
            qFast37.Parameters.ParamByName('login').Value := Request.ContentFields.Values['login_sm'];
            qFast37.Parameters.ParamByName('pass').Value := Request.ContentFields.Values['password_sm'];
            qFast37.Parameters.ParamByName('us_par').Value := Request.ContentFields.Values['us_par'];
            qFast37.Open;

            s := s + '<table border=1 width=100% ><tr><td width=20% valign=top>';

            if qFast37.RecordCount>0 then
              begin
                s := s + '<table border=1 width=100% > <tr><td><b>ФИО</b></td><td></td></tr>';
              qFast37.First;
                for I := 0 to qFast37.RecordCount-1 do
                  begin

                     if (i=0) and (length(Request.ContentFields.Values['us_sel'])=0) then
                      begin
                      s := s + '<tr><td><b>'+qFast37.FieldByName('fio').AsString+'</b></td><td>';
                      sel_us_t:=qFast37.FieldByName('id_merchandiser').AsString;
                      end
                      else
                      begin
                       if length(Request.ContentFields.Values['us_sel'])<>0 then
                         begin
                           if Request.ContentFields.Values['us_sel']=qFast37.FieldByName('id_merchandiser').AsString then
                           begin
                             s := s + '<tr><td><b>'+qFast37.FieldByName('fio').AsString+'</b></td><td>';
                            sel_us_t:=qFast37.FieldByName('id_merchandiser').AsString;
                           end
                              else
                             s := s + '<tr><td>'+qFast37.FieldByName('fio').AsString+'</td><td>';

                         end else
                       s := s + '<tr><td>'+qFast37.FieldByName('fio').AsString+'</td><td>';

                      end;
                     s := s +'<form method="POST" action="***************/merch.dll"><input type="hidden" name="us_sel" value="'+qFast37.FieldByName('id_merchandiser').AsString+'"> '+
                     '<input type="hidden" name="us_par" value="'+qFast37.FieldByName('id_merch_parent').AsString+'">'+
                     '<input type="hidden" name="login_sm" value="-1"><input type="hidden" name="password_sm" value="-1"><input type="submit" value=" Отобразить "></form></td></tr>';


                   qFast37.Next;
                  end;
                 s := s + '</table>';
              end;

            s := s + '</td><td width=33% valign=top>';

            //2 столбик
            if sel_us_t<>'' then
            begin
              qFast38.Close;
              qFast38.SQL.Text:='EXEC MERCHANDISER_ANDROID_S_JOB_PR 0, 1, :id_merch';
              qFast38.Parameters.ParamByName('id_merch').Value:= strtoint(sel_us_t);
              qFast38.Open;

              if qFast38.RecordCount>0 then
              begin
                   s := s + '<table border=1 width=100% > <tr><td><b>Клиент</b></td><td><b>Фото до</b></td><td><b>Возвраты</b></td><td><b>Фото после</b></td><td><b>Мониторинг</b></td><td><b>Статус</b></td></tr>';
              qFast38.First;
                for I := 0 to qFast38.RecordCount-1 do
                  begin

                   s := s + '<tr><td>'+qFast38.FieldByName('clName').AsString+'</td><td>';

                     s := s +'<form method="POST" action="***************/merch.dll"><input type="hidden" name="us_sel" value="'+sel_us_t+'"> '+
                     '<input type="hidden" name="us_par" value="'+qFast37.FieldByName('id_merch_parent').AsString+'">'+
                     '<input type="hidden" name="login_sm" value="-1"><input type="hidden" name="password_sm" value="-1"><input type="hidden" name="cl_sm" value="'+qFast38.FieldByName('id_schedulle_merch').AsString+'"><input type="submit" value=">>"></form></td><td>';

                     s := s +'<form method="POST" action="***************/merch.dll"><input type="hidden" name="us_sel" value="'+sel_us_t+'"> '+
                     '<input type="hidden" name="us_par" value="'+qFast37.FieldByName('id_merch_parent').AsString+'">'+
                     '<input type="hidden" name="login_sm" value="-1"><input type="hidden" name="password_sm" value="-1"><input type="hidden" name="cl_sm_cl" value="'+qFast38.FieldByName('sm_id_client').AsString+'"><input type="hidden" name="cl_sm_v" value="'+qFast38.FieldByName('id_schedulle_merch').AsString+'"><input type="submit" value=" *>>"></form>';

                       s := s +'</td><td><form method="POST" action="***************/merch.dll"><input type="hidden" name="us_sel" value="'+sel_us_t+'"> '+
                     '<input type="hidden" name="us_par" value="'+qFast37.FieldByName('id_merch_parent').AsString+'">'+
                     '<input type="hidden" name="login_sm" value="-1"><input type="hidden" name="password_sm" value="-1"><input type="hidden" name="cl_sm_posle" value="'+qFast38.FieldByName('id_schedulle_merch').AsString+'"><input type="submit" value=">>"></form>';

                     s := s +'</td><td><form method="POST" action="***************/merch.dll"><input type="hidden" name="us_sel" value="'+sel_us_t+'"> '+
                     '<input type="hidden" name="us_par" value="'+qFast37.FieldByName('id_merch_parent').AsString+'">'+
                     '<input type="hidden" name="login_sm" value="-1"><input type="hidden" name="password_sm" value="-1"><input type="hidden" name="cl_sm_mon" value="'+qFast38.FieldByName('sm_id_client').AsString+'"><input type="submit" value=">>"></form>';


                     s := s +'</td><td><font size="1">'+qFast38.FieldByName('m_startdate').AsString+'<br>'+qFast38.FieldByName('m_stopdate').AsString+'</font></td></tr>';


                  qFast38.Next;
                  end;

                   s := s + '</table>';
              end;
            end;

            s := s + '</td><td  valign=top>';

             //Мониторинг
                 if (length(Request.ContentFields.Values['cl_sm_mon']) <> 0)  then
                 begin
                    qFast42.Close;
                    qFast42.SQL.Text:='EXEC merchandiser_android_s_list_numb3 :client_id, :merch_id, :in_date ';
                    qFast42.Parameters.ParamByName('client_id').Value:=strtoint(Request.ContentFields.Values['cl_sm_mon']);
                    qFast42.Parameters.ParamByName('merch_id').Value:=strtoint(Request.ContentFields.Values['us_sel']);
                    qFast42.Parameters.ParamByName('in_date').Value:=0;

                    qFast42.Open;

                    if qFast42.RecordCount>0 then
                     begin

                        s := s + '<table border=1 width=100% ><tr><td><b>Наименование</b></td><td><b>кол-во</b></td></tr>';
                       qFast42.First;
                        for I := 0 to qFast42.RecordCount-1 do
                          begin
                            s := s + '<tr><td>'+qFast42.FieldByName('NAME').AsString +'</td><td>'+qFast42.FieldByName('Fact').AsString +'</td></tr>';


                        qFast42.Next;
                        end;

                         s := s + '</table>';
                     end;
                  end;



            //Фотки до
                 if (length(Request.ContentFields.Values['cl_sm']) <> 0)  then
                 begin
                    qFast39.Close;
                    qFast39.SQL.Text:='EXEC MERCHANDISER_ANDROID_S_FOTO_DO :cl_sm ';
                    qFast39.Parameters.ParamByName('cl_sm').Value:=strtoint(Request.ContentFields.Values['cl_sm']);
                    qFast39.Open;

                    if qFast39.RecordCount>0 then
                     begin

                        s := s + '<table border=1 width=100% >';
                       qFast39.First;
                        for I := 0 to qFast39.RecordCount-1 do
                          begin
                            s := s + '<tr><td><a href="/'+qFast39.FieldByName('andr_photo').AsString+'"><img src="/'+qFast39.FieldByName('andr_photo').AsString+'"  width="450"></a></td><td>';


                        qFast39.Next;
                        end;

                         s := s + '</table>';
                     end;
                  end;

                //Фотки после
                 if (length(Request.ContentFields.Values['cl_sm_posle']) <> 0)  then
                 begin
                    qFast39.Close;
                    qFast39.SQL.Text:='EXEC MERCHANDISER_ANDROID_S_FOTO_POSLE :cl_sm ';
                    qFast39.Parameters.ParamByName('cl_sm').Value:=strtoint(Request.ContentFields.Values['cl_sm_posle']);
                    qFast39.Open;

                    if qFast39.RecordCount>0 then
                     begin

                        s := s + '<table border=1 width=100% >';
                       qFast39.First;
                        for I := 0 to qFast39.RecordCount-1 do
                          begin
                            s := s + '<tr><td><a href="/'+qFast39.FieldByName('andr_photo').AsString+'"><img src="/'+qFast39.FieldByName('andr_photo').AsString+'"  width="450"></a></td><td>';


                        qFast39.Next;
                        end;

                         s := s + '</table>';
                     end;
                  end;
             //Документы возврата
                 if (length(Request.ContentFields.Values['cl_sm_cl']) <> 0)  then
                 begin
                    qFast40.Close;
                    qFast40.SQL.Text:='EXEC MERCH_RETURNBYIDCLIENT2 :cl_sm_cl ';
                    qFast40.Parameters.ParamByName('cl_sm_cl').Value:=strtoint(Request.ContentFields.Values['cl_sm_cl']);
                    qFast40.Open;

                    if qFast40.RecordCount>0 then
                     begin

                        s := s + '<table border=1 width=100% >';
                       qFast40.First;
                        for I := 0 to qFast40.RecordCount-1 do
                          begin
                            s := s + '<tr><td>'+qFast40.FieldByName('rw_date').AsString+' - № <b>'+qFast40.FieldByName('rw_number').AsString+'</b></td>';

                             s := s +'<td><form method="POST" action="***************/merch.dll"><input type="hidden" name="us_sel" value="'+sel_us_t+'"> '+
                     '<input type="hidden" name="us_par" value="'+qFast37.FieldByName('id_merch_parent').AsString+'">'+
                     '<input type="hidden" name="login_sm" value="-1"><input type="hidden" name="password_sm" value="-1"><input type="hidden" name="cl_sm_cl" value="'+
                     Request.ContentFields.Values['cl_sm_cl']+'"><input type="hidden" name="cl_sm_v" value="'+Request.ContentFields.Values['cl_sm_v']+
                     '"><input type="hidden" name="cl_sm_doc" value="'+qFast40.FieldByName('id_requirement_writeoff').AsString+
                     '"><input type="submit" value=" *>!"></form></td></tr>';


                        qFast40.Next;
                        end;

                         s := s + '</table>';
                     end;
                  end;

                       //Возврат состав
                 if (length(Request.ContentFields.Values['cl_sm_doc']) <> 0)  then
                 begin
                    qFast41.Close;
                    qFast41.SQL.Text:='EXEC MERCH_SH_REQUIREMENT_WRITEOFF_ITEM_3_S :id_rw, :id_client  ';
                    qFast41.Parameters.ParamByName('id_rw').Value:=strtoint(Request.ContentFields.Values['cl_sm_doc']);
                    qFast41.Parameters.ParamByName('id_client').Value:=strtoint(Request.ContentFields.Values['cl_sm_cl']);
                    qFast41.Open;

                    if qFast41.RecordCount>0 then
                     begin

                        s := s + '<br><table border=1 width=100% ><tr><td><b>Наименование</b></td><td><b>Поставка</b></td><td><b>Факт</b></td></tr>';
                       qFast41.First;
                        for I := 0 to qFast41.RecordCount-1 do
                          begin
                            s := s + '<tr><td>'+qFast41.FieldByName('number_name').AsString+'</td><td>'+qFast41.FieldByName('pos_quantity').AsString+'</td><td>'+qFast41.FieldByName('fact').AsString+'</td></tr>';


                        qFast41.Next;
                        end;

                         s := s + '</table>';
                     end;
                  end;




            s := s + '</td><tr></table>';
            s := s + '</body>'+#13+
                '</html>';

                   except
     on E:Exception do
      s := 'Ошибка выполнения запроса на шаге 31-8'+E.message;
       end;
     end;
  end;

           //2. Получаем список товаров 2 вкладка
  if (length(Request.ContentFields.Values['reportid']) <>0)  then
  begin

      query:=24;

      idmerch := strtoint(copy(Request.ContentFields.Values['reportid'], 1, 3));
      idclient := strtoint(copy(Request.ContentFields.Values['reportid'], 4, 4));
      rw_number := strtoint(copy(Request.ContentFields.Values['reportid'], 8, length(Request.ContentFields.Values['reportid'])));

      qFast20.Close;
      qFast20.SQL.Text:='exec merch_sh_requirement_writeoff_item_4_s :rw_number, :id_client';
      qFast20.Parameters.ParamByName('rw_number').Value := rw_number;
      qFast20.Parameters.ParamByName('id_client').Value := idclient;
      qFast20.Open;
      //формируем код html-страницы
      s := '<!DOCTYPE html>'+#13+
           '<html>'+#13+
           '<head>'+#13+
           '<title>Завка на отбор из возвратов:</title>'+#13+
           '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+#13+
           '<meta http-equiv="Content-Language" content="ru" />'+#13+
           '<meta http-equiv="Pragma" content="no-cache" />'+#13+
           '<meta http-equiv="Cache-Control" content="no-cache" />'+#13+
           '<style>'+#13+
             'table, th, td {'+#13+
                          'border: 1px solid black;'+#13+
                          'border-collapse: collapse;'+#13+
                          '}'+#13+
                          'th, td {'+#13+
                          'padding: 5px;'+#13+
                          '}'+#13+
          '</style>'+#13+
          '</head>'+#13+
          '<body>'+#13;

        s :=s+'<div style="text-align: right;">'+#13+
               'Плательщик '+cuts(qFast20.FieldByName('cl_full_name').AsString)+'</br>'+#13;
        s :=s+'Договор № '+cuts(qFast20.FieldByName('con_number').AsString)+' поставки от '+cuts(qFast20.FieldByName('con_sign_date').AsString)+'</br>'+#13;
        s :=s+'Клиент '+cuts(qFast20.FieldByName('cl_name').AsString)+#13;
        s :=s+'</div>'+#13;

        s :=s+'<p><h2 style="text-align: center;">Просим произвести к '+cuts(qFast20.FieldByName('rw_return_date').AsString)+' возврат следующих изданий</h2></p>'+#13;
        s :=s+ '<table style="width:100%">'+#13;
        s :=s+'<tr>'+#13+
              '<th>№ п/п</th>'+#13+
              '<th>Наименование товара</th>'+#13+
              '<th>Отпускная цена</th>'+#13+
              '<th>Дата отгрузки</th>'+#13+
              '<th>Дата ОСР</th>'+#13+
              '<th>Edition</th>'+#13+
              '<th>Количество</th>'+#13+
              '<th>Штрих-код</th>'+#13+
              '</tr>'+#13;

      qFast20.First;
      for I := 0 to qFast20.RecordCount do
      begin
           s := s + '<tr>'+ #13;
           s := s + '<td>'+cuts(qFast20.FieldByName('row_n').AsString)+'</td>'+ #13;
           s := s + '<td>'+cuts(qFast20.FieldByName('number_name').AsString)+'</td>'+ #13;
           s := s + '<td>'+cuts(qFast20.FieldByName('pos_price').AsString)+'</td>'+ #13;
           s := s + '<td>'+cuts(qFast20.FieldByName('na_date').AsString)+'</td>'+ #13;
           s := s + '<td>'+cuts(qFast20.FieldByName('term_date').AsString)+'</td>'+ #13;
           s := s + '<td>'+cuts(qFast20.FieldByName('pos_quantity').AsString)+'</td>'+ #13;
           s := s + '<td>'+cuts(qFast20.FieldByName('fact').AsString)+'</td>'+ #13;
           s := s + '<td>'+cuts(qFast20.FieldByName('nu_stripcode').AsString)+'</td>'+ #13;
           s := s +'</tr>'+ #13;
           qFast20.Next;
      end;

      s := s + '</table>'+#13+
                '</body>'+#13+
                '</html>';
      //отправляем на почту
      if Request.ContentFields.Values['mailname'] <>'' then
      begin
        qFast.Close;
          qFast.SQL.Text := 'EXEC send_em :to,:title,:txt';
          qFast.Parameters.ParamByName('to').Value := Request.ContentFields.Values['mailname'];
          qFast.Parameters.ParamByName('title').Value := 'Возврат по номеру документа: '+cuts(Request.ContentFields.Values['reportid']);
          qFast.Parameters.ParamByName('txt').Value := s;
        qFast.ExecSQL;
        s:='<!DOCTYPE html>'+#13+
           '<html>'+#13+
           '<head>'+#13+
           '<title>Завка на отбор из возвратов:</title>'+#13+
           '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+#13+
           '<meta http-equiv="Content-Language" content="ru" />'+#13+
           '<meta http-equiv="Pragma" content="no-cache" />'+#13+
           '<meta http-equiv="Cache-Control" content="no-cache" />'+#13+
           '</head>'+#13+
           '<body>'+#13;
         s :=s+'<p><h2 style="text-align: center;">Отчет отправлен на email:'+cuts(Request.ContentFields.Values['mailname'])+'</h2></p>'+#13;
         s := s + '</body>'+#13+
                 '</html>';
      end;

  end;



//5-1. Удаленные задания для сервиса   FAST46
  if (length(Request.ContentFields.Values['del_doc']) <> 0) then
  begin

     query:=46;

     try

      qFast46.Close;
      qFast46.SQL.Text := 'exec schedulle_merch_del_s';
      qFast46.Open;

      s := '{' + #13 +
        '"data":[' + #13;
      qFast46.First;
      for I := 0 to qFast46.RecordCount do
      begin
        s := s + '{' + #13;

        s := s + '"merch_id":"' + cuts(qFast46.FieldByName('merch_id').AsString) + '",' + #13;
        s := s + '"in_date":"' + cuts(qFast46.FieldByName('in_date').AsString) + '",' + #13;
        s := s + '"ver":"' + cuts(qFast46.FieldByName('ver').AsString) + '",' + #13;
        s := s + '"path_v":"' + cuts(qFast46.FieldByName('path_v').AsString) + '",' + #13;
        s := s + '"id_sch_merch":"' + cuts(qFast46.FieldByName('id_sch_merch').AsString) + '"' + #13;

        if i = qFast46.RecordCount then
          s := s + '}' + #13 else
          s := s + '},' + #13;

        qFast46.Next;


      end;

      s := s + ']' + #13 +
        '}';

    except
      on E: Exception do
      begin
        s := 'Ошибка выполнения запроса на шаге 46-1' + E.Message;
      end;
    end;

  end;



    qFast.Close;
    qFast.SQL.Text := 'EXEC merch_zap_log_i :param, :query';
    qFast.Parameters.ParamByName('param').Value := Request.ContentFields.GetText + #13 + s + '!' + gt;
    qFast.Parameters.ParamByName('query').Value := query;;
    qFast.ExecSQL;


 if pos('шибка', s)>0 then
  begin
    qFast.Close;
    qFast.SQL.Text := 'EXEC send_em :to,:title,:txt';
    qFast.Parameters.ParamByName('to').Value := '***************';
    qFast.Parameters.ParamByName('title').Value := 'Android';
    qFast.Parameters.ParamByName('txt').Value := Request.ContentFields.GetText + #13 + s + '!' + gt;
    qFast.ExecSQL;
  end;






  Response.Content := trim(s);
end;





procedure TWebModule1.WebModuleBeforeDispatch(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'TEXT/HTML; CHARSET=UTF-8';
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
var
  parameter: string;
  s: string;
begin
  DB.Connected := false;
  DB.ConnectionString := 'Provider=SQLOLEDB.1;Password=***************;' +
    'Persist Security Info=True;User ID=***************;Initial Catalog=***************;' +
    'Data Source=***************;Current Language=Russian;Use Procedure for Prepare=0;' +
    'Auto Translate=True;Packet Size=4096;Application Name=MyApp_DB;Workstation ID=COMPUTER;' +
    'Use Encryption for Data=False;Replication server name connect option=True;' +
    'Tag with column collation when possible=False';
  DB.Connected := true;

  TimerAdoTest.Enabled:=true;
end;

end.

