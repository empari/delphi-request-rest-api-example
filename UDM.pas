unit UDM;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Types, System.JSON,
  IdMultipartFormData;

type
  TDM = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
  private
    { Private declarations }
  public
    { Public declarations }
    Token, TenantID, AccountID: String;

    function RestResponseGetData(RESTResponse: TRESTResponse): TJSONObject;
    function RestResponseGetMeta(RESTResponse: TRESTResponse): TJSONObject;
    function JSONGetData(JSONObject: TJSONObject; Value: String): TJSONObject;
    function JSONGetArray(JSONObject: TJSONObject; Value: String): TJSONArray;
    function JSONGetValue(JSONObject: TJSONObject; Value: String): String;
    function RemoveChar(STR: string;CHR: char): string;
    function UploadFile(FileName: String): TJSONObject;

    procedure TratarErro(RESTResponse: TRESTResponse);
    procedure RestClientConfigAuth;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }


function TDM.JSONGetArray(JSONObject: TJSONObject; Value: String): TJSONArray;
var
  Obj: TJSONObject;
  Rows: TJSONPair;
begin
  Obj := JSONGetData(JSONObject, Value);
  if (Obj.GetValue('data') <> nil) then
  begin
    Rows := Obj.Get('data');
    Result := Rows.JsonValue as TJSONArray;
  end else
    Result := nil;
end;

function TDM.JSONGetData(JSONObject: TJSONObject; Value: String): TJSONObject;
var
  Rows: TJSONPair;
begin
  if (JSONObject.GetValue(Value) <> nil) then
  begin
    Rows := JSONObject.Get(Value);
    Result := Rows.JsonValue as TJSONObject;
  end else
    Result := nil;
end;

function TDM.JSONGetValue(JSONObject: TJSONObject; Value: String): String;
begin
  Result := RemoveChar(JSONObject.GetValue(Value).ToString, '"')
end;

function TDM.RemoveChar(STR: string; CHR: char): string;
var
	cont : integer;
begin
	Result := '';
	for cont := 1 to Length(STR) do begin
		if (STR[cont] <> CHR) then
			Result := Result + STR[cont];
	end;
end;

procedure TDM.RestClientConfigAuth;
begin
  with RESTRequest.Params.AddItem do
  begin
    Kind := TRESTRequestParameterKind.pkHTTPHEADER;
    name := 'Authorization';
    Value := 'Bearer '+ Token;
    Options := [TRESTRequestParameterOption.poDoNotEncode];
  end;

  with RESTRequest.Params.AddItem do
  begin
    Kind := TRESTRequestParameterKind.pkHTTPHEADER;
    name := 'Content-Tenant';
    Value := TenantID;
    Options := [TRESTRequestParameterOption.poDoNotEncode];
  end;

  with RESTRequest.Params.AddItem do
  begin
    Kind := TRESTRequestParameterKind.pkHTTPHEADER;
    name := 'Content-Account';
    Value := AccountID;
    Options := [TRESTRequestParameterOption.poDoNotEncode];
  end;
end;

function TDM.RestResponseGetData(RESTResponse: TRESTResponse): TJSONObject;
var
  Obj: TJSONObject;
  Rows: TJSONPair;
begin
  Obj := RESTResponse.JSONValue as TJSONObject;
  if Obj.GetValue('data') <> nil then
  begin
    Rows := Obj.Get('data');
    Result := Rows.JsonValue as TJSONObject;
  end else
    Result := nil;
end;

function TDM.RestResponseGetMeta(RESTResponse: TRESTResponse): TJSONObject;
var
  Obj: TJSONObject;
  Rows: TJSONPair;
begin
  Obj := RESTResponse.JSONValue as TJSONObject;
  if Obj.GetValue('meta') <> nil then
  begin
    Rows := Obj.Get('meta');
    Result := Rows.JsonValue as TJSONObject;
  end else
    Result := nil;
end;

procedure TDM.TratarErro(RESTResponse: TRESTResponse);
var
  Obj: TJSONObject;
  Rows: TJSONPair;
begin
  Obj :=  JSONGetData(RestResponseGetData(RESTResponse), 'error');
  if Obj <> nil then
    raise Exception.Create(JSONGetValue(Obj, 'message'));
end;

function TDM.UploadFile(FileName: String): TJSONObject;
var
  LBytes: TBytes;
  Stream: TFileStream;
  vFormData: TIdMultiPartFormDataStream;
begin
  if not FileExists(FileName) then Exit;

  try
    vFormData := TIdMultiPartFormDataStream.Create;
    Stream := TFileStream.Create(FileName, fmOpenRead);
    Stream.Position := 0;

    RESTRequest.Resource := '/libraries';
    RESTRequest.Method := TRESTRequestMethod.rmPOST;

    RESTRequest.ClearBody;
    RESTRequest.Params.Clear;
    RestClientConfigAuth;

    vFormData.AddFormField('description', ExtractFileName(FileName));
    vFormData.AddFormField('file', 'multipart/form-data', 'utf-8', Stream, ExtractFileName(FileName));
    
    RESTRequest.AddBody(vFormData, ctNone);

    SetLength(LBytes, vFormData.Size);
    vFormData.Seek(0, TSeekOrigin.soBeginning);
    vFormData.Read(LBytes, 0, vFormData.Size);

    RESTRequest.Params.Delete('Content-Type');
    RESTRequest.Params.AddItem('Content-Type',
      vFormData.RequestContentType,
      TREstRequestParameterKind.pkHTTPHEADER,
      [poDoNotEncode],
      TRESTContentType.ctAPPLICATION_OCTET_STREAM);

    RESTRequest.Execute;
    TratarErro(RESTResponse);

    Result := RestResponseGetData(RESTResponse);
  finally
    vFormData.Free;
    Stream.Free;
  end;
end;

end.
