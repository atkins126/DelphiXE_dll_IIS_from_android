object WebModule1: TWebModule1
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end>
  BeforeDispatch = WebModuleBeforeDispatch
  Height = 408
  Width = 586
  object HTTPSoapDispatcher1: THTTPSoapDispatcher
    Dispatcher = c
    WebDispatch.MethodType = mtAny
    WebDispatch.PathInfo = 'soap*'
    Left = 60
    Top = 11
  end
  object c: THTTPSoapPascalInvoker
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soUTF8InHeader]
    Left = 60
    Top = 67
  end
  object WSDLHTMLPublish1: TWSDLHTMLPublish
    WebDispatch.MethodType = mtGet
    WebDispatch.PathInfo = 'wsdl*'
    TargetNamespace = 'http://tempuri.org/'
    PublishOptions = [poUTF8ContentType]
    Left = 60
    Top = 123
  end
  object qFast: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 168
    Top = 72
  end
  object DB: TADOConnection
    Attributes = [xaCommitRetaining]
    CommandTimeout = 0
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=***************;Persist Security Info=T' +
      'rue;User ID=***************;Initial Catalog=***************;Data Source=***************' +
      'k-main;Current Language=Russian;Use Procedure for Prepare=0;Auto' +
      ' Translate=True;Packet Size=4096;Application Name=MyApp_DB;Works' +
      'tation ID=COMPUTER;Use Encryption for Data=False;Replication ser' +
      'ver name connect option=True;Tag with column collation when poss' +
      'ible=False'
    ConnectionTimeout = 900
    CursorLocation = clUseServer
    IsolationLevel = ilReadCommitted
    KeepConnection = False
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'SQLOLEDB.1'
    Left = 168
    Top = 18
  end
  object qFast2: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 168
    Top = 128
  end
  object qFast3: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 232
    Top = 16
  end
  object qFast4: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 232
    Top = 72
  end
  object qFast5: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 232
    Top = 128
  end
  object qFast6: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 288
    Top = 72
  end
  object qFast7: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 288
    Top = 128
  end
  object qFast8: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 288
    Top = 24
  end
  object qFast9: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 336
    Top = 24
  end
  object qFast10: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 336
    Top = 72
  end
  object qFast11: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 336
    Top = 128
  end
  object qFast12: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 384
    Top = 24
  end
  object qFast13: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 384
    Top = 72
  end
  object qFast14: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 384
    Top = 128
  end
  object qFast15: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 432
    Top = 24
  end
  object qFast16: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 432
    Top = 72
  end
  object qFast17: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 432
    Top = 128
  end
  object qFast18: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 480
    Top = 24
  end
  object qFast19: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 480
    Top = 72
  end
  object qFast20: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 480
    Top = 128
  end
  object qFast21: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 168
    Top = 184
  end
  object qFast22: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 232
    Top = 184
  end
  object qFast23: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 288
    Top = 184
  end
  object qFast24: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 336
    Top = 184
  end
  object qFast25: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 384
    Top = 184
  end
  object qFast26: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 432
    Top = 184
  end
  object qFast27: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 480
    Top = 184
  end
  object qFast28: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 168
    Top = 240
  end
  object qFast29: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 232
    Top = 240
  end
  object qFast30: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 288
    Top = 240
  end
  object qFast31: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 336
    Top = 240
  end
  object qFast32: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 384
    Top = 240
  end
  object qFast33: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 432
    Top = 240
  end
  object qFast34: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 480
    Top = 240
  end
  object qFast35: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 168
    Top = 296
  end
  object qFast36: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 232
    Top = 296
  end
  object qFast37: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 288
    Top = 296
  end
  object qFast38: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 336
    Top = 296
  end
  object qFast39: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 384
    Top = 296
  end
  object qFast40: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 432
    Top = 296
  end
  object qFast41: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 480
    Top = 296
  end
  object qFast42: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 168
    Top = 352
  end
  object qFast43: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 232
    Top = 352
  end
  object qFast45: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 288
    Top = 352
  end
  object qFast46: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 336
    Top = 352
  end
  object qFast47: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 384
    Top = 352
  end
  object qFast48: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 432
    Top = 352
  end
  object qFast49: TADOQuery
    Connection = DB
    CursorType = ctStatic
    CommandTimeout = 60000
    Parameters = <>
    Left = 480
    Top = 352
  end
  object TimerAdoTest: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = TimerAdoTestTimer
    Left = 64
    Top = 192
  end
  object ADOtest: TADOQuery
    Connection = DB
    Parameters = <>
    SQL.Strings = (
      'SELECT 1')
    Left = 64
    Top = 256
  end
end
