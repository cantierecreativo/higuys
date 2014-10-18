Airbrake.configure do |config|
  config.api_key = '2ad6d046227ec61d79ad56f4d2dafba1'
  config.host    = 'errbit.cantierecreativo.net'
  config.port    = 80
  config.secure  = config.port == 443
end
