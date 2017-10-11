object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Rest Test'
  ClientHeight = 519
  ClientWidth = 929
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 929
    Height = 115
    Align = alTop
    TabOrder = 0
    object btnInspire: TButton
      Left = 16
      Top = 16
      Width = 121
      Height = 25
      Caption = 'Inspire'
      TabOrder = 0
      OnClick = btnInspireClick
    end
    object btnLogin: TButton
      Left = 16
      Top = 47
      Width = 121
      Height = 25
      Caption = 'Login'
      TabOrder = 1
      OnClick = btnLoginClick
    end
    object btnUploadFile: TButton
      Left = 16
      Top = 78
      Width = 121
      Height = 25
      Caption = 'Upload File'
      TabOrder = 2
      OnClick = btnUploadFileClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 115
    Width = 929
    Height = 404
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    ExplicitTop = 121
    ExplicitHeight = 398
    object TabSheet1: TTabSheet
      Caption = 'Log'
      ExplicitHeight = 370
      object mmStatus: TMemo
        Left = 0
        Top = 0
        Width = 921
        Height = 376
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 370
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'JSON'
      ImageIndex = 1
      ExplicitHeight = 370
      object mmJson: TMemo
        Left = 0
        Top = 0
        Width = 921
        Height = 376
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 370
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Logged?'
      ImageIndex = 2
      ExplicitHeight = 370
      object Label1: TLabel
        Left = 12
        Top = 23
        Width = 24
        Height = 13
        Caption = 'Email'
      end
      object Label2: TLabel
        Left = 284
        Top = 23
        Width = 30
        Height = 13
        Caption = 'Senha'
      end
      object Label3: TLabel
        Left = 12
        Top = 78
        Width = 29
        Height = 13
        Caption = 'Token'
      end
      object Label4: TLabel
        Left = 12
        Top = 199
        Width = 48
        Height = 13
        Caption = 'Tenant ID'
      end
      object Label5: TLabel
        Left = 208
        Top = 199
        Width = 53
        Height = 13
        Caption = 'Account ID'
      end
      object mmToken: TMemo
        Left = 12
        Top = 97
        Width = 369
        Height = 89
        TabOrder = 0
      end
      object edtEmail: TEdit
        Left = 12
        Top = 42
        Width = 249
        Height = 21
        TabOrder = 1
      end
      object edtSenha: TEdit
        Left = 284
        Top = 42
        Width = 97
        Height = 21
        PasswordChar = '*'
        TabOrder = 2
      end
      object edtTenantID: TEdit
        Left = 12
        Top = 218
        Width = 181
        Height = 21
        TabOrder = 3
      end
      object edtAccountID: TEdit
        Left = 208
        Top = 218
        Width = 173
        Height = 21
        TabOrder = 4
      end
    end
  end
end
