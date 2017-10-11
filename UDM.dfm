object DM: TDM
  OldCreateOrder = False
  Height = 360
  Width = 628
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'https://api.freexml.com.br/v1'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 24
    Top = 8
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 88
    Top = 8
  end
  object RESTResponse: TRESTResponse
    ContentType = 'application/json'
    Left = 168
    Top = 8
  end
end
