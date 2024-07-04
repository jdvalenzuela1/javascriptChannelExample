var kushki;

// TODO: use env vars
var merchantIdDev = '305139590a0e45cc8a6369dfd89a288f';
var merchantIdProd = '74657de2632c40049cfc6af3e0eafdef';

function handleSuccess(isDevOrTest) {
  var environment = (isDevOrTest) ? 'DEV' : 'PROD';
  console.log(`Kushki CDN library was successfully loaded. Initiating Kushki on ${environment} environment`);

  kushki = new Kushki({
    merchantId: (isDevOrTest) ? (merchantIdDev) : (merchantIdProd),
    inTestEnvironment: isDevOrTest,
  });
}

function handleError() {
  KushkiLibraryFailure.postMessage('Error loading Kushki script');
}
