var kushki;

var merchantIdDev = '305139590a0e45cc8a6369dfd89a288f';
var environment = 'DEV';

function kushkiHandleSuccess() {
  console.log(`Kushki CDN library was successfully loaded. Initiating Kushki on ${environment} environment`);

  kushki = new Kushki({
    merchantId: merchantIdDev,
    inTestEnvironment: true,
  });
}

function kushkiHandleError() {
  KushkiLibraryFailure.postMessage('Error loading Kushki script');
}
