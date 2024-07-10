var MercadoPago;

var merchantIdDev = 'APP_USR-4aff5490-e206-433a-877e-dc0288084288';
var environment = 'DEV';

function mercadopagoHandleSuccess() {
  MercadoPago = new MercadoPago(merchantIdDev);
  console.log(`MercadoPago CDN lib loaded successfully on ${environment} environment loaded!`);
}

function mercadopagoHandleError() {
  MercadoPagoLibraryFailure.postMessage('Error loading MercadoPago script');
}
