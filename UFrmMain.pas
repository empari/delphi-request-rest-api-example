unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, REST.Types, System.JSON;

type
  TFrmMain = class(TForm)
    GroupBox1: TGroupBox;
    btnInspire: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    mmStatus: TMemo;
    TabSheet2: TTabSheet;
    mmJson: TMemo;
    btnLogin: TButton;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    mmToken: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtEmail: TEdit;
    edtSenha: TEdit;
    edtTenantID: TEdit;
    edtAccountID: TEdit;
    btnUploadFile: TButton;
    procedure btnInspireClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnUploadFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  Obj: TJSONObject;
  Rows: TJSONArray;

implementation

{$R *.dfm}

uses UDM;

procedure TFrmMain.btnInspireClick(Sender: TObject);
begin
  With DM do
  begin
    mmStatus.Clear;
    RESTRequest.Resource := '/inspiring';
    RESTRequest.Method := TRESTRequestMethod.rmGET;

    RESTRequest.Execute;
    TratarErro(RESTResponse);
    mmJson.Text := RESTResponse.JSONText;

    mmStatus.Lines.Add( JSONGetValue(RestResponseGetData(RESTResponse), 'inspire') );
  end;
end;

procedure TFrmMain.btnLoginClick(Sender: TObject);
begin
  if edtEmail.Text = '' then
  begin
    PageControl1.ActivePageIndex := 2;
    edtEmail.SetFocus;
    Exit;
  end;

  if edtSenha.Text = '' then
  begin
    PageControl1.ActivePageIndex := 2;
    edtSenha.SetFocus;
    Exit;
  end;

  With DM do
  begin
    mmStatus.Clear;
    RESTRequest.Resource := '/auth/login';
    RESTRequest.Method := TRESTRequestMethod.rmPOST;

    RESTRequest.ClearBody;
    RESTRequest.Params.Clear;
    with RESTRequest.Params.AddItem do
    begin
      ContentType := TRESTContentType.ctNone;
      name := 'email';
      Value := edtEmail.Text;
    end;

    with RESTRequest.Params.AddItem do
    begin
      ContentType := TRESTContentType.ctNone;
      name := 'password';
      Value := edtSenha.Text;
    end;

    RESTRequest.Execute;
    TratarErro(RESTResponse);
    mmJson.Text := RESTResponse.JSONText;

    Obj := RestResponseGetMeta(RESTResponse);
    Token := JSONGetValue(Obj, 'token');
    mmToken.Text := JSONGetValue(Obj, 'token');
    mmStatus.Lines.Add('Token: '+ JSONGetValue(Obj, 'token') );

    Obj := RestResponseGetData(RESTResponse);
    mmStatus.Lines.Add('Usuario Logado: '+ JSONGetValue(Obj, 'name') );

    Rows := JSONGetArray(Obj, 'accounts');
    Obj := Rows.Items[0] as TJSONObject;
    AccountID := JSONGetValue(Obj, 'id');
    edtAccountID.Text := JSONGetValue(Obj, 'id');
    mmStatus.Lines.Add('Accound ID: '+ JSONGetValue(Obj, 'id') );

    Obj := JSONGetData(Obj, 'tenant');
    Obj := JSONGetData(Obj, 'data');
    TenantID := JSONGetValue(Obj, 'id');
    edtTenantID.Text := JSONGetValue(Obj, 'id');
    mmStatus.Lines.Add('Tenant ID: '+ JSONGetValue(Obj, 'id') );
  end;
end;

procedure TFrmMain.btnUploadFileClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  if DM.Token = '' then
    raise Exception.Create('Você precisa estar Logado');

  OpenDialog := TOpenDialog.Create(nil);
  try
    with OpenDialog do
    begin
      InitialDir := GetCurrentDir;
      Filter := 'Arquivos XML|*.xml|Todos os arquivos|*.*';

      if Execute then
        with DM do
        begin
          mmStatus.Clear;
          mmStatus.Lines.Add('Upload file started. Wait...');

          Obj := UploadFile(FileName);
          mmJson.Text := Obj.ToJSON;
          mmStatus.Lines.Add('Transaction Success ID: '+ JSONGetValue(Obj, 'id') );
        end;
    end;
  finally
    OpenDialog.Free;
  end;

end;

end.
